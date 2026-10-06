import 'package:click_mk/features/berita/data/models/berita_kategori.dart';
import 'package:flutter/material.dart';

class BeritaChipBar extends StatelessWidget {
  const BeritaChipBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.onSiaranPersTap,
  });

  final BeritaKategori selected;
  final ValueChanged<BeritaKategori> onSelected;

  final VoidCallback? onSiaranPersTap;

  @override
  Widget build(BuildContext context) {
    final regularKategori = BeritaKategori.values
        .where((k) => k != BeritaKategori.siaranPers)
        .toList();

    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < regularKategori.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _buildChip(regularKategori[i]),
          ],

          if (onSiaranPersTap != null) ...[
            const SizedBox(width: 8),
            _buildSiaranPersButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(BeritaKategori kategori) {
    final isSelected = kategori == selected;
    return ChoiceChip(
      label: Text(kategori.label),
      selected: isSelected,
      onSelected: (value) {
        if (value) onSelected(kategori);
      },
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.red : Colors.black87,
      ),
      selectedColor: Colors.red.shade50,
      backgroundColor: Colors.grey.shade100,
      side: isSelected
          ? BorderSide(color: Colors.red.shade200, width: 1)
          : BorderSide.none,
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildSiaranPersButton(BuildContext context) {
    return Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onSiaranPersTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.campaign_outlined, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Siaran Pers',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
