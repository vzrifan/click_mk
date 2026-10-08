import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_pelaporan_file.dart';

class MkmkPelaporan {
  final int idPermohonan;
  final DateTime? tanggalPelaporan;
  final String nomorRegistrasi;
  final String judulPelaporan;
  final List<String> pelapor;
  final List<String> kuasa;
  final List<MkmkPelaporanFile> supportingFiles;

  const MkmkPelaporan({
    required this.idPermohonan,
    required this.tanggalPelaporan,
    required this.nomorRegistrasi,
    required this.judulPelaporan,
    required this.pelapor,
    required this.kuasa,
    required this.supportingFiles,
  });

  factory MkmkPelaporan.fromJson(Map<String, dynamic> json) {
    final filesJson = (json['supporting_file_url'] as List<dynamic>? ?? []);
    return MkmkPelaporan(
      idPermohonan: _parseInt(json['id_permohonan']),
      tanggalPelaporan: DateTime.tryParse(
        json['tanggal_pelaporan']?.toString() ?? '',
      ),
      nomorRegistrasi: json['nomor_registrasi']?.toString().trim() ?? '',
      judulPelaporan: json['judul_pelaporan']?.toString().trim() ?? '',
      pelapor: _parseNamaList(json['pelapor']),
      kuasa: _parseNamaList(json['kuasa']),
      supportingFiles: filesJson
          .map((e) => MkmkPelaporanFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parse array of object `[{id, nama, hapus}]` → `["nama1", "nama2"]`.
  /// Juga handle kalau API kirim array of string.
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

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
