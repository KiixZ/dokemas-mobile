import 'package:flutter/material.dart';

/// Model kategori destinasi (UI only, belum konek backend).
class Category {
  final int? id;
  final String name;
  final IconData icon;
  final String iconString;
  final int count;
  final bool active;

  const Category({
    this.id,
    required this.name,
    required this.icon,
    this.iconString = '',
    this.count = 0,
    this.active = true,
  });

  Category copyWith({bool? active}) => Category(
        id: id,
        name: name,
        icon: icon,
        iconString: iconString,
        count: count,
        active: active ?? this.active,
      );

  factory Category.fromJson(Map<String, dynamic> json) {
    IconData getIcon(String? iconName) {
      // Map string to IconData roughly based on categoryIconOptions
      switch (iconName) {
        case 'terrain': return Icons.terrain;
        case 'family_restroom': return Icons.family_restroom;
        case 'restaurant': return Icons.restaurant;
        case 'school': return Icons.school;
        case 'mosque': return Icons.mosque;
        case 'diamond': return Icons.diamond;
        case 'beach_access': return Icons.beach_access;
        case 'museum': return Icons.museum;
        case 'park': return Icons.park;
        case 'local_activity': return Icons.local_activity;
        case 'water': return Icons.water;
        case 'hiking': return Icons.hiking;
        default: return Icons.category;
      }
    }

    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      iconString: json['icon'] ?? '',
      icon: getIcon(json['icon']),
      count: json['destinations_count'] ?? 0,
      active: true, // Backend doesn't have active state currently
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': iconString,
    };
  }

  static String getIconName(IconData icon) {
    if (icon == Icons.terrain) return 'terrain';
    if (icon == Icons.family_restroom) return 'family_restroom';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.mosque) return 'mosque';
    if (icon == Icons.diamond) return 'diamond';
    if (icon == Icons.beach_access) return 'beach_access';
    if (icon == Icons.museum) return 'museum';
    if (icon == Icons.park) return 'park';
    if (icon == Icons.local_activity) return 'local_activity';
    if (icon == Icons.water) return 'water';
    if (icon == Icons.hiking) return 'hiking';
    return 'category';
  }
}

/// Pilihan icon buat form tambah/edit kategori.
const categoryIconOptions = [
  Icons.terrain,
  Icons.family_restroom,
  Icons.restaurant,
  Icons.school,
  Icons.mosque,
  Icons.diamond,
  Icons.beach_access,
  Icons.museum,
  Icons.park,
  Icons.local_activity,
  Icons.water,
  Icons.hiking,
];

/// Data dummy kelola kategori.
const dummyCategories = [
  Category(name: 'Alam', icon: Icons.terrain, count: 24),
  Category(name: 'Keluarga', icon: Icons.family_restroom, count: 18),
  Category(name: 'Kuliner', icon: Icons.restaurant, count: 32),
  Category(name: 'Edukasi', icon: Icons.school, count: 5, active: false),
  Category(name: 'Religi', icon: Icons.mosque, count: 12),
  Category(name: 'Hidden Gem', icon: Icons.diamond, count: 8),
];
