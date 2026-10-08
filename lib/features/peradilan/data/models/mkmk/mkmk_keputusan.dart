class MkmkKeputusan {
  final DateTime? tanggal;
  final String nomorKeputusan;
  final String keterangan;
  final String supportingFile;
  final String linkHit;
  final int downloadCount;

  const MkmkKeputusan({
    required this.tanggal,
    required this.nomorKeputusan,
    required this.keterangan,
    required this.supportingFile,
    required this.linkHit,
    required this.downloadCount,
  });

  bool get hasFile => supportingFile.isNotEmpty;

  factory MkmkKeputusan.fromJson(Map<String, dynamic> json) {
    return MkmkKeputusan(
      tanggal: DateTime.tryParse(json['tanggal']?.toString() ?? ''),
      nomorKeputusan: json['nomor_keputusan']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      supportingFile: json['supporting_file']?.toString() ?? '',
      linkHit: json['link_hit']?.toString() ?? '',
      downloadCount: _parseInt(json['download_count']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
