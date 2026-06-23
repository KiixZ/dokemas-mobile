import 'review.dart';
import 'destination.dart';

class DashboardStats {
  final int totalDestinations;
  final int totalUsers;
  final int totalReviews;
  final int totalCategories;
  final int totalFacilities;
  final List<Review> latestReviews;
  final List<Destination> topDestinations;

  DashboardStats({
    required this.totalDestinations,
    required this.totalUsers,
    required this.totalReviews,
    required this.totalCategories,
    required this.totalFacilities,
    required this.latestReviews,
    required this.topDestinations,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalDestinations: json['total_destinations'] ?? 0,
      totalUsers: json['total_users'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
      totalFacilities: json['total_facilities'] ?? 0,
      latestReviews: json['latest_reviews'] != null
          ? (json['latest_reviews'] as List)
              .map((e) => Review.fromJson(e))
              .toList()
          : [],
      topDestinations: json['top_destinations'] != null
          ? (json['top_destinations'] as List)
              .map((e) => Destination.fromJson(e))
              .toList()
          : [],
    );
  }
}
