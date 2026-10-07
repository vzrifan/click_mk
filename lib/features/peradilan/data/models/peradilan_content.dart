class PeradilanContent {
  final String contentHtml;

  const PeradilanContent({required this.contentHtml});

  factory PeradilanContent.fromJson(Map<String, dynamic> json) {
    return PeradilanContent(contentHtml: json['content']?.toString() ?? '');
  }
}
