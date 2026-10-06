class BeritaImage {
  final int imagesId;
  final String imageUrl;
  final String caption;

  const BeritaImage({
    required this.imagesId,
    required this.imageUrl,
    required this.caption,
  });

  factory BeritaImage.fromJson(Map<String, dynamic> json) {
    return BeritaImage(
      imagesId: _parseInt(json['images_id']),
      imageUrl: json['image_url']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

class BeritaDetail {
  final int beritaId;
  final DateTime? date;
  final String judul;
  final String subJudul;
  final String jam;
  final int viewCount;
  final String contentHtml;
  final String imageUrl;
  final List<BeritaImage> images;
  final String slug;
  final String noPerkara;
  final String linkPutusan;
  final String linkHit;

  const BeritaDetail({
    required this.beritaId,
    required this.date,
    required this.judul,
    required this.subJudul,
    required this.jam,
    required this.viewCount,
    required this.contentHtml,
    required this.imageUrl,
    required this.images,
    required this.slug,
    required this.noPerkara,
    required this.linkPutusan,
    required this.linkHit,
  });

  bool get hasPutusan => linkPutusan.isNotEmpty;

  factory BeritaDetail.fromJson(Map<String, dynamic> json) {
    final imagesJson = (json['images'] as List<dynamic>? ?? []);
    return BeritaDetail(
      beritaId: _parseInt(json['berita_id']),
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      judul: json['judul']?.toString() ?? '',
      subJudul: json['sub_judul']?.toString() ?? '',
      jam: json['jam']?.toString() ?? '',
      viewCount: _parseInt(json['view_count']),
      contentHtml: json['content']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      images: imagesJson
          .map((e) => BeritaImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      slug: json['slug']?.toString() ?? '',
      noPerkara: json['no_perkara']?.toString() ?? '',
      linkPutusan: json['link_putusan']?.toString() ?? '',
      linkHit: json['link_hit']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
