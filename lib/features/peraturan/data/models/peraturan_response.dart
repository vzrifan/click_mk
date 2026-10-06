import 'package:click_mk/features/peraturan/data/models/peraturan_item.dart';

class PeraturanResponse {
  final List<PeraturanItem> items;
  final int totalItems;
  final int itemPerPage;
  final int totalPages;
  final int currentPage;

  const PeraturanResponse({
    required this.items,
    required this.totalItems,
    required this.itemPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory PeraturanResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    final meta = (json['meta'] as Map<String, dynamic>? ?? {});

    return PeraturanResponse(
      items: itemsJson
          .map((e) => PeraturanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: meta['totalItems'] as int? ?? 0,
      itemPerPage: meta['itemPerPage'] as int? ?? 10,
      totalPages: meta['totalPages'] as int? ?? 1,
      currentPage: meta['currentPage'] as int? ?? 1,
    );
  }
}
