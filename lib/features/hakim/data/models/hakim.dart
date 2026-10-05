import 'package:click_mk/features/hakim/data/models/masa_jabatan.dart';

class Hakim {
  final int nomorUrut;
  final int idHakim;
  final String namaLengkap;
  final String profilePictureUrl;
  final String jabatan;
  final List<MasaJabatan> masaJabatan;
  final int status;
  final String profilHtml;

  const Hakim({
    required this.nomorUrut,
    required this.idHakim,
    required this.namaLengkap,
    required this.profilePictureUrl,
    required this.jabatan,
    required this.masaJabatan,
    required this.status,
    required this.profilHtml,
  });

  bool get isKetua {
    final j = jabatan.toLowerCase();
    return j.contains('ketua') && !j.contains('wakil');
  }

  bool get isWakilKetua {
    final j = jabatan.toLowerCase();
    return j.contains('wakil');
  }

  bool get isAktif => status == 1;

  factory Hakim.fromJson(Map<String, dynamic> json) {
    final masaJabatanJson = (json['masa_jabatan'] as List<dynamic>? ?? []);
    return Hakim(
      nomorUrut: _parseInt(json['nomor_urut']),
      idHakim: _parseInt(json['profile_id']),
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      profilePictureUrl: json['profile_picture_url']?.toString() ?? '',
      jabatan: json['jabatan']?.toString() ?? '',
      masaJabatan: masaJabatanJson
          .map((e) => MasaJabatan.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: _parseInt(json['status']),
      profilHtml: json['profil']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
