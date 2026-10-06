class PeraturanItem {
  final String judul;
  final String tentang;
  final int downloadCount;
  final String supportingFileUrl;

  const PeraturanItem({
    required this.judul,
    required this.tentang,
    required this.downloadCount,
    required this.supportingFileUrl,
  });

  bool get hasFile => supportingFileUrl.isNotEmpty;

  factory PeraturanItem.fromJson(Map<String, dynamic> json) {
    return PeraturanItem(
      judul: json['judul']?.toString() ?? '',
      tentang: json['tentang']?.toString() ?? '',
      downloadCount: _parseInt(json['download_count']),
      supportingFileUrl: json['supporting_file_url']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
