import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/berita/data/models/berita_detail.dart';
import 'package:click_mk/features/berita/data/models/berita_kategori.dart';
import 'package:click_mk/features/berita/data/models/berita_response.dart';
import 'package:flutter/material.dart';

class BeritaRepository {
  final DioClient _client;
  BeritaRepository(this._client);

  Future<BeritaResponse> getList({
    BeritaKategori kategori = BeritaKategori.sidang,
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
    DateTime? tanggalAwal,
    DateTime? tanggalAkhir,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.berita,
      queryParameters: {
        'category': kategori.apiValue,
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
        if (tanggalAwal != null) 'start_date': _formatDate(tanggalAwal),
        if (tanggalAkhir != null) 'end_date': _formatDate(tanggalAkhir),
      },
    );
    return BeritaResponse.fromJson(response.data ?? const {});
  }

  Future<BeritaDetail> getDetail(int id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.berita}/$id',
    );
    final data = response.data ?? const {};
    final obj = (data['items'] as Map<String, dynamic>?) ?? data;
    return BeritaDetail.fromJson(obj);
  }

  Future<void> hitView(String linkHit) async {
    if (linkHit.isEmpty) return;
    try {
      await _client.patch<dynamic>(linkHit);
    } catch (e) {
      debugPrint('hitView error: $e');
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }
}
