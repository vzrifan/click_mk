class TbPemohon {
  final String nama;
  const TbPemohon({required this.nama});

  factory TbPemohon.fromJson(Map<String, dynamic> json) {
    return TbPemohon(nama: json['nama']?.toString() ?? '');
  }
}

class TbKuasa {
  final String nama;
  const TbKuasa({required this.nama});

  factory TbKuasa.fromJson(Map<String, dynamic> json) {
    return TbKuasa(nama: json['nama']?.toString() ?? '');
  }
}

class TbPermohonan {
  final String permohonan;
  final String pemohon; // ⬅ langsung dari JSON
  final List<TbPemohon> pemohonList; // dari tb_pemohon
  final List<TbKuasa> kuasa;

  const TbPermohonan({
    required this.permohonan,
    required this.pemohon,
    required this.pemohonList,
    required this.kuasa,
  });

  factory TbPermohonan.fromJson(Map<String, dynamic> json) {
    final pemohonJson = (json['tb_pemohon'] as List<dynamic>? ?? []);
    final kuasaJson = (json['tb_kuasa'] as List<dynamic>? ?? []);

    return TbPermohonan(
      permohonan: json['permohonan']?.toString() ?? '',
      pemohon: json['pemohon']?.toString() ?? '',
      pemohonList: pemohonJson
          .map((e) => TbPemohon.fromJson(e as Map<String, dynamic>))
          .toList(),
      kuasa: kuasaJson
          .map((e) => TbKuasa.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TbPerkara {
  final String nomorPerkara;
  final String pokokPerkara;
  final String pemohon; // ⬅ langsung dari JSON
  final String jenisPerkara;
  final int panel;
  final List<TbPermohonan> permohonan;

  const TbPerkara({
    required this.nomorPerkara,
    required this.pokokPerkara,
    required this.pemohon,
    required this.jenisPerkara,
    required this.panel,
    required this.permohonan,
  });

  /// Nama pemohon utama — prioritas: field `pemohon` langsung.
  String get pemohonUtama {
    if (pemohon.isNotEmpty) return pemohon;
    if (permohonan.isNotEmpty) {
      if (permohonan.first.pemohon.isNotEmpty) {
        return permohonan.first.pemohon;
      }
      if (permohonan.first.pemohonList.isNotEmpty) {
        return permohonan.first.pemohonList.first.nama;
      }
    }
    return '-';
  }

  factory TbPerkara.fromJson(Map<String, dynamic> json) {
    final permohonanJson = (json['tb_permohonan'] as List<dynamic>? ?? []);
    return TbPerkara(
      nomorPerkara: json['no_perkara']?.toString() ?? '',
      pokokPerkara: json['pokok_perkara']?.toString() ?? '',
      pemohon: json['pemohon']?.toString() ?? '',
      jenisPerkara: json['jenis_perkara']?.toString() ?? '',
      panel: _parseInt(json['panel']),
      permohonan: permohonanJson
          .map((e) => TbPermohonan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
