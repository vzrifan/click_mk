import 'package:click_mk/features/pengumuman/data/models/pengumuman.dart';

class PengumumanResponse {
  final List<Pengumuman> items;
  final int totalPages;
  final int itemPerPage;
  final int totalItems;
  final int currentPage;

  const PengumumanResponse({
    required this.items,
    required this.totalPages,
    required this.itemPerPage,
    required this.totalItems,
    required this.currentPage,
  });

  factory PengumumanResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    final meta = (json['meta'] as Map<String, dynamic>? ?? {});

    return PengumumanResponse(
      items: itemsJson
          .map((e) => Pengumuman.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: meta['totalPages'] as int? ?? 1,
      itemPerPage: meta['itemPerPage'] as int? ?? 10,
      totalItems: meta['totalItems'] as int? ?? 0,
      currentPage: meta['currentPage'] as int? ?? 1,
    );
  }
}
