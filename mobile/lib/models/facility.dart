import 'package:flutter/material.dart';

/// Model fasilitas destinasi (UI only, belum konek backend).
class Facility {
  final String name;
  final IconData icon;
  final int count; // jumlah destinasi yang punya fasilitas ini
  final bool active;

  const Facility({
    required this.name,
    required this.icon,
    required this.count,
    this.active = true,
  });

  Facility copyWith({bool? active}) => Facility(
        name: name,
        icon: icon,
        count: count,
        active: active ?? this.active,
      );
}

/// Pilihan icon buat form tambah/edit fasilitas.
const facilityIconOptions = [
  Icons.wc,
  Icons.local_parking,
  Icons.mosque,
  Icons.restaurant,
  Icons.wifi,
  Icons.pool,
  Icons.local_cafe,
  Icons.hotel,
  Icons.photo_camera,
  Icons.deck,
  Icons.directions_walk,
  Icons.atm,
];

/// Data dummy kelola fasilitas.
const dummyFacilities = [
  Facility(name: 'Toilet', icon: Icons.wc, count: 86),
  Facility(name: 'Parkir', icon: Icons.local_parking, count: 92),
  Facility(name: 'Mushola', icon: Icons.mosque, count: 74),
  Facility(name: 'Warung', icon: Icons.local_cafe, count: 63),
  Facility(name: 'Wifi', icon: Icons.wifi, count: 21, active: false),
  Facility(name: 'Spot Foto', icon: Icons.photo_camera, count: 48),
];
