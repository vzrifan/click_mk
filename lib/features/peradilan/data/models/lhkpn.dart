class Lhkpn {
  final String tahun;
  final String judul;
  final String supportingFileUrl;

  const Lhkpn({
    required this.tahun,
    required this.judul,
    required this.supportingFileUrl,
  });

  bool get hasFile => supportingFileUrl.isNotEmpty;

  factory Lhkpn.fromJson(Map<String, dynamic> json) {
    return Lhkpn(
      tahun: json['tahun']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      supportingFileUrl: json['supporting_file_url']?.toString() ?? '',
    );
  }
}
