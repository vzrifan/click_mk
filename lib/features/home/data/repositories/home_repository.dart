import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/home/data/models/jadwal_sidang.dart';

class HomeRepository {
  final DioClient _client;

  HomeRepository(this._client);

  Future<List<JadwalSidang>> getJadwalSidang(int month, int year) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.jadwalSidang,
      queryParameters: {
        'month': month.toString().padLeft(2, '0'),
        'year': year.toString(),
      },
    );

    final data = response.data ?? [];

    return data
        .map((e) => JadwalSidang.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
