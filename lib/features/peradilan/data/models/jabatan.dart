import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────
// Jenis relasi antar-jabatan
// ─────────────────────────────────────────────────────────────────
enum JabatanRelation {
  /// Garis komando — atasan langsung ke bawahan struktural.
  komando,

  /// Garis koordinasi — hubungan setara / lintas fungsi.
  koordinasi,

  /// Garis pengawas — fungsi pengawasan (Inspektorat).
  pengawas,
}

// ─────────────────────────────────────────────────────────────────
// Key jabatan
// ─────────────────────────────────────────────────────────────────
enum JabatanKey {
  // ── Pimpinan & Hakim ────────────────────────────
  ketuaHakim('KETUA_MAHKAMAH_KONSTITUSI', 'Ketua Mahkamah Konstitusi'),
  wakilHakim(
    'WAKIL_KETUA_MAHKAMAH_KONSTITUSI',
    'Wakil Ketua Mahkamah Konstitusi',
  ),
  hakimKonstitusi('HAKIM_KONSTITUSI', 'Hakim Konstitusi'),
  dewanEtik('DEWAN_ETIK', 'Dewan Etik (MKMK)'),

  // ── Kesekjenan ──────────────────────────────────
  sekjen('SEKRETARIS_JENDERAL', 'Sekretaris Jenderal'),
  panitera('PANITERA', 'Panitera'),
  paniteraMuda1('PANITERA_MUDA_1', 'Panitera Muda I'),
  paniteraMuda2('PANITERA_MUDA_2', 'Panitera Muda II'),
  paniteraMuda3('PANITERA_MUDA_3', 'Panitera Muda III'),

  // ── Inspektorat ─────────────────────────────────
  inspektur('INSPEKTUR', 'Inspektur'),
  kepalaSubbagianTataUsahaInspektorat(
    'KEPALA_SUBBAGIAN_TATA_USAHA_INSPEKTORAT',
    'Subbagian Tata Usaha Inspektorat',
  ),

  // ── Biro Perencanaan dan Keuangan ───────────────
  kepalaBiroPerencanaanKeuangan(
    'KEPALA_BIRO_PERENCANAAN_DAN_KEUANGAN',
    'Kepala Biro Perencanaan dan Keuangan',
  ),
  kepalaBagianPerencanaanEvaluasi(
    'KEPALA_BAGIAN_PERENCANAAN_DAN_EVALUASI',
    'Bagian Perencanaan dan Evaluasi',
  ),
  kepalaSubbagianProgramAnggaran(
    'KEPALA_SUBBAGIAN_PROGRAM_DAN_ANGGARAN',
    'Subbagian Program dan Anggaran',
  ),
  kepalaSubbagianEvaluasiPelaporanKinerja(
    'KEPALA_SUBBAGIAN_EVALUASI_DAN_PELAPORAN_KINERJA',
    'Subbagian Evaluasi dan Pelaporan Kinerja',
  ),
  kepalaBagianKeuangan('KEPALA_BAGIAN_KEUANGAN', 'Bagian Keuangan'),
  kepalaSubbagianVerifikasi(
    'KEPALA_SUBBAGIAN_VERIFIKASI',
    'Subbagian Verifikasi',
  ),
  kepalaSubbagianPerbendaharaan(
    'KEPALA_SUBBAGIAN_PERBENDAHARAAN',
    'Subbagian Perbendaharaan',
  ),
  kepalaSubbagianAkuntansiLaporanKeuangan(
    'KEPALA_SUBBAGIAN_AKUNTANSI_DAN_LAPORAN_KEUANGAN',
    'Subbagian Akuntansi dan Laporan Keuangan',
  ),

