<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Destination;
use App\Models\Review;

class ReviewSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Pastikan ada user dan destination
        $users = User::all();
        $destinations = Destination::all();

        if ($users->isEmpty() || $destinations->isEmpty()) {
            $this->command->info('Tidak ada User atau Destination, skip ReviewSeeder.');
            return;
        }

        // Buat beberapa user dummy tambahan jika hanya sedikit
        if ($users->count() < 5) {
            $users = collect([
                User::create(['name' => 'Rina Marlina', 'email' => 'rina@example.com', 'password' => bcrypt('password'), 'role' => 'user']),
                User::create(['name' => 'Agus Pratama', 'email' => 'agus@example.com', 'password' => bcrypt('password'), 'role' => 'user']),
                User::create(['name' => 'Budi Santoso', 'email' => 'budi@example.com', 'password' => bcrypt('password'), 'role' => 'user']),
                User::create(['name' => 'Siti Rahma', 'email' => 'siti@example.com', 'password' => bcrypt('password'), 'role' => 'user']),
                User::create(['name' => 'Deni W.', 'email' => 'deni@example.com', 'password' => bcrypt('password'), 'role' => 'user']),
                User::create(['name' => 'Anonymous User', 'email' => 'anon@example.com', 'password' => bcrypt('password'), 'role' => 'user']),
            ])->merge($users);
        }

        $reviewsData = [
            [
                'name' => 'Rina Marlina',
                'rating' => 4,
                'comment' => 'Air terjunnya tinggi banget dan airnya seger. Akses jalan agak licin pas musim hujan, hati-hati.',
                'status' => 'pending',
                'flag_count' => 0,
                'flag_reason' => null,
            ],
            [
                'name' => 'Agus Pratama',
                'rating' => 2,
                'comment' => 'Tempatnya kurang terawat, banyak sampah di area pinggir.',
                'status' => 'pending',
                'flag_count' => 0,
                'flag_reason' => null,
            ],
            [
                'name' => 'Budi Santoso',
                'rating' => 5,
                'comment' => 'Absolutely breathtaking experience! The path was well maintained and the views at the top were worth the hike. Highly recommend going.',
                'status' => 'public',
                'flag_count' => 0,
                'flag_reason' => null,
            ],
            [
                'name' => 'Anonymous User',
                'rating' => 1,
                'comment' => '[Hidden due to inappropriate content] The facilities were terrible and the staff was unhelpful.',
                'status' => 'reported',
                'flag_count' => 3,
                'flag_reason' => 'inappropriate language',
            ],
            [
                'name' => 'Siti Rahma',
                'rating' => 4,
                'comment' => 'Great place for family photos! The miniatures are quite detailed. Only giving 4 stars because it gets very hot in the afternoon with limited shade.',
                'status' => 'public',
                'flag_count' => 0,
                'flag_reason' => null,
            ],
            [
                'name' => 'Deni W.',
                'rating' => 3,
                'comment' => 'Review temporarily hidden by admin.',
                'status' => 'hidden',
                'flag_count' => 0,
                'flag_reason' => null,
            ],
        ];

        foreach ($reviewsData as $data) {
            // Cari user berdasar nama, jika tidak ada fallback ke random user
            $user = $users->firstWhere('name', $data['name']) ?? $users->random();
            $destination = $destinations->random();

            Review::create([
                'user_id' => $user->id,
                'destination_id' => $destination->id,
                'rating' => $data['rating'],
                'comment' => $data['comment'],
                'status' => $data['status'],
                'flag_count' => $data['flag_count'],
                'flag_reason' => $data['flag_reason'],
                'created_at' => now()->subDays(rand(1, 10)), // random tanggal
                'updated_at' => now()->subDays(rand(1, 10)),
            ]);
        }

        // Sinkronisasi ulang rating destinasi
        foreach ($destinations as $destination) {
            $destination->recalcRating();
        }

        $this->command->info('ReviewSeeder berhasil dijalankan!');
    }
}
