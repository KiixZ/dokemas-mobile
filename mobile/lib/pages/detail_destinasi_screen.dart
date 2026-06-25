import 'package:flutter/material.dart';
import 'user/itinerary/itinerary_list_page.dart';
// Note: Untuk fitur 'Lihat Rute' asli ke Google Maps, silakan tambahkan library url_launcher di pubspec.yaml
// import 'package:url_launcher/url_launcher.dart';

class DetailDestinasiScreen extends StatefulWidget {
  // Deklarasi variabel penampung data dinamis dari beranda
  final String title;
  final String imageUrl;
  final String rating;
  final String reviewCount;
  final String location;
  final String price;
  final String distance;
  final String openingHours;
  final String description;

  const DetailDestinasiScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.price,
    required this.distance,
    required this.openingHours,
    required this.description,
  });

  @override
  State<DetailDestinasiScreen> createState() => _DetailDestinasiScreenState();
}

class _DetailDestinasiScreenState extends State<DetailDestinasiScreen> {
  bool _isFavorite = false;

  final List<Map<String, dynamic>> _dummyItineraries = [
    {
      'title': 'Liburan ke Baturraden',
      'startDate': DateTime(2026, 6, 21),
      'endDate': DateTime(2026, 6, 22),
    },
    {
      'title': 'Wisata Kuliner Purwokerto',
      'startDate': DateTime(2026, 7, 1),
      'endDate': DateTime(2026, 7, 3),
    },
  ];

