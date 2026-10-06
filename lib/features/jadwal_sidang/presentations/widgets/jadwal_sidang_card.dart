import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/jadwal_sidang/data/models/jadwal_sidang.dart';
import 'package:flutter/material.dart';

class JadwalSidangCard extends StatefulWidget {
  const JadwalSidangCard({super.key, required this.jadwal});

  final JadwalSidangDetail jadwal;

  @override
  State<JadwalSidangCard> createState() => _JadwalSidangCardState();
}

class _JadwalSidangCardState extends State<JadwalSidangCard> {
  static const _maxVisible = 3;

  bool _showAllPemohon = false;
  bool _showAllKuasa = false;

  @override
  Widget build(BuildContext context) {
    final jadwal = widget.jadwal;
    final perkara = jadwal.tbPerkara;
    final permohonan = (perkara?.permohonan.isNotEmpty == true)
        ? perkara!.permohonan.first
        : null;

    final pemohonList =
        permohonan?.pemohonList.map((p) => p.nama).toList() ?? [];
    final kuasaList = permohonan?.kuasa.map((k) => k.nama).toList() ?? [];

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (jadwal.jenisSidang.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      jadwal.jenisSidang,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                if (jadwal.isPercepat)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'PERCEPAT',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            _buildRow(
              label: 'Tanggal',
              value: _formatTanggalPanjang(jadwal.date),
              valueBold: true,
            ),
            const SizedBox(height: 8),

            _buildRow(
              label: 'Perkara',
              value: perkara?.nomorPerkara ?? '-',
              valueBold: true,
            ),
            const SizedBox(height: 8),

            if (perkara != null && perkara.pokokPerkara.isNotEmpty) ...[
              _buildRow(label: 'Pokok', value: perkara.pokokPerkara),
              const SizedBox(height: 8),
            ],

            if (pemohonList.isNotEmpty) ...[
              _buildCollapsibleRow(
                label: 'Pemohon',
                items: pemohonList,
                expanded: _showAllPemohon,
                onToggle: () =>
                    setState(() => _showAllPemohon = !_showAllPemohon),
              ),
              const SizedBox(height: 8),
            ],

            if (kuasaList.isNotEmpty) ...[
              _buildCollapsibleRow(
                label: 'Kuasa',
                items: kuasaList,
                expanded: _showAllKuasa,
                onToggle: () => setState(() => _showAllKuasa = !_showAllKuasa),
              ),
              const SizedBox(height: 8),
            ],

            _buildRow(label: 'Acara', value: jadwal.acaraSidang),
            const SizedBox(height: 8),

            if (jadwal.tempat.isNotEmpty) ...[
              _buildRow(
                label: 'Tempat',
                value: jadwal.tempat.replaceAll('<br/>', '\n'),
              ),
              const SizedBox(height: 8),
            ],

            _buildRow(
              label: 'Keterangan',
              value: jadwal.statusPercepatMsg.isNotEmpty
                  ? jadwal.statusPercepatMsg
                  : '-',
            ),

            if (jadwal.hasTracking) ...[
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => UrlHelper.open(jadwal.trackingLink),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.open_in_new, size: 14, color: Colors.blue),
                      SizedBox(width: 6),
                      Text(
                        'Lacak Perkara',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleRow({
    required String label,
    required List<String> items,
    required bool expanded,
    required VoidCallback onToggle,
  }) {
    final hasMore = items.length > _maxVisible;
    final visibleItems = expanded ? items : items.take(_maxVisible).toList();
    final remaining = items.length - _maxVisible;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const Text(':', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in visibleItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.text,
                      height: 1.5,
                    ),
                  ),
                ),

              if (hasMore)
                GestureDetector(
                  onTap: onToggle,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          expanded ? 'Sembunyikan' : 'Lihat $remaining lainnya',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    bool valueBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const Text(':', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.text,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTanggalPanjang(DateTime? dt) {
    if (dt == null) return '-';
    final wib = dt.toUtc().add(const Duration(hours: 7));

    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final namaHari = hari[wib.weekday - 1];
    final tgl = wib.day.toString().padLeft(2, '0');
    final namaBulan = bulan[wib.month - 1];
    final jam = wib.hour.toString().padLeft(2, '0');
    final menit = wib.minute.toString().padLeft(2, '0');

    return '$namaHari, $tgl $namaBulan ${wib.year}, $jam:$menit WIB';
  }
}
