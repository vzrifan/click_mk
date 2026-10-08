import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_pelaporan_ringkas.dart';

class MkmkRisalahSidang {
  final int idSidang;
  final DateTime? tanggalSidangMulai;
  final String jamMulai;
  final String acaraSidang;
  final String tempat;
  final MkmkPelaporanRingkas? tbPelaporan;
  final String supportingFile;
  final String supportingAudioFile;

  const MkmkRisalahSidang({
    required this.idSidang,
    required this.tanggalSidangMulai,
    required this.jamMulai,
    required this.acaraSidang,
    required this.tempat,
    required this.tbPelaporan,
    required this.supportingFile,
    required this.supportingAudioFile,
  });

  bool get hasPdf {
    final url = supportingFile.trim();
    return url.isNotEmpty && !url.endsWith('/null');
  }

  bool get hasAudio {
    final url = supportingAudioFile.trim();
    return url.isNotEmpty && !url.endsWith('/null');
  }

  factory MkmkRisalahSidang.fromJson(Map<String, dynamic> json) {
    final pelaporanJson = json['tb_pelaporan'];
    return MkmkRisalahSidang(
      idSidang: _parseInt(json['id_sidang']),
      tanggalSidangMulai: DateTime.tryParse(
        json['tanggal_sidang_mulai']?.toString() ?? '',
      ),
      jamMulai: json['jam_mulai']?.toString() ?? '',
      acaraSidang: json['acara_sidang']?.toString().trim() ?? '',
      tempat: json['tempat']?.toString().trim() ?? '',
      tbPelaporan: pelaporanJson is Map<String, dynamic>
          ? MkmkPelaporanRingkas.fromJson(pelaporanJson)
          : null,
      supportingFile: json['supporting_file']?.toString() ?? '',
      supportingAudioFile: json['supporting_audio_file']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
