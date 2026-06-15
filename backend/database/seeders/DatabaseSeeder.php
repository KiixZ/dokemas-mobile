<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Destination;
use App\Models\Facility;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Accounts
        User::create([
            'name' => 'Admin DOKEMAS',
            'email' => 'admin@dokemas.test',
            'password' => Hash::make('password'),
            'role' => 'admin',
        ]);

        User::create([
            'name' => 'User Demo',
            'email' => 'user@dokemas.test',
            'password' => Hash::make('password'),
            'role' => 'user',
        ]);

        // Categories
        $categories = collect([
            ['name' => 'Alam', 'icon' => 'forest'],
            ['name' => 'Kuliner', 'icon' => 'restaurant'],
            ['name' => 'Sejarah', 'icon' => 'museum'],
            ['name' => 'Religi', 'icon' => 'mosque'],
            ['name' => 'Keluarga', 'icon' => 'family_restroom'],
        ])->mapWithKeys(function ($c) {
            $cat = Category::create([
                'name' => $c['name'],
                'slug' => Str::slug($c['name']),
                'icon' => $c['icon'],
            ]);

            return [$c['name'] => $cat->id];
        });

        // Facilities
        $facilities = collect([
            'Parkir', 'Toilet', 'Musholla', 'Warung Makan', 'Spot Foto',
            'Area Bermain Anak', 'Penginapan', 'Wifi',
        ])->map(fn ($name) => Facility::create(['name' => $name, 'icon' => Str::slug($name)]));

        // Destinations (Banyumas)
        $destinations = [
            ['Baturraden', 'Alam', 'Kawasan wisata pegunungan di lereng Gunung Slamet dengan udara sejuk, pemandian air panas, dan air terjun.', 'Baturraden, Banyumas', -7.3119, 109.2230, 25000, true],
            ['Lokawisata Baturraden', 'Keluarga', 'Taman rekreasi keluarga dengan kolam renang, taman, dan wahana permainan.', 'Baturraden, Banyumas', -7.3092, 109.2250, 20000, true],
            ['Curug Cipendok', 'Alam', 'Air terjun setinggi 92 meter di kaki Gunung Slamet, dikelilingi hutan pinus.', 'Cilongok, Banyumas', -7.3450, 109.1180, 15000, true],
            ['Telaga Sunyi', 'Alam', 'Telaga jernih berair sejuk di kawasan Baturraden, cocok untuk bersantai.', 'Baturraden, Banyumas', -7.3070, 109.2350, 10000, false],
            ['Masjid Agung Baitussalam', 'Religi', 'Masjid agung pusat kegiatan keagamaan di alun-alun Purwokerto.', 'Purwokerto, Banyumas', -7.4256, 109.2390, 0, false],
            ['Museum Bank Rakyat Indonesia', 'Sejarah', 'Museum sejarah perbankan BRI, bank tertua di Indonesia, di Purwokerto.', 'Purwokerto, Banyumas', -7.4218, 109.2347, 5000, false],
            ['Pratistha Harsa', 'Keluarga', 'Wisata edukasi dan outbound dengan area kemah dan taman.', 'Baturraden, Banyumas', -7.3150, 109.2280, 30000, false],
            ['Sentra Mendoan Sawangan', 'Kuliner', 'Pusat kuliner mendoan khas Banyumas, tempe goreng tepung setengah matang.', 'Purwokerto, Banyumas', -7.4300, 109.2400, 0, true],
        ];

        foreach ($destinations as $d) {
            $dest = Destination::create([
                'category_id' => $categories[$d[1]],
                'name' => $d[0],
                'slug' => Str::slug($d[0]).'-'.Str::random(5),
                'description' => $d[2],
                'address' => $d[3],
                'latitude' => $d[4],
                'longitude' => $d[5],
                'price' => $d[6],
                'opening_hours' => '08:00 - 17:00',
                'is_popular' => $d[7],
            ]);

            $dest->facilities()->sync(
                $facilities->random(rand(3, 6))->pluck('id')->all()
            );
        }
    }
}