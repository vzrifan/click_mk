import 'package:click_mk/features/peraturan/data/models/peraturan_uud.dart';

class PeraturanUudResponse {
  final List<PeraturanUud> items;
  final int totalItems;
  final int itemCount;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  const PeraturanUudResponse({
    required this.items,
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory PeraturanUudResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    final meta = (json['meta'] as Map<String, dynamic>? ?? {});

    return PeraturanUudResponse(
      items: itemsJson
          .map((e) => PeraturanUud.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: meta['totalItems'] as int? ?? 0,
      itemCount: meta['itemCount'] as int? ?? 0,
      itemsPerPage: meta['itemsPerPage'] as int? ?? 10,
      totalPages: meta['totalPages'] as int? ?? 1,
      currentPage: meta['currentPage'] as int? ?? 1,
    );
  }
}
