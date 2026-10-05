import 'package:click_mk/features/anotasi/data/models/anotasi.dart';

class AnotasiPage {
  final List<Anotasi> items;
  final int totalPages;
  final int itemPerPage;
  final int totalItems;
  final int currentPage;

  const AnotasiPage({
    required this.items,
    required this.totalPages,
    required this.itemPerPage,
    required this.totalItems,
    required this.currentPage,
  });

  factory AnotasiPage.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    final meta = (json['meta'] as Map<String, dynamic>? ?? {});

    return AnotasiPage(
      items: itemsJson
          .map((e) => Anotasi.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: meta['totalPages'] as int? ?? 1,
      itemPerPage: meta['itemPerPage'] as int? ?? 10,
      totalItems: meta['totalItems'] as int? ?? 0,
      currentPage: meta['currentPage'] as int? ?? 1,
    );
  }
}