  void _showPilihItineraryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Pilih Itinerary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff0f172a),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: _dummyItineraries.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final itinerary = _dummyItineraries[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        itinerary['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${itinerary['startDate'].day}/${itinerary['startDate'].month}/${itinerary['startDate'].year} - ${itinerary['endDate'].day}/${itinerary['endDate'].month}/${itinerary['endDate'].year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.teal,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showTambahItineraryDialog(context, itinerary);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ItineraryListPage(autoOpenAddForm: true),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      'Buat Itinerary Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk memunculkan dialog Tambah ke Itinerary
  void _showTambahItineraryDialog(
    BuildContext context,
    Map<String, dynamic> itinerary,
  ) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              readOnly: true,
                              controller: TextEditingController(
                                text: selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : '',
                              ),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: itinerary['startDate'],
                                  firstDate: itinerary['startDate'],
                                  lastDate: itinerary['endDate'],
                                );
                                if (picked != null) {
                                  setDialogState(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Pilih Tanggal',
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
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Pilih Waktu',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: selectedTime != null
                                    ? selectedTime!.format(context)
                                    : '',
                              ),
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setDialogState(() {
                                    selectedTime = picked;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Pilih Waktu',
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
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Contoh: Bawa baju ganti...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xfff8f9fa),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2cd4bf),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Simpan ke Itinerary',
                          style: TextStyle(
                            color: Color(0xff0f172a),
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
      },
    );
  }

  // Fungsi Logika untuk Membuka Rute Peta
  void _bukaRutePeta() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka Google Maps menuju ${widget.title}...'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );

    // Jika url_launcher sudah diinstall, aktifkan kode di bawah ini:
    // const String urlMaps = "https://www.google.com/maps/search/?api=1&query=Baturraden+Banyumas";
    // launchUrl(Uri.parse(urlMaps), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xfff8fafd),
      body: Stack(
        children: [
          // 1. Gambar Latar Belakang Dinamis (Header) - Dibuat memenuhi layar bagian atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height:
                screenHeight *
                0.5, // Sedikit ditinggikan agar background di belakang sheet terlihat luas
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
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

          // 2. Tombol Aksi Atas (Tetap mengambang di atas gambar)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIconButton(
                  icon: Icons.arrow_back,
                  iconColor: Colors.white,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircleIconButton(
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavorite ? Colors.red : Colors.white,
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ],
            ),
          ),

          // 3. Konten Utama Menggunakan DraggableScrollableSheet agar bisa ditarik secara dinamis
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize:
                  0.65, // Posisi awal lembar detail (65% tinggi layar)
              minChildSize: 0.55, // Batas minimum lembar diseret ke bawah
              maxChildSize: 0.90, // Batas maksimum lembar diseret ke atas
              snap:
                  true, // Lembar otomatis nge-snap/pas ke posisi terdekat saat dilepas
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xfff8fafd),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  // STRUKTUR FIX: Menjadikan SingleChildScrollView anak langsung dari Container agar gesture terdeteksi sempurna
                  child: SingleChildScrollView(
                    controller:
                        scrollController, // <--- Menghubungkan langsung drag gesture ke sheet
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Penanda Garis Handle Abu-abu (Ditempatkan paling atas di dalam scrollview)
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Isi data utama destinasi wisata
                        Text(
                          widget.title,
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
                                text: '${widget.rating} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0d1e3d),
                                ),
                                children: [
                                  TextSpan(
                                    text: '(${widget.reviewCount})',
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
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.location,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                Icons.confirmation_number_outlined,
                                'HARGA TIKET',
                                widget.price,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.timeline,
                                'JARAK',
                                widget.distance,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.access_time,
                                'JAM BUKA',
                                widget.openingHours,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // SEKSI FASILITAS TERSEDIA
                        const Text(
                          'Fasilitas Available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0d1e3d),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildFacilityChipStatic(
                              Icons.local_parking,
                              'Parkir',
                            ),
                            _buildFacilityChipStatic(Icons.wc, 'Toilet'),
                            _buildFacilityChipStatic(Icons.mosque, 'Mushola'),
                            _buildFacilityChipStatic(
                              Icons.camera_alt_outlined,
                              'Spot Foto',
                            ),
                            _buildFacilityChipStatic(
                              Icons.restaurant,
                              'Tempat Makan',
                            ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DaftarUlasanScreen(),
                                  ),
                                );
                              },
                              child: const Row(
                                children: [
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
                        _buildReviewCard(),
                        const SizedBox(
                          height: 130,
                        ), // Ganjal area bawah scrollview agar konten tidak terpotong tombol fixed
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. Bottom Action Buttons (Fixed di dasar layar agar tidak ikut tergulung)
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
                  Expanded(
                    flex: 3,
                    child: OutlinedButton.icon(
                      onPressed: _bukaRutePeta,
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
                  Expanded(
                    flex: 5,
                    child: ElevatedButton.icon(
                      onPressed: () => _showPilihItineraryDialog(context),
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
                        backgroundColor: const Color(0xff006653),
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

  Widget _buildCircleIconButton({
    required IconData icon,
    required Color iconColor,
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
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

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

  Widget _buildFacilityChipStatic(IconData icon, String label) {
    return RawChip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      avatar: Icon(icon, size: 16, color: const Color(0xff00796b)),
      backgroundColor: const Color(0xffe2ebf4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Siti Rahmawati',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0d1e3d),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '2 hari yang lalu',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
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
            'Tempatnya sangat sejuk and bersih. Air terjunnya indah banget buat foto-foto. Fasilitas lengkap, parkiran luas. Recommended banget buat liburan bareng keluarga.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCREEN DAFTAR ULASAN SEBELUMNYA ---
class DaftarUlasanScreen extends StatefulWidget {
  const DaftarUlasanScreen({super.key});

  @override
  State<DaftarUlasanScreen> createState() => _DaftarUlasanScreenState();
}

class _DaftarUlasanScreenState extends State<DaftarUlasanScreen> {
  final List<Map<String, dynamic>> _reviewsList = [
    {
      'nama': 'Budi Santoso',
      'waktu': '1 minggu yang lalu',
      'rating': 5,
      'isi': 'Suasananya asri sekali, akses jalan mudah dijangkau.',
    },
    {
      'nama': 'Ahmad Fauzi',
      'waktu': '3 hari yang lalu',
      'rating': 4,
      'isi': 'Udara segar, tapi kalau weekend agak ramai.',
    },
  ];

  void _showTulisUlasanDialog(BuildContext context) {
    String namaInput = "";
    String ulasanInput = "";
    int selectedStars = 5;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Tulis Ulasan Baru',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0d1e3d),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      onChanged: (value) => namaInput = value,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama Anda...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Berikan Rating',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedStars = index + 1;
                            });
                          },
                          child: Icon(
                            index < selectedStars
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Isi Ulasan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      onChanged: (value) => ulasanInput = value,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Ceritakan pengalaman Anda di sini...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (namaInput.isNotEmpty && ulasanInput.isNotEmpty) {
                      setState(() {
                        _reviewsList.insert(0, {
                          'nama': namaInput,
                          'waktu': 'Baru saja',
                          'rating': selectedStars,
                          'isi': ulasanInput,
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ulasan berhasil disimpan!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap isi Nama dan Ulasan Anda!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Kirim Ulasan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafd),
      appBar: AppBar(
        title: const Text(
          'Semua Ulasan',
          style: TextStyle(
            color: Color(0xff0d1e3d),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xff0d1e3d)),
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_outlined, color: Colors.teal),
            onPressed: () => _showTulisUlasanDialog(context),
          ),
        ],
      ),
      body: _reviewsList.isEmpty
          ? const Center(child: Text('Belum ada ulasan.'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _reviewsList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _reviewsList[index];
                return ItemReviewCard(
                  nama: item['nama'],
                  waktu: item['waktu'],
                  rating: item['rating'],
                  isi: item['isi'],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTulisUlasanDialog(context),
        label: const Text(
          'Tulis Ulasan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        icon: const Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

class ItemReviewCard extends StatelessWidget {
  final String nama;
  final String waktu;
  final int rating;
  final String isi;

  const ItemReviewCard({
    super.key,
    required this.nama,
    required this.waktu,
    required this.rating,
    required this.isi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xff0d1e3d),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      waktu,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey[300],
                    size: 12,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isi,
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
