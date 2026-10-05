import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_jenis.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_response.dart';

class IkhtisarRepository {
  final DioClient _client;
  IkhtisarRepository(this._client);

  Future<IkhtisarResponse> getIkhtisar({
    IkhtisarJenis jenis = IkhtisarJenis.all,
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.ikhtisar,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (jenis.apiValue != null) 'jenis': jenis.apiValue,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return IkhtisarResponse.fromJson(response.data ?? const {});
  }
}
