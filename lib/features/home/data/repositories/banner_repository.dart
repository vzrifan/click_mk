import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/home/data/models/banner.dart';

class BannerRepository {
  final DioClient _client;
  BannerRepository(this._client);

  Future<List<BannerItem>> getBanners() async {
    final response = await _client.get<List<dynamic>>(ApiEndpoints.banner);

    final data = response.data ?? [];
    return data
        .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
