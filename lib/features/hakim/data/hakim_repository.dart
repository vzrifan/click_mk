import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/data/models/jabatan_filter.dart';

class HakimRepository {
  final DioClient _client;
  HakimRepository(this._client);

  Future<List<Hakim>> getHakim({
    JabatanFilter jabatan = JabatanFilter.all,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.hakim,
      queryParameters: {
        if (jabatan.apiValue != null) 'jabatan': jabatan.apiValue,
      },
    );
    return _parseItems(response.data);
  }

  Future<List<Hakim>> getHakimPeriodeSebelumnya({
    JabatanFilter jabatan = JabatanFilter.all,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.hakim}/periode-sebelumnya',
      queryParameters: {
        if (jabatan.apiValue != null) 'jabatan': jabatan.apiValue,
      },
    );
    return _parseItems(response.data);
  }

  Future<Hakim> getHakimDetail(int id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.hakim}/profil/$id',
    );

    final data = response.data ?? const {};
    final items = (data['items'] as List<dynamic>? ?? []);

    if (items.isEmpty) {
      throw Exception('Hakim dengan id $id tidak ditemukan');
    }

    return Hakim.fromJson(items.first as Map<String, dynamic>);
  }

  List<Hakim> _parseItems(Map<String, dynamic>? data) {
    final items = (data?['items'] as List<dynamic>? ?? []);
    final list = items
        .map((e) => Hakim.fromJson(e as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => a.nomorUrut.compareTo(b.nomorUrut));
    return list;
  }
}
