import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    baseUrl: 'https://api.mkri.id',
    headers: {
      'api-key': dotenv.env['MKRI_API_KEY'],
      'Origin': 'https://www.mkri.id',
      'Referer': 'https://www.mkri.id/',
      'Accept': 'application/json',
    },
  );
});
