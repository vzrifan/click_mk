class MkmkProfil {
  final String profilePictureUrl;
  final String nama;
  final String alamat;
  final String agama;
  final String jabatan;
  final String masaJabatan;
  final DateTime? tempatTanggalLahir;
  final String profilHtml;

  const MkmkProfil({
    required this.profilePictureUrl,
    required this.nama,
    required this.alamat,
    required this.agama,
    required this.jabatan,
    required this.masaJabatan,
    required this.tempatTanggalLahir,
    required this.profilHtml,
  });

  factory MkmkProfil.fromJson(Map<String, dynamic> json) {
    return MkmkProfil(
      profilePictureUrl: json['profile_picture_url']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      agama: json['agama']?.toString() ?? '',
      jabatan: json['jabatan']?.toString() ?? '',
      masaJabatan: json['masa_jabatan']?.toString() ?? '',
      tempatTanggalLahir: DateTime.tryParse(
        json['tempat_tanggal_lahir']?.toString() ?? '',
      ),
      profilHtml: json['profil']?.toString() ?? '',
    );
  }
}
