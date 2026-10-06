import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_response.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_statistik_response.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_uud_response.dart';

class PeraturanRepository {
  final DioClient _client;
  PeraturanRepository(this._client);

  Future<PeraturanStatistikResponse> getGrafikPeraturan() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peraturanGrafik,
    );
    return PeraturanStatistikResponse.fromJson(response.data ?? const {});
  }

  Future<PeraturanResponse> getList(
    String endpoint, {
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return PeraturanResponse.fromJson(response.data ?? const {});
  }

  Future<PeraturanUudResponse> getUud({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peraturanUud,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return PeraturanUudResponse.fromJson(response.data ?? const {});
  }
}
