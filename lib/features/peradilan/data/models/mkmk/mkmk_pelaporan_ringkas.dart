class MkmkPelaporanRingkas {
  final String nomorRegistrasi;
  final String judulPelaporan;
  final List<String> pelapor;
  final List<String> kuasa;

  const MkmkPelaporanRingkas({
    required this.nomorRegistrasi,
    required this.judulPelaporan,
    required this.pelapor,
    required this.kuasa,
  });

  factory MkmkPelaporanRingkas.fromJson(Map<String, dynamic> json) {
    return MkmkPelaporanRingkas(
      nomorRegistrasi: json['nomor_registrasi']?.toString().trim() ?? '',
      judulPelaporan: json['judul_pelaporan']?.toString().trim() ?? '',
      pelapor: _parseNamaList(json['pelapor']),
      kuasa: _parseNamaList(json['kuasa']),
    );
  }

  static List<String> _parseNamaList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((e) {
          if (e is Map<String, dynamic>) {
            return e['nama']?.toString() ?? '';
          }
          return e?.toString() ?? '';
        })
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
