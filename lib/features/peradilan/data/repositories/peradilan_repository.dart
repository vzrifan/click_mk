import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/peradilan/data/models/jabatan.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_sejarah.dart';

class PeradilanRepository {
  final DioClient _client;
  PeradilanRepository(this._client);

  Future<PeradilanSejarah> getSejarah() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanSejarah,
    );
    return PeradilanSejarah.fromJson(response.data ?? const {});
  }

  Future<PeradilanContent> _getContent(String endpoint) async {
    final response = await _client.get<Map<String, dynamic>>(endpoint);
    return PeradilanContent.fromJson(response.data ?? const {});
  }

  Future<PeradilanContent> getSejarahPerkembangan() =>
      _getContent(ApiEndpoints.peradilanSejarahPerkembangan);

  Future<PeradilanContent> getVisiMisi() =>
      _getContent(ApiEndpoints.peradilanVisiMisi);

  Future<PeradilanContent> getKedudukanKewenangan() =>
      _getContent(ApiEndpoints.peradilanKedudukanKewenangan);

  Future<List<Jabatan>> getJabatan() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.peradilanJabatan,
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => Jabatan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PeradilanContent> getEmblemHymneMars() =>
      _getContent(ApiEndpoints.peradilanEmblemHymneMars);

  Future<PeradilanContent> getJanjiHakimKonstitusi() =>
      _getContent(ApiEndpoints.peradilanJanjiHakimKonstitusi);

  Future<PeradilanContent> getLokasi() =>
      _getContent(ApiEndpoints.peradilanLokasi);

  Future<PeradilanContent> getTugasPokokFungsi() =>
      _getContent(ApiEndpoints.peradilanTugasPokokFungsi);
}