  // ── Biro SDM & Organisasi ───────────────────────
  kepalaBiroSdmOrganisasi(
    'KEPALA_BIRO_SUMBER_DAYA_MANUSIA_DAN_ORGANISASI',
    'Kepala Biro Sumber Daya Manusia dan Organisasi',
  ),
  kepalaBagianSumberDayaManusia(
    'KEPALA_BAGIAN_SUMBER_DAYA_MANUSIA',
    'Bagian Sumber Daya Manusia',
  ),
  kepalaSubbagianAdministrasiHakimPegawai(
    'KEPALA_SUBBAGIAN_ADMINISTRASI_HAKIM_DAN_PEGAWAI',
    'Subbagian Administrasi Hakim dan Pegawai',
  ),
  kepalaSubbagianPengembanganSdm(
    'KEPALA_SUBBAGIAN_PENGEMBANGAN_SUMBER_DAYA_MANUSIA',
    'Subbagian Pengembangan Sumber Daya Manusia',
  ),
  kepalaSubbagianPembinaanPengembanganNonPns(
    'KEPALA_SUBBAGIAN_PEMBINAAN_DAN_PENGEMBANGAN_PEGAWAI_NON_PNS',
    'Subbagian Pembinaan dan Pengembangan Pegawai Non PNS',
  ),
  kepalaBagianOrganisasiTataLaksanaReformasi(
    'KEPALA_BAGIAN_ORGANISASI_TATA_LAKSANA_DAN_FASILITASI_REFORMASI_BIROKRASI',
    'Bagian Organisasi, Tata Laksana, dan Fasilitasi Reformasi Birokrasi',
  ),
  kepalaSubbagianOrganisasiTataLaksana(
    'KEPALA_SUBBAGIAN_ORGANISASI_DAN_TATA_LAKSANA',
    'Subbagian Organisasi dan Tata Laksana',
  ),
  kepalaSubbagianFasilitasiReformasi(
    'KEPALA_SUBBAGIAN_FASILITASI_REFORMASI_BIROKRASI',
    'Subbagian Fasilitasi Reformasi Birokrasi',
  ),

  // ── Biro Hukum & Administrasi Kepaniteraan ──────
  kepalaBiroHukumAdministrasiKepaniteraan(
    'KEPALA_BIRO_HUKUM_DAN_ADMINISTRASI_KEPANITERAAN',
    'Kepala Biro Hukum dan Administrasi Kepaniteraan',
  ),
  kepalaBagianFasilitasPelayananTeknisPersidangan(
    'KEPALA_BAGIAN_FASILITAS_DAN_PELAYANAN_TEKNIS_PERSIDANGAN',
    'Bagian Fasilitas dan Pelayanan Teknis Persidangan',
  ),
  kepalaSubbagianFasilitasPersidangan(
    'KEPALA_SUBBAGIAN_FASILITAS_PERSIDANGAN',
    'Subbagian Fasilitas Persidangan',
  ),
  kepalaSubbagianPelayananTeknisPersidangan(
    'KEPALA_SUBBAGIAN_PELAYANAN_TEKNIS_PERSIDANGAN',
    'Subbagian Pelayanan Teknis Persidangan',
  ),

