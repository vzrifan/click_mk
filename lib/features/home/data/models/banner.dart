class BannerItem {
  final int bannerId;
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final String? actionUrl;
  final DateTime? date;
  final String sumberData;

  const BannerItem({
    required this.bannerId,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.actionUrl,
    required this.date,
    required this.sumberData,
  });

  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;
  bool get hasTitle => title != null && title!.isNotEmpty;
  bool get hasSubtitle => subtitle != null && subtitle!.isNotEmpty;
  bool get isBerita => sumberData.toLowerCase() == 'berita';

  String? get titlePlain => title == null ? null : decodeHtml(title!);

  String? get subtitlePlain => subtitle == null ? null : decodeHtml(subtitle!);

  String? get actionUrlAbsolute {
    if (!hasAction) return null;
    final url = actionUrl!;
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://www.mkri.id$url';
  }

  static String decodeHtml(String input) {
    return input
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lsquo;', '\u2018')
        .replaceAll('&rsquo;', '\u2019')
        .replaceAll('&ldquo;', '\u201C')
        .replaceAll('&rdquo;', '\u201D')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      bannerId: json['banner_id'] as int? ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      actionUrl: json['action_url'] as String?,
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      sumberData: json['sumber_data'] as String? ?? 'banner',
    );
  }

  Map<String, dynamic> toJson() => {
    'banner_id': bannerId,
    'image_url': imageUrl,
    'title': title,
    'subtitle': subtitle,
    'action_url': actionUrl,
    'date': date?.toIso8601String(),
    'sumber_data': sumberData,
  };
}
