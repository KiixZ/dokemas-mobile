import '../theme/app_colors.dart';

/// Status moderasi review.
enum ReviewStatus { public, reported, hidden }

/// Model review/ulasan user (UI only, belum konek backend).
class Review {
  final String name;
  final String date; // mis. "Oct 24, 2023"
  final double rating; // 0..5
  final String destination;
  final String comment;
  final ReviewStatus status;
  final int flagCount; // jumlah laporan (kalau reported)
  final String? flagReason;

  const Review({
    required this.name,
    required this.date,
    required this.rating,
    required this.destination,
    required this.comment,
    this.status = ReviewStatus.public,
    this.flagCount = 0,
    this.flagReason,
  });

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();

  Review copyWith({ReviewStatus? status}) => Review(
        name: name,
        date: date,
        rating: rating,
        destination: destination,
        comment: comment,
        status: status ?? this.status,
        flagCount: flagCount,
        flagReason: flagReason,
      );
}

/// Warna avatar diputar dari palet biar variatif.
const reviewAvatarColors = [
  AppColors.primary,
  AppColors.accent,
  AppColors.info,
  AppColors.statPurple,
];

/// Data dummy kelola review.
const dummyReviews = [
  Review(
    name: 'Budi Santoso',
    date: 'Oct 24, 2023',
    rating: 5.0,
    destination: 'Baturraden Waterfall',
    comment:
        'Absolutely breathtaking experience! The path was well maintained and the views at the top were worth the hike. Highly recommend going.',
    status: ReviewStatus.public,
  ),
  Review(
    name: 'Anonymous User',
    date: 'Oct 23, 2023',
    rating: 1.0,
    destination: 'Alun-Alun Purwokerto',
    comment:
        '[Hidden due to inappropriate content] The facilities were terrible and the staff was unhelpful.',
    status: ReviewStatus.reported,
    flagCount: 3,
    flagReason: 'inappropriate language',
  ),
  Review(
    name: 'Siti Rahma',
    date: 'Oct 21, 2023',
    rating: 4.0,
    destination: 'Small World Miniatures',
    comment:
        'Great place for family photos! The miniatures are quite detailed. Only giving 4 stars because it gets very hot in the afternoon with limited shade.',
    status: ReviewStatus.public,
  ),
  Review(
    name: 'Deni W.',
    date: 'Oct 19, 2023',
    rating: 3.0,
    destination: 'Telaga Sunyi',
    comment: 'Review temporarily hidden by admin.',
    status: ReviewStatus.hidden,
  ),
];
