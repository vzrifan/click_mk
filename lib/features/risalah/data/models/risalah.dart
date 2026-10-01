class Risalah {
  final int idSidang;
  final String noPerkara;
  final String pokokPerkara;
  final String acaraSidang;
  final String supportingFile;
  final String supportingFileAudio;
  final int downloadCount;
  final DateTime? date;
  final String sumberData;
  final String jenisPerkara;
  final String searchIndex;
  final String linkHit;

  const Risalah({
    required this.idSidang,
    required this.noPerkara,
    required this.pokokPerkara,
    required this.acaraSidang,
    required this.supportingFile,
    required this.supportingFileAudio,
    required this.downloadCount,
    required this.date,
    required this.sumberData,
    required this.jenisPerkara,
    required this.searchIndex,
    required this.linkHit,
  });

  bool get hasPdf => supportingFile.isNotEmpty;
  bool get hasAudio => supportingFileAudio.isNotEmpty;

  factory Risalah.fromJson(Map<String, dynamic> json) {
    return Risalah(
      idSidang: json['id_sidang'] as int? ?? 0,
      noPerkara: json['no_perkara'] as String? ?? '',
      pokokPerkara: (json['pokok_perkara'] as String? ?? '').trim(),
      acaraSidang: json['acara_sidang'] as String? ?? '',
      supportingFile: json['supporting_file'] as String? ?? '',
      supportingFileAudio: json['supporting_file_audio'] as String? ?? '',
      downloadCount:
          int.tryParse(json['download_count']?.toString() ?? '') ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      sumberData: json['sumber_data'] as String? ?? '',
      jenisPerkara: json['jenis_perkara'] as String? ?? '',
      searchIndex: json['search_index'] as String? ?? '',
      linkHit: json['link_hit'] as String? ?? '',
    );
  }
}
