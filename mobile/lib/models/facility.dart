import 'package:flutter/material.dart';

/// Model fasilitas destinasi (UI only, belum konek backend).
class Facility {
  final int? id;
  final String name;
  final IconData icon;
  final String iconString;
  final int count; // jumlah destinasi yang punya fasilitas ini
  final bool active;

  const Facility({
    this.id,
    required this.name,
    required this.icon,
    this.iconString = '',
    this.count = 0,
    this.active = true,
  });

  Facility copyWith({bool? active}) => Facility(
        id: id,
        name: name,
        icon: icon,
        iconString: iconString,
        count: count,
        active: active ?? this.active,
      );

  factory Facility.fromJson(Map<String, dynamic> json) {
    IconData getIcon(String? iconName) {
      switch (iconName) {
        case 'wc': return Icons.wc;
        case 'local_parking': return Icons.local_parking;
        case 'mosque': return Icons.mosque;
        case 'restaurant': return Icons.restaurant;
        case 'wifi': return Icons.wifi;
        case 'pool': return Icons.pool;
        case 'local_cafe': return Icons.local_cafe;
        case 'hotel': return Icons.hotel;
        case 'photo_camera': return Icons.photo_camera;
        case 'deck': return Icons.deck;
        case 'directions_walk': return Icons.directions_walk;
        case 'atm': return Icons.atm;
        case 'local_hospital': return Icons.local_hospital;
        case 'storefront': return Icons.storefront;
        case 'info_outline': return Icons.info_outline;
        case 'tour': return Icons.tour;
        case 'accessible': return Icons.accessible;
        case 'child_friendly': return Icons.child_friendly;
        case 'cottage': return Icons.cottage;
        case 'outdoor_grill': return Icons.outdoor_grill;
        case 'pedal_bike': return Icons.pedal_bike;
        case 'nature_people': return Icons.nature_people;
        default: return Icons.check_circle_outline;
      }
    }

    return Facility(
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
    if (icon == Icons.wc) return 'wc';
    if (icon == Icons.local_parking) return 'local_parking';
    if (icon == Icons.mosque) return 'mosque';
    if (icon == Icons.restaurant) return 'restaurant';
    if (icon == Icons.wifi) return 'wifi';
    if (icon == Icons.pool) return 'pool';
    if (icon == Icons.local_cafe) return 'local_cafe';
    if (icon == Icons.hotel) return 'hotel';
    if (icon == Icons.photo_camera) return 'photo_camera';
    if (icon == Icons.deck) return 'deck';
    if (icon == Icons.directions_walk) return 'directions_walk';
    if (icon == Icons.atm) return 'atm';
    if (icon == Icons.local_hospital) return 'local_hospital';
    if (icon == Icons.storefront) return 'storefront';
    if (icon == Icons.info_outline) return 'info_outline';
    if (icon == Icons.tour) return 'tour';
    if (icon == Icons.accessible) return 'accessible';
    if (icon == Icons.child_friendly) return 'child_friendly';
    if (icon == Icons.cottage) return 'cottage';
    if (icon == Icons.outdoor_grill) return 'outdoor_grill';
    if (icon == Icons.pedal_bike) return 'pedal_bike';
    if (icon == Icons.nature_people) return 'nature_people';
    return 'check_circle_outline';
  }
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
  Icons.local_hospital,
  Icons.storefront,
  Icons.info_outline,
  Icons.tour,
  Icons.accessible,
  Icons.child_friendly,
  Icons.cottage,
  Icons.outdoor_grill,
  Icons.pedal_bike,
  Icons.nature_people,
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
