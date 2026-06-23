#!/bin/sh
set -e

echo "=== Starting Dokemass Backend ==="

# Create required directories
mkdir -p /run/nginx
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/framework/cache/data
mkdir -p /var/www/html/storage/app/public
mkdir -p /var/www/html/bootstrap/cache

cd /var/www/html

# Fix permissions
chown -R nobody:nobody /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Run migrations
echo "=== Running migrations ==="
php artisan migrate --force

# Run seeder (idempotent — safe to run multiple times)
echo "=== Running seeder ==="
php artisan db:seed --force || echo "WARNING: Seeder failed, continuing anyway..."

# Post-deploy tasks
# Remove public/storage if it was copied as a real directory during Docker build
# (the local symlink/junction gets resolved into a real dir by COPY)
rm -rf /var/www/html/public/storage
php artisan storage:link --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "=== Starting supervisord ==="
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
