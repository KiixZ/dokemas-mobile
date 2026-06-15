import 'package:flutter/material.dart';

/// Model kategori destinasi (UI only, belum konek backend).
class Category {
  final String name;
  final IconData icon;
  final int count; // jumlah destinasi
  final bool active;

  const Category({
    required this.name,
    required this.icon,
    required this.count,
    this.active = true,
  });

  Category copyWith({bool? active}) => Category(
        name: name,
        icon: icon,
        count: count,
        active: active ?? this.active,
      );
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
