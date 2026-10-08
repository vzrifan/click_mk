import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_jadwal_sidang.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_keputusan.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_pelaporan.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_peraturan.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_profil.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_risalah_sidang.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';

class MkmkRepository {
  final DioClient _client;
  MkmkRepository(this._client);

  Future<List<MkmkProfil>> getProfil() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanProfilMkmk,
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => MkmkProfil.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MkmkPeraturan>> getPeraturan() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanPeraturanMkmk,
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => MkmkPeraturan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MkmkKeputusan>> getKeputusan({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanKeputusanMkmk,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => MkmkKeputusan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MkmkPelaporan>> getPelaporan({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanPelaporanMkmk,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => MkmkPelaporan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MkmkJadwalSidang>> getJadwalSidang({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanJadwalSidangMkmk,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => MkmkJadwalSidang.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MkmkRisalahSidang>> getRisalahSidang({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanRisalahSidangMkmk,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => MkmkRisalahSidang.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PeradilanContent> getHistoriKelembagaan() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanHistoriKelembagaan,
    );
    return PeradilanContent.fromJson(response.data ?? const {});
  }
}
