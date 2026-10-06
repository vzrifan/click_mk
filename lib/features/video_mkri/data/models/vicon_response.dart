import 'package:click_mk/features/video_mkri/data/models/vicon.dart';

class ViconResponse {
  final String imageUrl;
  final List<ViconInstansi> items;

  const ViconResponse({required this.imageUrl, required this.items});

  factory ViconResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    return ViconResponse(
      imageUrl: json['image_url']?.toString() ?? '',
      items: itemsJson
          .map((e) => ViconInstansi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
