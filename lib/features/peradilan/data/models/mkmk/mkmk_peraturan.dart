class MkmkPeraturan {
  final String nomor;
  final String tentang;
  final String supportingFileUrl;

  const MkmkPeraturan({
    required this.nomor,
    required this.tentang,
    required this.supportingFileUrl,
  });

  bool get hasFile => supportingFileUrl.isNotEmpty;

  factory MkmkPeraturan.fromJson(Map<String, dynamic> json) {
    return MkmkPeraturan(
      nomor: json['nomor']?.toString() ?? '',
      tentang: json['tentang']?.toString() ?? '',
      supportingFileUrl: json['supporting_file_url']?.toString() ?? '',
    );
  }
}
