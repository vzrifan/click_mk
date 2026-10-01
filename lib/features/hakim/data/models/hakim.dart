import 'package:click_mk/features/hakim/data/models/masa_jabatan.dart';

class Hakim {
  final int profileId;
  final String namaLengkap;
  final String jabatan;
  final String profilePictureUrl;
  final int status;
  final String profilHtml;
  final int nomorUrut;
  final List<MasaJabatan> masaJabatan;

  const Hakim({
    required this.profileId,
    required this.namaLengkap,
    required this.jabatan,
    required this.profilePictureUrl,
    required this.status,
    required this.profilHtml,
    required this.nomorUrut,
    required this.masaJabatan,
  });

  String get profilPlainText {
    return profilHtml
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&ndash;', '–')
        .replaceAll('&lsquo;', '\u2018')
        .replaceAll('&rsquo;', '\u2019')
        .replaceAll('&ldquo;', '\u201C')
        .replaceAll('&rdquo;', '\u201D')
        .replaceAll('&amp;', '&')
        .trim();
  }

  factory Hakim.fromJson(Map<String, dynamic> json) {
    final masaJabatanJson = (json['masa_jabatan'] as List<dynamic>? ?? []);
    return Hakim(
      profileId: json['profile_id'] as int? ?? 0,
      namaLengkap: json['nama_lengkap'] as String? ?? '',
      jabatan: json['jabatan'] as String? ?? '',
      profilePictureUrl: json['profile_picture_url'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      profilHtml: json['profil'] as String? ?? '',
      nomorUrut: json['nomor_urut'] as int? ?? 0,
      masaJabatan: masaJabatanJson
          .map((e) => MasaJabatan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get isKetua =>
      jabatan.toLowerCase().contains('ketua') &&
      !jabatan.toLowerCase().contains('wakil');

  bool get isWakilKetua => jabatan.toLowerCase().contains('wakil ketua');
}
