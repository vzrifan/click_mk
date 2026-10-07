import 'package:click_mk/features/peraturan/data/models/peraturan_endpoint.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Home
  static const jadwalSidang = '/jadwal-sidang/calendar';
  static const jadwalSidangList = '/jadwal-sidang';
  static const banner = '/banner';
  static const putusan = '/putusan';
  static const risalah = '/risalah';
  static const ikhtisar = '/ikhtisar';
  static const anotasi = '/anotasi';
  static const pengumuman = '/pengumuman';
  static const pengumumanHighlight = '/pengumuman/highlight';
  static const videoMkri = '/video-mkri';
  static const vicon = '/vicon';
  static const berita = '/berita-mkri';

  // Peradilan
  static const peradilanSejarah = '/peradilan/sejarah-singkat';
  static const peradilanSejarahPerkembangan = '/peradilan/sejarah-perkembangan';
  static const peradilanVisiMisi = '/peradilan/visi-misi';
  static const peradilanKedudukanKewenangan = '/peradilan/kedudukan-kewenangan';
  static const peradilanJabatan = '/peradilan/jabatan/all';

  // Hakim
  static const hakim = '/hakim';

  // Peraturan
  static const peraturanGrafik = '/peraturan/grafik-peraturan';
  static const peraturanList = PeraturanEndpoint;
  static const peraturanUud = '/peraturan/uud';
}
