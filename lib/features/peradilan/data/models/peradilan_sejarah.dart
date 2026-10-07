class PeradilanSejarah {
  final String contentHtml;
  final DateTime? updatedAt;

  const PeradilanSejarah({required this.contentHtml, required this.updatedAt});

  factory PeradilanSejarah.fromJson(Map<String, dynamic> json) {
    return PeradilanSejarah(
      contentHtml: json['content_2']?.toString() ?? '',
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }
}
