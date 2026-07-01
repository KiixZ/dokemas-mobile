import '../theme/app_colors.dart';
import 'package:intl/intl.dart';

/// Status moderasi review.
/// pending = baru masuk dari user, nunggu di-Accept/Reject admin.
enum ReviewStatus { pending, public, reported, hidden }

ReviewStatus _parseStatus(String? statusStr) {
  switch (statusStr) {
    case 'pending': return ReviewStatus.pending;
    case 'public': return ReviewStatus.public;
    case 'reported': return ReviewStatus.reported;
    case 'hidden': return ReviewStatus.hidden;
    default: return ReviewStatus.public;
  }
}



/// Model review/ulasan user dari backend.
class Review {
  final int id;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int destinationId;
  final String destinationName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final ReviewStatus status;
  final int flagCount;
  final String? flagReason;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.destinationId,
    required this.destinationName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.status = ReviewStatus.public,
    this.flagCount = 0,
    this.flagReason,
  });

  String get initial => userName.isEmpty ? '?' : userName[0].toUpperCase();

  String get date {
    return DateFormat('MMM dd, yyyy').format(createdAt);
  }

  static String? _parseAvatar(dynamic avatarStr) {
    if (avatarStr == null) return null;
    final String avatar = avatarStr.toString();
    if (avatar.isEmpty) return null;
    if (avatar.startsWith('http')) {
      return avatar.replaceFirst('http://', 'https://');
    }
    return 'https://porto-backend-dokemas.rryxja.easypanel.host/storage/$avatar';
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'] ?? json['user']?['id'] ?? 0,
      userName: json['user']?['name'] ?? 'Unknown',
      userAvatar: _parseAvatar(json['user']?['avatar']),
      destinationId: json['destination_id'] ?? json['destination']?['id'] ?? 0,
      destinationName: json['destination']?['name'] ?? 'Unknown Destination',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      status: _parseStatus(json['status']),
      flagCount: json['flag_count'] ?? 0,
      flagReason: json['flag_reason'],
    );
  }

  Review copyWith({ReviewStatus? status, int? flagCount, String? flagReason}) => Review(
        id: id,
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        destinationId: destinationId,
        destinationName: destinationName,
        rating: rating,
        comment: comment,
        createdAt: createdAt,
        status: status ?? this.status,
        flagCount: flagCount ?? this.flagCount,
        flagReason: flagReason ?? this.flagReason,
      );
}

/// Warna avatar diputar dari palet biar variatif.
const reviewAvatarColors = [
  AppColors.primary,
  AppColors.accent,
  AppColors.info,
  AppColors.statPurple,
];
