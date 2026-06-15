import 'package:flutter/material.dart';

// FUNGSI UTAMA UNTUK MENAMPILKAN FILTER
void showFilterBottomSheet(BuildContext context) {
  String selectedHarga = '< 10k';
  String selectedJarak = '';
  String selectedRating = '4.5+';
  String selectedKategori = 'Air Terjun';
  List<String> selectedFasilitas = ['Parkir Luas', 'Mushola'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff063940)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xffe8f1f2), iconSize: 20),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),

                _buildFilterTitle('Harga Tiket'),
                _buildFilterRow(
                  ['Gratis', '< 10k', '10k - 25k', '> 25k'],
                  selectedHarga,
                  (value) => setModalState(() => selectedHarga = value),
                ),

                _buildFilterTitle('Jarak'),
                _buildFilterRow(
                  ['< 5km', '5 - 10km', '> 10km'],
                  selectedJarak,
                  (value) => setModalState(() => selectedJarak = value),
                ),

                _buildFilterTitle('Rating'),
                _buildFilterRow(
                  ['★ 4.0+', '★ 4.5+'],
                  selectedRating,
                  (value) => setModalState(() => selectedRating = value),
                ),

                _buildFilterTitle('Kategori'),
                _buildFilterRow(
                  ['Alam', 'Air Terjun', 'Budaya', 'Kuliner'],
                  selectedKategori,
                  (value) => setModalState(() => selectedKategori = value),
                ),

                _buildFilterTitle('Fasilitas'),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: ['Parkir Luas', 'Toilet Umum', 'Mushola', 'Area Makan'].map((fasilitas) {
                    final isSelected = selectedFasilitas.contains(fasilitas);
                    return _buildFilterChip(
                      label: fasilitas,
                      isSelected: isSelected,
                      onTap: () {
                        setModalState(() {
                          if (isSelected) {
                            selectedFasilitas.remove(fasilitas);
                          } else {
                            selectedFasilitas.add(fasilitas);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedHarga = '';
                          selectedJarak = '';
                          selectedRating = '';
                          selectedKategori = '';
                          selectedFasilitas.clear();
                        });
                      },
                      child: const Text('Reset', style: TextStyle(color: Color(0xff00a896), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff028090),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Terapkan Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}

// SUB-WIDGET PENDUKUNG (Dipindahkan juga agar filenya mandiri)
Widget _buildFilterTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
    child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff063940))),
  );
}

Widget _buildFilterRow(List<String> options, String selectedValue, Function(String) onSelect) {
  return Wrap(
    spacing: 10,
    runSpacing: 8,
    children: options.map((option) {
      return _buildFilterChip(
        label: option,
        isSelected: selectedValue == option,
        onTap: () => onSelect(option),
      );
    }).toList(),
  );
}

Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xff028090) : const Color(0xffe8f1f2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xff063940),
        ),
      ),
    ),
  );
}