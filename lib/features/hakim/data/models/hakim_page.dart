import 'package:click_mk/features/hakim/data/models/hakim.dart';

class HakimPage {
  final List<Hakim> items;

  const HakimPage({required this.items});

  factory HakimPage.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    return HakimPage(
      items: itemsJson
          .map((e) => Hakim.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
