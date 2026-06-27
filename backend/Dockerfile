# ============================================================
# Stage 1: Build PHP Dependencies
# ============================================================
FROM php:8.4-fpm-alpine AS build-php

WORKDIR /app

RUN apk add --no-cache \
    git curl zip unzip \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
    oniguruma-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    pdo pdo_mysql mbstring exif pcntl bcmath gd xml opcache

COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock* ./
RUN composer install \
    --no-interaction --no-scripts --no-dev \
    --optimize-autoloader --prefer-dist

# ============================================================
# Stage 2: Build Frontend Assets
# ============================================================
FROM node:20-alpine AS build-frontend

WORKDIR /app

COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --no-audit; else npm install --no-audit; fi

COPY resources/ ./resources/
COPY vite.config.js ./
COPY public/ ./public/
# Hapus storage dir yang mungkin ke-copy dari resolved symlink/junction
RUN rm -rf ./public/storage

# Copy vendor dari stage build-php supaya bisa resolve asset vendor
COPY --from=build-php /app/vendor ./vendor

RUN npm run build

# ============================================================
# Stage 3: Production Image
# ============================================================
FROM php:8.4-fpm-alpine AS runner

WORKDIR /var/www/html

# Install nginx, supervisor, dan runtime libs
RUN apk add --no-cache \
    nginx supervisor \
    libpng libwebp libjpeg-turbo freetype \
    oniguruma \
    curl

# Install PHP extensions dengan virtual build deps (dibersihkan setelah compile)
RUN apk add --no-cache --virtual .build-deps \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev \
    oniguruma-dev libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    pdo pdo_mysql mbstring exif pcntl bcmath gd xml opcache \
    && apk del .build-deps

# PHP config
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.interned_strings_buffer=16" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "upload_max_filesize=50M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "post_max_size=50M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit=256M" >> /usr/local/etc/php/conf.d/uploads.ini \
    && echo "date.timezone=Asia/Jakarta" >> /usr/local/etc/php/conf.d/timezone.ini

# PHP-FPM pool config (UNIX socket)
RUN echo '[www]' > /usr/local/etc/php-fpm.d/www.conf \
    && echo 'user = nobody' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'group = nobody' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'listen = /var/run/php-fpm.sock' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'listen.owner = nginx' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'listen.group = nginx' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'listen.mode = 0660' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'pm = dynamic' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'pm.max_children = 20' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'pm.start_servers = 3' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'pm.min_spare_servers = 2' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'pm.max_spare_servers = 6' >> /usr/local/etc/php-fpm.d/www.conf \
    && echo 'clear_env = no' >> /usr/local/etc/php-fpm.d/www.conf

# Nginx config (inline)
RUN echo 'user nginx;' > /etc/nginx/nginx.conf \
    && echo 'worker_processes auto;' >> /etc/nginx/nginx.conf \
    && echo 'error_log /dev/stderr warn;' >> /etc/nginx/nginx.conf \
    && echo 'pid /var/run/nginx.pid;' >> /etc/nginx/nginx.conf \
    && echo 'events { worker_connections 1024; }' >> /etc/nginx/nginx.conf \
    && echo 'http {' >> /etc/nginx/nginx.conf \
    && echo '  include /etc/nginx/mime.types;' >> /etc/nginx/nginx.conf \
    && echo '  default_type application/octet-stream;' >> /etc/nginx/nginx.conf \
    && echo '  sendfile on;' >> /etc/nginx/nginx.conf \
    && echo '  client_max_body_size 50M;' >> /etc/nginx/nginx.conf \
    && echo '  gzip on;' >> /etc/nginx/nginx.conf \
    && echo '  gzip_types text/plain text/css application/json application/javascript text/xml application/xml image/svg+xml;' >> /etc/nginx/nginx.conf \
    && echo '  include /etc/nginx/http.d/*.conf;' >> /etc/nginx/nginx.conf \
    && echo '}' >> /etc/nginx/nginx.conf

RUN echo 'server {' > /etc/nginx/http.d/default.conf \
    && echo '  listen 80;' >> /etc/nginx/http.d/default.conf \
    && echo '  server_name _;' >> /etc/nginx/http.d/default.conf \
    && echo '  root /var/www/html/public;' >> /etc/nginx/http.d/default.conf \
    && echo '  index index.php;' >> /etc/nginx/http.d/default.conf \
    && echo '  location /storage/ {' >> /etc/nginx/http.d/default.conf \
    && echo '    add_header Access-Control-Allow-Origin * always;' >> /etc/nginx/http.d/default.conf \
    && echo '    add_header Access-Control-Allow-Methods "GET, OPTIONS" always;' >> /etc/nginx/http.d/default.conf \
    && echo '    add_header Access-Control-Allow-Headers "Origin, Content-Type, Accept, Authorization" always;' >> /etc/nginx/http.d/default.conf \
    && echo '    try_files $uri $uri/ /index.php?$query_string;' >> /etc/nginx/http.d/default.conf \
    && echo '  }' >> /etc/nginx/http.d/default.conf \
    && echo '  location / { try_files $uri $uri/ /index.php?$query_string; }' >> /etc/nginx/http.d/default.conf \
    && echo '  location ~ \.php$ {' >> /etc/nginx/http.d/default.conf \
    && echo '    fastcgi_pass unix:/var/run/php-fpm.sock;' >> /etc/nginx/http.d/default.conf \
    && echo '    fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;' >> /etc/nginx/http.d/default.conf \
    && echo '    include fastcgi_params;' >> /etc/nginx/http.d/default.conf \
    && echo '  }' >> /etc/nginx/http.d/default.conf \
    && echo '  location ~ /\.(?!well-known).* { deny all; }' >> /etc/nginx/http.d/default.conf \
    && echo '}' >> /etc/nginx/http.d/default.conf

# Supervisor config (inline)
RUN mkdir -p /etc/supervisor/conf.d \
    && echo '[supervisord]' > /etc/supervisor/conf.d/supervisord.conf \
    && echo 'nodaemon=true' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'user=root' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'logfile=/dev/null' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'logfile_maxbytes=0' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo '[program:php-fpm]' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'command=php-fpm --nodaemonize' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'autostart=true' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'autorestart=true' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stdout_logfile=/dev/stdout' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stdout_logfile_maxbytes=0' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stderr_logfile=/dev/stderr' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stderr_logfile_maxbytes=0' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo '[program:nginx]' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'command=nginx -g "daemon off;"' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'autostart=true' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'autorestart=true' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stdout_logfile=/dev/stdout' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stdout_logfile_maxbytes=0' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stderr_logfile=/dev/stderr' >> /etc/supervisor/conf.d/supervisord.conf \
    && echo 'stderr_logfile_maxbytes=0' >> /etc/supervisor/conf.d/supervisord.conf

# Copy application files
COPY . .
COPY --from=build-php /app/vendor ./vendor
# We only copy build if there is one. Some projects might not have public/build.
RUN if [ -d /app/public/build ]; then cp -r /app/public/build ./public/build; fi

# Hapus .env lokal — EasyPanel inject via "Create .env file"
RUN rm -f .env

# Copy startup script
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh


# Fix permissions build-time
RUN chown -R nginx:nginx /var/www/html/public \
    && chown -R nobody:nobody /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

CMD ["/start.sh"]
