import 'package:click_mk/features/peraturan/data/models/peraturan_statistik.dart';

class PeraturanStatistikResponse {
  final List<PeraturanStatistik> items;

  const PeraturanStatistikResponse({required this.items});

  factory PeraturanStatistikResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    return PeraturanStatistikResponse(
      items: itemsJson
          .map((e) => PeraturanStatistik.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
