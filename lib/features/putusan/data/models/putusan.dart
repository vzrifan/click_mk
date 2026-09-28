class Putusan {
  final String jenisnya;
  final int putusanCode;
  final String noPerkara;
  final String pokokPerkara;
  final String pemohon;
  final String amarPutusan;
  final int downloadCount;
  final String supportingFile;
  final DateTime? date;
  final String keywords;
  final String status;
  final String searchIndex;
  final String linkHit;

  const Putusan({
    required this.jenisnya,
    required this.putusanCode,
    required this.noPerkara,
    required this.pokokPerkara,
    required this.pemohon,
    required this.amarPutusan,
    required this.downloadCount,
    required this.supportingFile,
    required this.date,
    required this.keywords,
    required this.status,
    required this.searchIndex,
    required this.linkHit,
  });

  factory Putusan.fromJson(Map<String, dynamic> json) {
    return Putusan(
      jenisnya: json['jenisnya'] as String? ?? '',
      putusanCode: json['putusancode'] as int? ?? 0,
      noPerkara: json['no_perkara'] as String? ?? '',
      pokokPerkara: json['pokok_perkara'] as String? ?? '',
      pemohon: json['pemohon'] as String? ?? '',
      amarPutusan: json['amar_putusan'] as String? ?? '',
      downloadCount:
          int.tryParse(json['download_count']?.toString() ?? '') ?? 0,
      supportingFile: json['supporting_file'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      keywords: json['keywords'] as String? ?? '',
      status: json['status'] as String? ?? '',
      searchIndex: json['search_index'] as String? ?? '',
      linkHit: json['link_hit'] as String? ?? '',
    );
  }
}
