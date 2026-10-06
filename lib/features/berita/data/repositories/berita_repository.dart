import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/berita/data/models/berita_kategori.dart';
import 'package:click_mk/features/berita/data/models/berita_response.dart';

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

  String _formatDate(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }
}
