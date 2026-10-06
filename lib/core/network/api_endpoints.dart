import 'package:click_mk/features/peraturan/data/models/peraturan_endpoint.dart';

class ApiEndpoints {
  ApiEndpoints._();

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

  static const peraturanGrafik = '/peraturan/grafik-peraturan';
  static const peraturanList = PeraturanEndpoint;
  static const peraturanUud = '/peraturan/uud';

  static const hakim = '/hakim';
}