  // ── Biro Humas & Protokol ───────────────────────
  kepalaBiroHumasProtokol(
    'KEPALA_BIRO_HUBUNGAN_MASYARAKAT_DAN_PROTOKOL',
    'Kepala Biro Hubungan Masyarakat dan Protokol',
  ),
  kepalaBagianHumasKerjaSamaDalamNegeri(
    'KEPALA_BAGIAN_HUBUNGAN_MASYARAKAT_DAN_KERJASAMA_DALAM_NEGERI',
    'Bagian Hubungan Masyarakat dan Kerja Sama Dalam Negeri',
  ),
  kepalaSubbagianHumas(
    'KEPALA_SUBBAGIAN_HUBUNGAN_MASYARAKAT',
    'Subbagian Hubungan Masyarakat',
  ),
  kepalaSubbagianKerjaSamaDalamNegeri(
    'KEPALA_SUBBAGIAN_KERJASAMA_DALAM_NEGERI_DAN_HUBUNGAN_ANTAR_LEMBAGA',
    'Subbagian Kerja Sama Dalam Negeri dan Hubungan Antar Lembaga',
  ),
  kepalaBagianSekretariatTetapAaccKerjaSamaLuarNegeri(
    'KEPALA_BAGIAN_SEKRETARIAT_TETAP_AACC_DAN_KERJA_SAMA_LUAR_NEGERI',
    'Bagian Sekretariat Tetap AACC dan Kerja Sama Luar Negeri',
  ),
  kepalaSubbagianSekretariatTetapAacc(
    'KEPALA_SUBBAGIAN_SEKRETARIAT_TETAP_AACC',
    'Subbagian Sekretariat Tetap AACC',
  ),
  kepalaSubbagianKerjaSamaLuarNegeri(
    'KEPALA_SUBBAGIAN_KERJASAMA_LUAR_NEGERI',
    'Subbagian Kerja Sama Luar Negeri',
  ),
  kepalaBagianTataUsahaPimpinanProtokol(
    'KEPALA_BAGIAN_TATA_USAHA_PIMPINAN_DAN_PROTOKOL',
    'Bagian Tata Usaha Pimpinan dan Protokol',
  ),
  kepalaSubbagianTataUsahaPimpinan(
    'KEPALA_SUBBAGIAN_TATA_USAHA_PIMPINAN',
    'Subbagian Tata Usaha Pimpinan',
  ),
  kepalaSubbagianProtokol('KEPALA_SUBBAGIAN_PROTOKOL', 'Subbagian Protokol'),

  // ── Biro Umum ───────────────────────────────────
  kepalaBiroUmum('KEPALA_BIRO_UMUM', 'Kepala Biro Umum'),
  kepalaBagianRumahTanggaArsipEkspedisi(
    'KEPALA_BAGIAN_RUMAH_TANGGA_ARSIP_DAN_EKSPEDISI',
    'Bagian Rumah Tangga, Arsip dan Ekspedisi',
  ),
  kepalaSubbagianRumahTangga(
    'KEPALA_SUBBAGIAN_RUMAH_TANGGA',
    'Subbagian Rumah Tangga',
  ),
  kepalaSubbagianArsipEkspedisi(
    'KEPALA_SUBBAGIAN_ARSIP_DAN_EKSPEDISI',
    'Subbagian Arsip dan Ekspedisi',
  ),
  kepalaBagianPengadaanPenatausahaanBmn(
    'KEPALA_BAGIAN_PENGADAAN_DAN_PENATAUSAHAAN_BARANG_MILIK_NEGARA',
    'Bagian Pengadaan dan Penatausahaan Barang Milik Negara',
  ),
  kepalaSubbagianLayananPengadaan(
    'KEPALA_SUBBAGIAN_LAYANAN_PENGADAAN',
    'Subbagian Layanan Pengadaan',
  ),
  kepalaSubbagianPenatausahaan(
    'KEPALA_SUBBAGIAN_PENATAUSAHAAN',
    'Subbagian Penatausahaan',
  ),
  kepalaSubbagianAkuntansiLaporanBmn(
    'KEPALA_SUBBAGIAN_AKUNTANSI_DAN_LAPORAN_BARANG_MILIK_NEGARA',
    'Subbagian Akuntansi dan Laporan BMN',
  ),

  // ── Pusat Penelitian & Pengkajian Perkara ───────
  kepalaPusatPenelitian(
    'KEPALA_PUSAT_PENELITIAN_DAN_PENGKAJIAN_PERKARA_DAN_PENGELOLAAN_PERPUSTAKAAN',
    'Kepala Pusat Penelitian dan Pengkajian Perkara',
  ),
  kepalaBidangPenelitianPengkajian(
    'KEPALA_BIDANG_PENELITIAN_DAN_PENGKAJIAN_PERKARA',
    'Bidang Penelitian dan Pengkajian Perkara',
  ),
  kepalaBidangPerpustakaanSejarah(
    'KEPALA_BIDANG_PERPUSTAKAAN_DAN_SEJARAH_KONSTITUSI',
    'Bidang Perpustakaan dan Sejarah Konstitusi',
  ),
  kepalaSubbagianTataUsahaPusatPenelitian(
    'KEPALA_SUBBAGIAN_TATA_USAHA_PUSAT_PENELITIAN_DAN_PENGKAJIAN_PERKARA_DAN_PENGELOLAAN_PERPUSTAKAAN',
    'Subbagian Tata Usaha',
  ),

