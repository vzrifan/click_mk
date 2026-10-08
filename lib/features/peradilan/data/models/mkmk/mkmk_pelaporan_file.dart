class MkmkPelaporanFile {
  final String jenisDokumen;
  final String nama;
  final String fileUrl;

  const MkmkPelaporanFile({
    required this.jenisDokumen,
    required this.nama,
    required this.fileUrl,
  });

  bool get hasFile => fileUrl.isNotEmpty;

  factory MkmkPelaporanFile.fromJson(Map<String, dynamic> json) {
    return MkmkPelaporanFile(
      jenisDokumen: json['jenis_dokumen']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
    );
  }
}
