class MasaJabatan {
  final String jabatan;
  final String? lembagaPengusul;
  final String tahunMenjabat;
  final String tahunSelesaiMenjabat;

  const MasaJabatan({
    required this.jabatan,
    required this.lembagaPengusul,
    required this.tahunMenjabat,
    required this.tahunSelesaiMenjabat,
  });

  factory MasaJabatan.fromJson(Map<String, dynamic> json) {
    return MasaJabatan(
      jabatan: json['jabatan'] as String? ?? '',
      lembagaPengusul: json['lembagaPengusul'] as String?,
      tahunMenjabat: json['tahun_menjabat']?.toString() ?? '',
      tahunSelesaiMenjabat: json['tahun_selesai_menjabat']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'jabatan': jabatan,
    'lembagaPengusul': lembagaPengusul,
    'tahun_menjabat': tahunMenjabat,
    'tahun_selesai_menjabat': tahunSelesaiMenjabat,
  };
}