  // ── Pusat Teknologi Informasi & Komunikasi ──────
  kepalaPusatTik(
    'KEPALA_PUSAT_TEKNOLOGI_INFORMASI_DAN_KOMUNIKASI',
    'Kepala Pusat Teknologi Informasi dan Komunikasi',
  ),
  kepalaBidangSistemInformasi(
    'KEPALA_BIDANG_SISTEM_INFORMASI_DAN_LAYANAN_DATA',
    'Bidang Sistem Informasi dan Layanan Data',
  ),
  kepalaBidangInfrastrukturJaringan(
    'KEPALA_BIDANG_INFRASTRUKTUR_JARINGAN_DAN_KOMUNIKASI',
    'Bidang Infrastruktur Jaringan dan Komunikasi',
  ),
  kepalaSubbagianTataUsahaPusatTik(
    'KEPALA_SUBBAGIAN_TATA_USAHA_PUSAT_TEKNOLOGI_INFORMASI_DAN_KOMUNIKASI',
    'Subbagian Tata Usaha',
  ),

  // ── Pusat Pendidikan Pancasila & Konstitusi ─────
  kepalaPusatPusdik(
    'KEPALA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
    'Kepala Pusat Pendidikan Pancasila dan Konstitusi',
  ),
  kepalaBidangProgramPenyelenggaraan(
    'KEPALA_BIDANG_PROGRAM_DAN_PENYELENGGARAAN_PUSDIK',
    'Bidang Program dan Penyelenggaraan',
  ),
  kepalaBagianUmumPadaPusat('KEPALA_BAGIAN_UMUM_PADA_PUSAT', 'Bagian Umum'),
  kepalaSubbagianTataUsahaPusdik(
    'KEPALA_SUBBAGIAN_TATA_USAHA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
    'Subbagian Tata Usaha',
  ),
  kepalaSubbagianSaranaPrasaranaPusdik(
    'KEPALA_SUBBAGIAN_SARANA_DAN_PRASARANA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
    'Subbagian Sarana dan Prasarana',
  ),
  kepalaSubbidangProgramEvaluasi(
    'KEPALA_SUBBIDANG_PROGRAM_DAN_EVALUASI',
    'Subbidang Program dan Evaluasi',
  ),
  kepalaSubbidangPenyelenggaraan(
    'KEPALA_SUBBIDANG_PENYELENGGARAAN',
    'Subbidang Penyelenggaraan',
  );

  const JabatanKey(this.key, this.label);

  final String key;
  final String label;

