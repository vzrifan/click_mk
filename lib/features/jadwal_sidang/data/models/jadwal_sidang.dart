import 'package:click_mk/features/jadwal_sidang/data/models/tb_perkara.dart';

class JadwalSidangDetail {
  final int idSidang;
  final String acaraSidang;
  final DateTime? date;
  final String tempat;
  final int statusPercepat;
  final String statusPercepatMsg;
  final TbPerkara? tbPerkara;
  final String jenisSidang;
  final String trackingLink;

  const JadwalSidangDetail({
    required this.idSidang,
    required this.acaraSidang,
    required this.date,
    required this.tempat,
    required this.statusPercepat,
    required this.statusPercepatMsg,
    required this.tbPerkara,
    required this.jenisSidang,
    required this.trackingLink,
  });

  bool get isPercepat => statusPercepat == 1;
  bool get hasTracking => trackingLink.isNotEmpty;

  factory JadwalSidangDetail.fromJson(Map<String, dynamic> json) {
    final perkaraJson = json['tb_perkara'];
    final jenisJson = json['tb_jenissidang'];

    return JadwalSidangDetail(
      idSidang: _parseInt(json['id_sidang']),
      acaraSidang: json['acara_sidang']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      tempat: json['tempat']?.toString() ?? '',
      statusPercepat: _parseInt(json['status_percepat']),
      statusPercepatMsg: json['status_percepat_msg']?.toString() ?? '',
      tbPerkara: perkaraJson is Map<String, dynamic>
          ? TbPerkara.fromJson(perkaraJson)
          : null,
      jenisSidang: (jenisJson is Map<String, dynamic>)
          ? (jenisJson['sidang']?.toString() ?? '')
          : '',
      trackingLink: json['tracking_link']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
