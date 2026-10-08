class Pejabat {
  final int id;
  final String nama;
  final String jabatan;
  final String apiLhkpn;
  final String profilePictureUrl;
  final String alamat;
  final String agama;
  final String pendidikanHtml;
  final String karirHtml;
  final String organisasi;
  final String profilHtml;

  const Pejabat({
    required this.id,
    required this.nama,
    required this.jabatan,
    required this.apiLhkpn,
    required this.profilePictureUrl,
    required this.alamat,
    required this.agama,
    required this.pendidikanHtml,
    required this.karirHtml,
    required this.organisasi,
    required this.profilHtml,
  });

  factory Pejabat.fromJson(Map<String, dynamic> json) {
    return Pejabat(
      id: _parseInt(json['id']),
      nama: json['nama']?.toString() ?? '',
      jabatan: json['jabatan']?.toString() ?? '',
      apiLhkpn: json['api_lhkpn']?.toString() ?? '',
      profilePictureUrl: json['profile_picture_url']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      agama: json['agama']?.toString() ?? '',
      pendidikanHtml: json['pendidikan']?.toString() ?? '',
      karirHtml: json['karir']?.toString() ?? '',
      organisasi: json['organisasi']?.toString() ?? '',
      profilHtml: json['profil']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