  static JabatanKey? fromKey(String? key) {
    if (key == null) return null;
    for (final item in JabatanKey.values) {
      if (item.key == key) return item;
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────
// Model Jabatan (dari API)
// ─────────────────────────────────────────────────────────────────
class Jabatan {
  final String jabatan;
  final int pejabatId;
  final int jabatanId;
  final int esselonKd;

  const Jabatan({
    required this.jabatan,
    required this.pejabatId,
    required this.jabatanId,
    required this.esselonKd,
  });

  bool get isHakim => esselonKd == 0;
  bool get isPejabat => esselonKd == 1;
  bool get isPegawai => esselonKd == 2;

  JabatanKey? get key {
    final normalized = jabatan.toUpperCase().replaceAll(' ', '_');
    return JabatanKey.fromKey(normalized);
  }

  factory Jabatan.fromJson(Map<String, dynamic> json) {
    return Jabatan(
      jabatan: json['jabatan']?.toString() ?? '',
      pejabatId: _parseInt(json['pejabat_id']),
      jabatanId: _parseInt(json['jabatan_id']),
      esselonKd: _parseInt(json['esselon_esselonkd']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

// ─────────────────────────────────────────────────────────────────
// Tree node
// ─────────────────────────────────────────────────────────────────
class JabatanNode {
  final String key;
  final List<String> aliases;
  final List<JabatanNode> children;

  /// Jenis relasi dari parent ke node ini.
  /// Root tidak punya relasi (default komando).
  final JabatanRelation relation;

  const JabatanNode({
    required this.key,
    this.aliases = const [],
    this.children = const [],
    this.relation = JabatanRelation.komando,
  });

  bool get hasChildren => children.isNotEmpty;

  bool matches(String normalizedKey) {
    if (key == normalizedKey) return true;
    return aliases.any((a) => a == normalizedKey);
  }
}

// ─────────────────────────────────────────────────────────────────
// Edge tambahan (di luar tree) — koordinasi & pengawas
// ─────────────────────────────────────────────────────────────────
class JabatanExtraEdge {
  final String from;
  final String to;
  final JabatanRelation relation;

  const JabatanExtraEdge({
    required this.from,
    required this.to,
    required this.relation,
  });
}

// ─────────────────────────────────────────────────────────────────
// Struktur Organisasi MKRI
// ─────────────────────────────────────────────────────────────────
class JabatanTree {
  JabatanTree._();

  static const List<JabatanNode> root = [
    JabatanNode(
      key: 'KETUA_MAHKAMAH_KONSTITUSI',
      aliases: ['KETUA_HAKIM', 'KETUA'],
      children: [
        // ── Pimpinan & Hakim ────────────────────
        JabatanNode(
          key: 'WAKIL_KETUA_MAHKAMAH_KONSTITUSI',
          aliases: ['WAKIL_HAKIM', 'WAKIL_KETUA'],
          relation: JabatanRelation.komando,
        ),
        JabatanNode(
          key: 'HAKIM_KONSTITUSI',
          aliases: ['HAKIM'],
          relation: JabatanRelation.komando,
        ),
        JabatanNode(
          key: 'DEWAN_ETIK',
          aliases: ['MKMK'],
          relation: JabatanRelation.koordinasi, // MKMK bukan bawahan struktural
        ),

        // ── Kesekjenan ──────────────────────────
        JabatanNode(
          key: 'SEKRETARIS_JENDERAL',
          aliases: ['SEKJEN', 'SEKRETARIS_JENDRAL'],
          relation: JabatanRelation.komando,
          children: [
            JabatanNode(
              key: 'INSPEKTUR',
              aliases: ['INSPEKTUR_INSPEKTORAT', 'INSPEKTORAT'],
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_SUBBAGIAN_TATA_USAHA_INSPEKTORAT',
                  aliases: ['SUBBAGIAN_TATA_USAHA_INSPEKTORAT'],
                  relation: JabatanRelation.komando,
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_BIRO_PERENCANAAN_DAN_KEUANGAN',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BAGIAN_PERENCANAAN_DAN_EVALUASI',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PROGRAM_DAN_ANGGARAN',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_EVALUASI_DAN_PELAPORAN_KINERJA',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
                JabatanNode(
                  key: 'KEPALA_BAGIAN_KEUANGAN',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_VERIFIKASI',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PERBENDAHARAAN',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_AKUNTANSI_DAN_LAPORAN_KEUANGAN',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_BIRO_SUMBER_DAYA_MANUSIA_DAN_ORGANISASI',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BAGIAN_SUMBER_DAYA_MANUSIA',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_ADMINISTRASI_HAKIM_DAN_PEGAWAI',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PENGEMBANGAN_SUMBER_DAYA_MANUSIA',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PEMBINAAN_DAN_PENGEMBANGAN_PEGAWAI_NON_PNS',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
                JabatanNode(
                  key: 'KEPALA_BAGIAN_ORGANISASI_TATA_LAKSANA_DAN_FASILITASI_REFORMASI_BIROKRASI',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_ORGANISASI_DAN_TATA_LAKSANA',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_FASILITASI_REFORMASI_BIROKRASI',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_BIRO_HUKUM_DAN_ADMINISTRASI_KEPANITERAAN',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BAGIAN_FASILITAS_DAN_PELAYANAN_TEKNIS_PERSIDANGAN',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_FASILITAS_PERSIDANGAN',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PELAYANAN_TEKNIS_PERSIDANGAN',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_BIRO_HUBUNGAN_MASYARAKAT_DAN_PROTOKOL',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BAGIAN_HUBUNGAN_MASYARAKAT_DAN_KERJASAMA_DALAM_NEGERI',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_HUBUNGAN_MASYARAKAT',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_KERJASAMA_DALAM_NEGERI_DAN_HUBUNGAN_ANTAR_LEMBAGA',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
                JabatanNode(
                  key: 'KEPALA_BAGIAN_SEKRETARIAT_TETAP_AACC_DAN_KERJA_SAMA_LUAR_NEGERI',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_SEKRETARIAT_TETAP_AACC',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_KERJASAMA_LUAR_NEGERI',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
                JabatanNode(
                  key: 'KEPALA_BAGIAN_TATA_USAHA_PIMPINAN_DAN_PROTOKOL',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_TATA_USAHA_PIMPINAN',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PROTOKOL',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_BIRO_UMUM',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BAGIAN_RUMAH_TANGGA_ARSIP_DAN_EKSPEDISI',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_RUMAH_TANGGA',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_ARSIP_DAN_EKSPEDISI',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
                JabatanNode(
                  key: 'KEPALA_BAGIAN_PENGADAAN_DAN_PENATAUSAHAAN_BARANG_MILIK_NEGARA',
                  relation: JabatanRelation.komando,
                  children: [
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_LAYANAN_PENGADAAN',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_PENATAUSAHAAN',
                      relation: JabatanRelation.komando,
                    ),
                    JabatanNode(
                      key: 'KEPALA_SUBBAGIAN_AKUNTANSI_DAN_LAPORAN_BARANG_MILIK_NEGARA',
                      relation: JabatanRelation.komando,
                    ),
                  ],
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_PUSAT_PENELITIAN_DAN_PENGKAJIAN_PERKARA_DAN_PENGELOLAAN_PERPUSTAKAAN',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BIDANG_PENELITIAN_DAN_PENGKAJIAN_PERKARA',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_BIDANG_PERPUSTAKAAN_DAN_SEJARAH_KONSTITUSI',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_SUBBAGIAN_TATA_USAHA_PUSAT_PENELITIAN_DAN_PENGKAJIAN_PERKARA_DAN_PENGELOLAAN_PERPUSTAKAAN',
                  relation: JabatanRelation.komando,
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_PUSAT_TEKNOLOGI_INFORMASI_DAN_KOMUNIKASI',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BIDANG_SISTEM_INFORMASI_DAN_LAYANAN_DATA',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_BIDANG_INFRASTRUKTUR_JARINGAN_DAN_KOMUNIKASI',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_SUBBAGIAN_TATA_USAHA_PUSAT_TEKNOLOGI_INFORMASI_DAN_KOMUNIKASI',
                  relation: JabatanRelation.komando,
                ),
              ],
            ),
            JabatanNode(
              key: 'KEPALA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
              relation: JabatanRelation.komando,
              children: [
                JabatanNode(
                  key: 'KEPALA_BIDANG_PROGRAM_DAN_PENYELENGGARAAN_PUSDIK',
                  aliases: [
                    'KEPALA_BIDANG_PROGRAM_DAN_PENYELENGGARAAN_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
                  ],
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_BAGIAN_UMUM_PADA_PUSAT',
                  aliases: [
                    'KEPALA_BAGIAN_UMUM_PADA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
                  ],
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_SUBBAGIAN_TATA_USAHA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_SUBBAGIAN_SARANA_DAN_PRASARANA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_SUBBIDANG_PROGRAM_DAN_EVALUASI',
                  relation: JabatanRelation.komando,
                ),
                JabatanNode(
                  key: 'KEPALA_SUBBIDANG_PENYELENGGARAAN',
                  relation: JabatanRelation.komando,
                ),
              ],
            ),
          ],
        ),

        // ── Kepaniteraan ────────────────────────
        JabatanNode(
          key: 'PANITERA',
          relation: JabatanRelation
              .koordinasi, // Panitera bukan bawahan struktural Sekjen
          children: [
            JabatanNode(
              key: 'PANITERA_MUDA_1',
              aliases: ['PANITERA_MUDA_I'],
              relation: JabatanRelation.komando,
            ),
            JabatanNode(
              key: 'PANITERA_MUDA_2',
              aliases: ['PANITERA_MUDA_II'],
              relation: JabatanRelation.komando,
            ),
            JabatanNode(
              key: 'PANITERA_MUDA_3',
              aliases: ['PANITERA_MUDA_III'],
              relation: JabatanRelation.komando,
            ),
          ],
        ),
      ],
    ),
  ];

  /// Edge tambahan yang bukan bagian dari tree struktural —
  /// digambar sebagai garis koordinasi / pengawas.
  static const List<JabatanExtraEdge> extraEdges = [
    // ── Koordinasi antar-lembaga / fungsi ──────
    JabatanExtraEdge(
      from: 'DEWAN_ETIK',
      to: 'HAKIM_KONSTITUSI',
      relation: JabatanRelation.koordinasi,
    ),
    JabatanExtraEdge(
      from: 'SEKRETARIS_JENDERAL',
      to: 'PANITERA',
      relation: JabatanRelation.koordinasi,
    ),
    JabatanExtraEdge(
      from: 'PANITERA_MUDA_1',
      to: 'PANITERA_MUDA_2',
      relation: JabatanRelation.koordinasi,
    ),
    JabatanExtraEdge(
      from: 'PANITERA_MUDA_2',
      to: 'PANITERA_MUDA_3',
      relation: JabatanRelation.koordinasi,
    ),
    JabatanExtraEdge(
      from: 'DEWAN_ETIK',
      to: 'INSPEKTUR',
      relation: JabatanRelation.koordinasi,
    ),

    // ── Pengawas (Inspektorat ke unit kerja) ───
    JabatanExtraEdge(
      from: 'INSPEKTUR',
      to: 'KEPALA_BIRO_PERENCANAAN_DAN_KEUANGAN',
      relation: JabatanRelation.pengawas,
    ),
    JabatanExtraEdge(
      from: 'INSPEKTUR',
      to: 'KEPALA_BIRO_SUMBER_DAYA_MANUSIA_DAN_ORGANISASI',
      relation: JabatanRelation.pengawas,
    ),
    JabatanExtraEdge(
      from: 'INSPEKTUR',
      to: 'KEPALA_BIRO_HUBUNGAN_MASYARAKAT_DAN_PROTOKOL',
      relation: JabatanRelation.pengawas,
    ),
    JabatanExtraEdge(
      from: 'INSPEKTUR',
      to: 'KEPALA_PUSAT_PENELITIAN_DAN_PENGKAJIAN_PERKARA_DAN_PENGELOLAAN_PERPUSTAKAAN',
      relation: JabatanRelation.pengawas,
    ),
    JabatanExtraEdge(
      from: 'INSPEKTUR',
      to: 'KEPALA_PUSAT_PENDIDIKAN_PANCASILA_DAN_KONSTITUSI',
      relation: JabatanRelation.pengawas,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────
// Helper: warna & style per relasi
// ─────────────────────────────────────────────────────────────────
extension JabatanRelationStyle on JabatanRelation {
  Color get color {
    switch (this) {
      case JabatanRelation.komando:
        return const Color(0xFF222222); // hitam
      case JabatanRelation.koordinasi:
        return const Color(0xFF1565C0); // biru
      case JabatanRelation.pengawas:
        return const Color(0xFFEF6C00); // orange
    }
  }

  /// true = garis solid, false = putus-putus.
  bool get isSolid => this == JabatanRelation.komando;

  String get label {
    switch (this) {
      case JabatanRelation.komando:
        return 'Garis Komando';
      case JabatanRelation.koordinasi:
        return 'Garis Koordinasi';
      case JabatanRelation.pengawas:
        return 'Garis Pengawas';
    }
  }
}
