import 'package:click_mk/features/pengumuman/data/models/jenis_supporting_file.dart';

class Pengumuman {
  final DateTime? date;
  final String judul;
  final int downloadCount;
  final String supportingFile;
  final JenisSupportingFile jenisSupportingFile;
  final String jenisPengumuman;
  final String linkHit;

  const Pengumuman({
    required this.date,
    required this.judul,
    required this.downloadCount,
    required this.supportingFile,
    required this.jenisSupportingFile,
    required this.jenisPengumuman,
    required this.linkHit,
  });

  bool get hasFile => supportingFile.isNotEmpty;

  factory Pengumuman.fromJson(Map<String, dynamic> json) {
    final rawDate =
        json['date']?.toString() ?? json['tanggal']?.toString() ?? '';

    return Pengumuman(
      date: DateTime.tryParse(rawDate),
      judul: json['judul']?.toString() ?? '',
      downloadCount: _parseInt(json['download_count']),
      supportingFile: json['supporting_file']?.toString() ?? '',
      jenisSupportingFile: JenisSupportingFile.fromApi(
        json['jenis_supporting_file']?.toString(),
      ),
      jenisPengumuman: json['jenis_pengumuman']?.toString() ?? '',
      linkHit: json['link_hit']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
