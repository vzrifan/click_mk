class IkhtisarPerkara {
  final String noPerkara;
  final String pokokPerkara;
  final String pemohon;
  final String jenisPerkara;

  const IkhtisarPerkara({
    required this.noPerkara,
    required this.pokokPerkara,
    required this.pemohon,
    required this.jenisPerkara,
  });

  factory IkhtisarPerkara.fromJson(Map<String, dynamic> json) {
    return IkhtisarPerkara(
      noPerkara: json['no_perkara']?.toString() ?? '',
      pokokPerkara: json['pokok_perkara']?.toString() ?? '',
      pemohon: json['pemohon']?.toString() ?? '',
      jenisPerkara: json['jenis_perkara']?.toString() ?? '',
    );
  }
}

class IkhtisarPermohonan {
  final String permohonan;

  const IkhtisarPermohonan({required this.permohonan});

  factory IkhtisarPermohonan.fromJson(Map<String, dynamic> json) {
    return IkhtisarPermohonan(permohonan: json['permohonan']?.toString() ?? '');
  }
}

class Ikhtisar {
  final int sinopsiscode;
  final DateTime? date;
  final String supportingFile;
  final int downloadCount;
  final String linkHit;
  final IkhtisarPerkara? tbPerkara;
  final List<IkhtisarPermohonan> tbPermohonan;

  const Ikhtisar({
    required this.sinopsiscode,
    required this.date,
    required this.supportingFile,
    required this.downloadCount,
    required this.linkHit,
    required this.tbPerkara,
    required this.tbPermohonan,
  });

  bool get hasPdf => supportingFile.isNotEmpty;

  String get pokokPerkara {
    if (tbPermohonan.isNotEmpty) {
      return tbPermohonan.first.permohonan;
    }
    return tbPerkara?.pokokPerkara ?? '';
  }

  factory Ikhtisar.fromJson(Map<String, dynamic> json) {
    final perkaraJson = json['tb_perkara'];
    final permohonanJson = json['tb_permohonan'];

    return Ikhtisar(
      sinopsiscode: _parseInt(json['sinopsiscode']),
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      supportingFile: json['supporting_file']?.toString() ?? '',
      downloadCount: _parseInt(json['download_count']),
      linkHit: json['link_hit']?.toString() ?? '',
      tbPerkara: perkaraJson is Map<String, dynamic>
          ? IkhtisarPerkara.fromJson(perkaraJson)
          : null,
      tbPermohonan: permohonanJson is List
          ? permohonanJson
                .map(
                  (e) => IkhtisarPermohonan.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : const [],
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
