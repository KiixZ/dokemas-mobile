import 'package:flutter/material.dart';

class DetailDestinasiScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String rating;
  final String reviewCount;
  final String location;
  final String price;
  final String distance;
  final String openingHours;
  final String description;
  final List<Map<String, dynamic>> facilities;
  final String reviewerName;
  final String reviewerTime;
  final String reviewerText;

  const DetailDestinasiScreen({
    super.key,
    this.title = 'Baturraden',
    this.imageUrl =
        'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=500&auto=format&fit=crop',
    this.rating = '4.8',
    this.reviewCount = '1.2k ulasan',
    this.location = 'Purwokerto Utara, Banyumas',
    this.price = 'Rp25.000',
    this.distance = '12 km',
    this.openingHours = '08:00 -\n17:00',
    this.description =
        'Nikmati udara segar pegunungan dan panorama alam yang memukau di Baturraden. Terletak di lereng Gunung Slamet, destinasi ini menawarkan kombinasi sempurna antara air terjun yang jernih, hutan pinus yang rindang, dan sumber air panas alami. Tempat yang ideal untuk melarikan diri dari hiruk-pikuk kota dan menyatu kembali dengan alam.',
    this.facilities = const [
      {'icon': Icons.local_parking, 'label': 'Parkir'},
      {'icon': Icons.wc, 'label': 'Toilet'},
      {'icon': Icons.mosque, 'label': 'Mushola'},
      {'icon': Icons.camera_alt_outlined, 'label': 'Spot Foto'},
      {'icon': Icons.restaurant, 'label': 'Tempat Makan'},
    ],
    this.reviewerName = 'Siti Rahmawati',
    this.reviewerTime = '2 hari yang lalu',
    this.reviewerText =
        'Tempatnya sangat sejuk dan bersih. Air terjunnya indah banget buat foto-foto. Fasilitas lengkap, parkiran luas. Recommended banget buat liburan bareng keluarga.',
  });

  // Fungsi untuk memunculkan Pop-up Modal Tambah ke Itinerary (image_92da84.png)
  void _showTambahItineraryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets
              .zero, // Mengosongkan padding bawaan agar bisa custom footer
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            // Agar tinggi modal menyesuaikan konten
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Modal
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah ke Itinerary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0f172a),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),

                // Form Isi Konten (Scrollable jika layar kecil)
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Input Pilih Tanggal
                        const Text(
                          'Pilih Tanggal',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          readOnly:
                              true, // Membuatnya tidak memunculkan keyboard biasa
                          onTap: () {
                            // Opsional: Anda bisa pasang showDatePicker(context: context, ...) di sini nanti
                          },
                          decoration: InputDecoration(
                            hintText: 'mm/dd/yyyy',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 2. Input Pilih Waktu (Dropdown)
                        const Text(
                          'Pilih Waktu',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: 'Pagi', // Nilai default sesuai gambar
                          items: <String>['Pagi', 'Siang', 'Sore', 'Malam'].map(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (newValue) {},
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 3. Input Catatan (Opsional)
                        const Text(
                          'Catatan (Opsional)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          maxLines: 3, // Agar kotak input memanjang ke bawah
                          decoration: InputDecoration(
                            hintText: 'Contoh: Bawa baju ganti...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Modal (Tombol Simpan ke Itinerary)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xfff8f9fa,
                    ), // Latar belakang footer agak kontras abu tipis
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika simpan data di sini
                      Navigator.pop(context); // Tutup dialog setelah simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xff2cd4bf,
                      ), // Warna hijau toska/bright teal sesuai tombol simpan di gambar
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Simpan ke Itinerary',
                      style: TextStyle(
                        color: Color(
                          0xff0f172a,
                        ), // Warna teks gelap sesuai gambar mockup modal
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk kalkulasi tinggi gambar latar belakang
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xfff8fafd),
      body: Stack(
        children: [
          // 1. Gambar Latar Belakang (Header)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.4, // Mengambil 40% tinggi layar
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=500&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                // Efek gradient gelap tipis di atas gambar agar tombol back/heart terlihat jelas
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Tombol Aksi Atas (Back dan Favorite)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircleIconButton(
                  icon: Icons.favorite_border,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // 3. Konten Utama (Scrollable Sheet)
          Positioned.fill(
            top: screenHeight * 0.33, // Sedikit menimpa gambar di atasnya
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xfff8fafd),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // Indikator garis kecil di bagian paling atas sheet
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Isi Konten yang bisa di-scroll
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama Destinasi & Rating
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0d1e3d),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              RichText(
                                text: TextSpan(
                                  text: '$rating ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0d1e3d),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '($reviewCount)',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Info Cards (Harga, Jarak, Jam Buka)
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  Icons.confirmation_number_outlined,
                                  'HARGA TIKET',
                                  price,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  Icons.timeline,
                                  'JARAK',
                                  distance,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoCard(
                                  Icons.access_time,
                                  'JAM BUKA',
                                  openingHours,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Tentang Tempat Ini
                          const Text(
                            'Tentang Tempat Ini',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0d1e3d),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Fasilitas
                          const Text(
                            'Fasilitas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0d1e3d),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...facilities.map((facility) {
                                return _buildFacilityChip(
                                  facility['icon'] as IconData,
                                  facility['label'] as String,
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Ulasan Pilihan Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ulasan Pilihan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0d1e3d),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: const [
                                    Text(
                                      'LIHAT SEMUA',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 16,
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Kartu Ulasan
                          _buildReviewCard(),
                          const SizedBox(
                            height: 100,
                          ), // Ruang ekstra agar scroll tidak tertutup bottom bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Action Buttons (Fixed di bawah screen)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xfff8fafd),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Tombol Lihat Rute
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.explore_outlined,
                        size: 18,
                        color: Colors.teal,
                      ),
                      label: const Text(
                        'Lihat Rute',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.teal),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.teal.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Tambah ke Itinerary
                  Expanded(
                    flex: 6,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Memanggil fungsi pop-up dialog
                        _showTambahItineraryDialog(context);
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Tambah ke Itinerary',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xff006653,
                        ), // Teal Hijau sesuai gambar layout
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Tombol Bulat Transparan di bagian atas gambar
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  // Helper Widget: Card Info (Harga, Jarak, Jam)
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffedf3fc),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal[700], size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xff0d1e3d),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Chip Fasilitas
  Widget _buildFacilityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffe2ebf4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Card Ulasan Pengguna
  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0d1e3d),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reviewerTime,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) =>
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reviewerText,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
