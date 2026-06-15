<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;
use Symfony\Component\Process\Process;

class ImageService
{
    /**
     * Simpan gambar yang diupload sebagai WebP ke disk "public".
     *
     * Urutan converter: GD (jika WebP didukung) -> Imagick -> binary cwebp.
     * Jika semua gagal, file disimpan apa adanya (ekstensi asli).
     *
     * @param  string  $dir  subfolder di storage/app/public (mis. "destinations")
     * @param  int  $maxWidth  lebar maksimum, gambar lebih besar di-resize proporsional
     * @param  int  $quality  kualitas WebP 0-100
     * @return string  path relatif terhadap disk public (mis. "destinations/abc.webp")
     */
    public function storeAsWebp(UploadedFile $file, string $dir = 'uploads', int $maxWidth = 1600, int $quality = 80): string
    {
        $name = Str::uuid()->toString();
        $relPath = trim($dir, '/')."/{$name}.webp";
        $fullPath = Storage::disk('public')->path($relPath);

        // pastikan folder ada
        Storage::disk('public')->makeDirectory($dir);

        $source = $file->getRealPath();

        if ($this->convertWithGd($source, $fullPath, $maxWidth, $quality)) {
            return $relPath;
        }

        if ($this->convertWithImagick($source, $fullPath, $maxWidth, $quality)) {
            return $relPath;
        }

        if ($this->convertWithBinary($source, $fullPath, $quality)) {
            return $relPath;
        }

        // fallback: simpan file asli tanpa konversi
        $fallback = trim($dir, '/').'/'.$name.'.'.$file->getClientOriginalExtension();
        $file->storeAs($dir, basename($fallback), 'public');

        return $fallback;
    }

    public function delete(?string $relPath): void
    {
        if ($relPath && Storage::disk('public')->exists($relPath)) {
            Storage::disk('public')->delete($relPath);
        }
    }

    private function convertWithGd(string $src, string $dest, int $maxWidth, int $quality): bool
    {
        if (! function_exists('imagewebp')) {
            return false;
        }
        $info = function_exists('gd_info') ? gd_info() : [];
        if (empty($info['WebP Support'])) {
            return false;
        }

        $data = @getimagesize($src);
        if (! $data) {
            return false;
        }

        $img = match ($data[2]) {
            IMAGETYPE_JPEG => @imagecreatefromjpeg($src),
            IMAGETYPE_PNG => @imagecreatefrompng($src),
            IMAGETYPE_WEBP => @imagecreatefromwebp($src),
            IMAGETYPE_GIF => @imagecreatefromgif($src),
            default => false,
        };
        if (! $img) {
            return false;
        }

        $img = $this->resizeGd($img, $maxWidth);
        imagepalettetotruecolor($img);
        imagealphablending($img, true);
        $ok = imagewebp($img, $dest, $quality);
        imagedestroy($img);

        return (bool) $ok;
    }

    private function resizeGd(\GdImage $img, int $maxWidth): \GdImage
    {
        $w = imagesx($img);
        $h = imagesy($img);
        if ($w <= $maxWidth) {
            return $img;
        }
        $newW = $maxWidth;
        $newH = (int) round($h * ($maxWidth / $w));
        $resized = imagecreatetruecolor($newW, $newH);
        imagealphablending($resized, false);
        imagesavealpha($resized, true);
        imagecopyresampled($resized, $img, 0, 0, 0, 0, $newW, $newH, $w, $h);
        imagedestroy($img);

        return $resized;
    }

    private function convertWithImagick(string $src, string $dest, int $maxWidth, int $quality): bool
    {
        if (! extension_loaded('imagick')) {
            return false;
        }
        try {
            $im = new \Imagick($src);
            $im->setImageFormat('webp');
            if ($im->getImageWidth() > $maxWidth) {
                $im->resizeImage($maxWidth, 0, \Imagick::FILTER_LANCZOS, 1);
            }
            $im->setImageCompressionQuality($quality);
            $ok = $im->writeImage($dest);
            $im->clear();
            $im->destroy();

            return (bool) $ok;
        } catch (\Throwable) {
            return false;
        }
    }

    private function convertWithBinary(string $src, string $dest, int $quality): bool
    {
        $bin = $this->cwebpBinary();
        if (! $bin) {
            return false;
        }
        try {
            $process = new Process([$bin, '-quiet', '-q', (string) $quality, $src, '-o', $dest]);
            $process->setTimeout(30);
            $process->run();

            return $process->isSuccessful() && is_file($dest);
        } catch (\Throwable) {
            return false;
        }
    }

    private function cwebpBinary(): ?string
    {
        // binary lokal di repo (Windows)
        $local = base_path('bin/cwebp.exe');
        if (is_file($local)) {
            return $local;
        }
        $localNix = base_path('bin/cwebp');
        if (is_file($localNix)) {
            return $localNix;
        }
        // cwebp di PATH (Linux: apt install webp)
        $finder = (new \Symfony\Component\Process\ExecutableFinder)->find('cwebp');

        return $finder ?: null;
    }
}