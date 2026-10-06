class PeraturanUud {
  final int id;
  final String judul;
  final String supportingFileUrl;
  final int downloadCount;
  final DateTime? createdDate;

  const PeraturanUud({
    required this.id,
    required this.judul,
    required this.supportingFileUrl,
    required this.downloadCount,
    required this.createdDate,
  });

  bool get hasFile => supportingFileUrl.isNotEmpty;

  factory PeraturanUud.fromJson(Map<String, dynamic> json) {
    return PeraturanUud(
      id: _parseInt(json['id']),
      judul: json['judul']?.toString() ?? '',
      supportingFileUrl: json['supporting_file_url']?.toString() ?? '',
      downloadCount: _parseInt(json['download_count']),
      createdDate: DateTime.tryParse(json['created_date']?.toString() ?? ''),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
