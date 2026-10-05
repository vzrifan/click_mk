import 'package:click_mk/features/putusan/data/models/putusan.dart';

class PutusanResponse {
  final List<Putusan> items;
  final int totalItems;
  final int itemCount;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  const PutusanResponse({
    required this.items,
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  bool get hasNextPage => currentPage < totalPages;

  factory PutusanResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    final meta = (json['meta'] as Map<String, dynamic>? ?? {});

    return PutusanResponse(
      items: itemsJson
          .map((e) => Putusan.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: meta['totalItems'] as int? ?? 0,
      itemCount: meta['itemCount'] as int? ?? 0,
      itemsPerPage: meta['itemsPerPage'] as int? ?? 10,
      totalPages: meta['totalPages'] as int? ?? 1,
      currentPage: meta['currentPage'] as int? ?? 1,
    );
  }
}
