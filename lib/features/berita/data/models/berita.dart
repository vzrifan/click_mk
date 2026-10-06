class Berita {
  final int beritaId;
  final String judul;
  final String subJudul;
  final String imageUrl;
  final DateTime? date;
  final String jam;
  final int viewCount;
  final bool isHighlight;
  final String slug;
  final String slugEng;
  final String tahun;
  final String linkHit;
  final String videoUrl;

  const Berita({
    required this.beritaId,
    required this.judul,
    required this.subJudul,
    required this.imageUrl,
    required this.date,
    required this.jam,
    required this.viewCount,
    required this.isHighlight,
    required this.slug,
    required this.slugEng,
    required this.tahun,
    required this.linkHit,
    required this.videoUrl,
  });

  String get webUrl => 'https://www.mkri.id/berita/$slug';

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      beritaId: _parseInt(json['berita_id']),
      judul: json['judul']?.toString() ?? '',
      subJudul: json['sub_judul']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      jam: json['jam']?.toString() ?? '',
      viewCount: _parseInt(json['view_count']),
      isHighlight: _parseInt(json['highlight']) == 1,
      slug: json['slug']?.toString() ?? '',
      slugEng: json['slug_eng']?.toString() ?? '',
      tahun: json['tahun']?.toString() ?? '',
      linkHit: json['link_hit']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
