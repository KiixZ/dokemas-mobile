import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/itinerary_provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/itinerary_model.dart';
import 'user/itinerary/itinerary_list_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth/login_page.dart';
import '../models/review.dart';
import '../service/api_service.dart';

class DetailDestinasiScreen extends StatefulWidget {
  // Deklarasi variabel penampung data dinamis dari beranda
  final int destinationId;
  final String title;
  final String imageUrl;
  final String rating;
  final String reviewCount;
  final String location;
  final String price;
  final String distance;
  final String openingHours;
  final String description;
  final List<String> galleryImages;

  const DetailDestinasiScreen({
    super.key,
    required this.destinationId,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.price,
    required this.distance,
    required this.openingHours,
    required this.description,
    this.galleryImages = const [],
  });

  @override
  State<DetailDestinasiScreen> createState() => _DetailDestinasiScreenState();
}

class _DetailDestinasiScreenState extends State<DetailDestinasiScreen> {
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;
  String? _reviewError;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() {
      _isLoadingReviews = true;
      _reviewError = null;
    });
    try {
      final apiService = ApiService();
      final fetchedReviews = await apiService.fetchDestinationReviews(widget.destinationId);
      if (!mounted) return;
      setState(() {
        _reviews = fetchedReviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _reviewError = e.toString();
        _isLoadingReviews = false;
      });
    }
  }

  void _showPilihItineraryDialog(BuildContext context) {
    final itineraries = context.read<ItineraryProvider>().activeItineraries;

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
                if (itineraries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Belum ada itinerary, silakan buat baru.'),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: itineraries.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final itinerary = itineraries[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          itinerary.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          itinerary.dateRangeText,
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
    ItineraryModel itinerary,
  ) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    final noteController = TextEditingController();
    bool isLoading = false;

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
                                  initialDate: itinerary.startDate ?? DateTime.now(),
                                  firstDate: itinerary.startDate ?? DateTime.now(),
                                  lastDate: itinerary.endDate ?? DateTime.now().add(const Duration(days: 365)),
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
                              controller: noteController,
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
                        onPressed: isLoading
                            ? null
                            : () async {
                                setDialogState(() => isLoading = true);
                                final token = context.read<AuthProvider>().token;
                                if (token == null) {
                                  setDialogState(() => isLoading = false);
                                  return;
                                }

                                String? visitTimeStr;
                                if (selectedTime != null) {
                                  visitTimeStr =
                                      '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
                                }

                                final provider = context.read<ItineraryProvider>();
                                final error = await provider.addItem(
                                  token,
                                  itinerary.id,
                                  destinationId: widget.destinationId,
                                  visitDate: selectedDate,
                                  visitTime: visitTimeStr,
                                  note: noteController.text,
                                );

                                if (!context.mounted) return;
                                setDialogState(() => isLoading = false);

                                if (error == null) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Berhasil ditambahkan ke itinerary.'),
                                      backgroundColor: Colors.teal,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2cd4bf),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
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

  void _showImageGalleryDialog(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) {
        final pageController = PageController(initialPage: initialIndex);
        int currentPage = initialIndex;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black87,
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: widget.galleryImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        child: Image.network(
                          widget.galleryImages[index],
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 30),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '${currentPage + 1} / ${widget.galleryImages.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi Logika untuk Membuka Rute Peta
  Future<void> _bukaRutePeta() async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.title)}';
    final Uri url = Uri.parse(googleMapsUrl);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka maps';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka peta untuk ${widget.title}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xfff8fafd),
      body: Stack(
        children: [
          // 1. Gambar Latar Belakang Dinamis (Header)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.5,
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

          // 2. Tombol Aksi Atas
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
                Consumer<WishlistProvider>(
                  builder: (context, wishlistProvider, child) {
                    final bool isFavorite = wishlistProvider.isWishlisted(widget.destinationId);
                    return _buildCircleIconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFavorite ? Colors.red : Colors.white,
                      onTap: () async {
                        final token = context.read<AuthProvider>().token;
                        if (token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silahkan login terlebih dahulu untuk menyimpan ke wishlist'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                          return;
                        }
                        
                        bool newStatus = await wishlistProvider.toggleWishlist(token, widget.destinationId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(newStatus ? '${widget.title} ditambahkan ke Wishlist' : '${widget.title} dihapus dari Wishlist'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: newStatus ? Colors.teal : Colors.grey[800],
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Konten Utama Menggunakan DraggableScrollableSheet
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.65, 
              minChildSize: 0.55, 
              maxChildSize: 0.90, 
              snap: true, 
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
                  child: SingleChildScrollView(
                    controller: scrollController, 
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                        if (widget.galleryImages.isNotEmpty) ...[
                          const Text(
                            'Galeri Foto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0d1e3d),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.galleryImages.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => _showImageGalleryDialog(
                                      context, index),
                                  child: Container(
                                    width: 160,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            widget.galleryImages[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

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
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DaftarUlasanScreen(
                                      destinationId: widget.destinationId,
                                      destinationTitle: widget.title,
                                    ),
                                  ),
                                );
                                _fetchReviews();
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. Bottom Action Buttons
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
                      onPressed: () async {
                        final token = context.read<AuthProvider>().token;
                        if (token != null) {
                          await context.read<ItineraryProvider>().fetchItineraries(token);
                          if (context.mounted) {
                            _showPilihItineraryDialog(context);
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Silahkan login terlebih dahulu untuk menambahkan itinerary'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          }
                        }
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
    if (_isLoadingReviews) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_reviewError != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('Gagal memuat ulasan', style: TextStyle(color: Colors.red))),
      );
    }
    if (_reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: const Center(
          child: Text('Belum ada ulasan untuk destinasi ini.'),
        ),
      );
    }
    
    final review = _reviews.first;
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
              CircleAvatar(
                radius: 20,
                backgroundImage: review.userAvatar != null && review.userAvatar!.isNotEmpty
                    ? NetworkImage(review.userAvatar!)
                    : null,
                child: (review.userAvatar == null || review.userAvatar!.isEmpty) 
                    ? Text(review.initial)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0d1e3d),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      review.date,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star, 
                    color: index < review.rating ? Colors.amber : Colors.grey[300], 
                    size: 14
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
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

// --- SCREEN DAFTAR ULASAN ---
class DaftarUlasanScreen extends StatefulWidget {
  final int destinationId;
  final String destinationTitle;

  const DaftarUlasanScreen({
    super.key,
    required this.destinationId,
    required this.destinationTitle,
  });

  @override
  State<DaftarUlasanScreen> createState() => _DaftarUlasanScreenState();
}

class _DaftarUlasanScreenState extends State<DaftarUlasanScreen> {
  List<Review> _reviewsList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final reviews = await ApiService().fetchDestinationReviews(widget.destinationId);
      setState(() {
        _reviewsList = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showTulisUlasanDialog(BuildContext context) {
    String ulasanInput = "";
    int selectedStars = 5;
    bool isSubmitting = false;

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
                  onPressed: isSubmitting ? null : () async {
                    if (ulasanInput.trim().isNotEmpty) {
                      setDialogState(() {
                        isSubmitting = true;
                      });
                      try {
                        final token = context.read<AuthProvider>().token!;
                        final newReview = await ApiService().postReview(
                          token: token,
                          destinationId: widget.destinationId,
                          rating: selectedStars,
                          comment: ulasanInput.trim(),
                        );
                        setState(() {
                          _reviewsList.insert(0, newReview);
                        });
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ulasan berhasil disimpan!'),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          isSubmitting = false;
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap isi Ulasan Anda!'),
                        ),
                      );
                    }
                  },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
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
            onPressed: () {
              // Modifikasi logika di IconButton AppBar
              final token = context.read<AuthProvider>().token;
              if (token != null) {
                _showTulisUlasanDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Silahkan login terlebih dahulu untuk menulis ulasan'),
                    backgroundColor: Colors.orange,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _reviewsList.isEmpty
                  ? const Center(child: Text('Belum ada ulasan.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _reviewsList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _reviewsList[index];
                        return ItemReviewCard(
                          nama: item.userName,
                          waktu: item.date,
                          rating: item.rating.toInt(),
                          isi: item.comment,
                          avatarUrl: item.userAvatar,
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Modifikasi logika di FloatingActionButton
          final token = context.read<AuthProvider>().token;
          if (token != null) {
            _showTulisUlasanDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Silahkan login terlebih dahulu untuk menulis ulasan'),
                backgroundColor: Colors.orange,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
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
  final String? avatarUrl;

  const ItemReviewCard({
    super.key,
    required this.nama,
    required this.waktu,
    required this.rating,
    required this.isi,
    this.avatarUrl,
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
              CircleAvatar(
                radius: 18,
                backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? Text(nama.isNotEmpty ? nama[0].toUpperCase() : '?')
                    : null,
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