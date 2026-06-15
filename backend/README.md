# DOKEMAS — Backend API (Laravel)

REST API untuk aplikasi mobile **DOKEMAS (Dolan Keliling Banyumas)**.
Laravel 13 · PHP 8.4 · MySQL · Sanctum (token auth).

## Setup

```bash
cd backend
composer install
cp .env.example .env        # jika .env belum ada
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve            # http://127.0.0.1:8000
```

DB di `.env`: `DB_DATABASE=dokemas`, `DB_USERNAME=root`, `DB_PASSWORD=` (Laragon MySQL).

## Akun seed

| Role  | Email                | Password   |
|-------|----------------------|------------|
| admin | admin@dokemas.test   | password   |
| user  | user@dokemas.test    | password   |

## Auth (Sanctum)

`POST /api/login` & `/api/register` mengembalikan `{ user, token }`.
Kirim token di header tiap request privat:

```
Authorization: Bearer <token>
Accept: application/json
```

## Base URL dari Flutter

- Android emulator: `http://10.0.2.2:8000/api`
- iOS simulator / web: `http://127.0.0.1:8000/api`
- HP fisik: `http://<IP-LAN-laptop>:8000/api` (jalankan `php artisan serve --host=0.0.0.0`)

## Dokumentasi API (Swagger / OpenAPI)

Auto-generate via **Scramble** dari kode (tanpa anotasi). Jalankan server lalu buka:

- UI interaktif (Try It): `http://127.0.0.1:8000/docs/api`
- Spec OpenAPI 3.1 (JSON): `http://127.0.0.1:8000/docs/api.json`

Endpoint privat: login dulu, copy `token`, klik **Authorize** / isi Bearer token di UI.

> Default hanya terbuka di env `local` (gate `RestrictedDocsAccess`). Untuk pakai di
> Swagger UI / Postman lain, import dari URL `docs/api.json`.

Export spec ke file statis:
```bash
php artisan scramble:export   # -> api.json
```

## Endpoint

### Publik (guest)
| Method | Path | Ket |
|--------|------|-----|
| POST | `/register` | daftar user |
| POST | `/login` | login |
| GET  | `/categories` | list kategori (+jumlah destinasi) |
| GET  | `/categories/{id}` | detail kategori |
| GET  | `/facilities` | list fasilitas |
| GET  | `/destinations` | list destinasi (paginate) |
| GET  | `/destinations/{id}` | detail + kategori, fasilitas, galeri, review |
| GET  | `/destinations/{id}/reviews` | review per destinasi |

Filter `GET /destinations`: `search`, `category_id`, `min_price`, `max_price`, `popular=1`, `sort=latest|rating|price_asc|price_desc|name`, `per_page`, `page`.

### User (perlu token)
| Method | Path | Ket |
|--------|------|-----|
| GET | `/me` | profil saya |
| PUT | `/profile` | ubah profil/password |
| POST | `/logout` | hapus token |
| POST | `/destinations/{id}/reviews` | beri/ubah review (1 per destinasi) |
| PUT/DELETE | `/reviews/{id}` | ubah/hapus review sendiri |
| GET | `/wishlist` | wishlist saya |
| POST | `/wishlist/toggle` | toggle (body: `destination_id`) |
| POST | `/wishlist` · DELETE `/wishlist/{destinationId}` | tambah / hapus |
| GET/POST | `/itineraries` | list / buat itinerary |
| GET/PUT/DELETE | `/itineraries/{id}` | detail / ubah / hapus |
| POST | `/itineraries/{id}/items` | tambah destinasi ke itinerary |
| DELETE | `/itineraries/{id}/items/{itemId}` | hapus item |

### Admin (token + role admin)
Prefix `/admin`. Non-admin → `403`.
| Method | Path | Ket |
|--------|------|-----|
| GET | `/admin/dashboard` | statistik (total destinasi/user/review, top rating) |
| POST/PUT/DELETE | `/admin/categories[/{id}]` | CRUD kategori |
| POST/PUT/DELETE + GET show | `/admin/facilities[/{id}]` | CRUD fasilitas |
| POST/PUT/DELETE | `/admin/destinations[/{id}]` | CRUD destinasi (body `facility_ids[]` untuk sync fasilitas) |
| GET/PUT/DELETE | `/admin/users[/{id}]` | kelola user |

## Upload Foto & Konversi WebP

Semua foto yang diupload **otomatis dikonversi ke WebP** + di-resize, lalu disimpan
di `storage/app/public/...` dan diakses lewat URL `/storage/...`.

Converter dipilih runtime (`app/Services/ImageService.php`): **GD** (kalau ada WebP) →
**Imagick** → **binary `cwebp`** (`backend/bin/cwebp.exe`, sudah disertakan untuk Windows).
Di server Linux: `apt install webp` atau pakai GD/Imagick yang sudah ber-WebP — kode jalan tanpa ubah apa pun.

Field upload (`multipart/form-data`):

| Endpoint | Field | Hasil |
|----------|-------|-------|
| `POST /admin/destinations` · `PUT` | `thumbnail` (file), `images[]` (file) | thumbnail + galeri → webp |
| `POST /admin/destinations/{id}/images` | `images[]` atau `image` (+ `caption`) | tambah foto galeri → webp |
| `DELETE /admin/destination-images/{id}` | — | hapus foto galeri + file |
| `POST /profile/avatar` | `avatar` (file) | avatar user → webp 512px |

Input diterima: `jpg, jpeg, png, webp` (maks 5 MB). Output selalu `.webp`.
Response menyertakan `thumbnail_url` / `image_url` / `avatar_url` (URL absolut siap pakai Flutter).

> **Catatan PUT + file:** PHP tidak parse file di request PUT. Dari Flutter kirim
> `POST` dengan field `_method=PUT` (multipart), atau pakai endpoint `POST` khusus di atas.

> **APP_URL** menentukan host pada `*_url`. Default `http://127.0.0.1:8000`.
> Android emulator → set `APP_URL=http://10.0.2.2:8000`; HP fisik → `APP_URL=http://<IP-LAN>:8000`.

## Skema DB (10 tabel)

`users` (role user/admin) · `categories` · `destinations` (FK category) ·
`facilities` · `destination_facilities` (pivot M:N) · `reviews` (unik user+destinasi) ·
`wishlists` (unik user+destinasi) · `itineraries` · `itinerary_items` · `destination_images`.

Rating destinasi (`rating_avg`, `rating_count`) dihitung ulang otomatis saat review berubah.