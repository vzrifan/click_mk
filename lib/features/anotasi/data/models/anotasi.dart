class Anotasi {
  final String title;
  final String supportingFile;
  final DateTime? date;
  final int downloadCount;
  final String linkHit;

  const Anotasi({
    required this.title,
    required this.supportingFile,
    required this.date,
    required this.downloadCount,
    required this.linkHit,
  });

  bool get hasPdf => supportingFile.isNotEmpty;

  factory Anotasi.fromJson(Map<String, dynamic> json) {
    return Anotasi(
      title: json['title']?.toString() ?? '',
      supportingFile: json['supporting_file']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      downloadCount: _parseInt(json['download_count']),
      linkHit: json['link_hit']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
