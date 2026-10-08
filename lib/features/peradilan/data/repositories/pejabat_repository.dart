import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/peradilan/data/models/lhkpn.dart';
import 'package:click_mk/features/peradilan/data/models/pejabat.dart';

enum PejabatJabatan {
  sekjen('SEKJEN'),
  panitera('PANITERA');

  const PejabatJabatan(this.apiValue);
  final String apiValue;
}

enum PejabatStatus {
  aktif('AKTIF'),
  nonaktif('NONAKTIF');

  const PejabatStatus(this.apiValue);
  final String apiValue;
}

class PejabatRepository {
  final DioClient _client;
  PejabatRepository(this._client);

  /// GET /peradilan/pejabat?jabatan=...&status=...
  Future<List<Pejabat>> getList({
    required PejabatJabatan jabatan,
    required PejabatStatus status,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanPejabat,
      queryParameters: {'jabatan': jabatan.apiValue, 'status': status.apiValue},
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => Pejabat.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /peradilan/pejabat/:id
  Future<Pejabat> getDetail(int id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.peradilanPejabat}/$id',
    );
    final data = response.data ?? const {};
    // Response dibungkus `items` (objek, bukan array)
    final obj = (data['items'] as Map<String, dynamic>?) ?? data;
    return Pejabat.fromJson(obj);
  }

  /// GET /peradilan/lhkpn/:id
  Future<List<Lhkpn>> getLhkpn(int pejabatId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.peradilanLhkpn}/$pejabatId',
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items.map((e) => Lhkpn.fromJson(e as Map<String, dynamic>)).toList();
  }
}
