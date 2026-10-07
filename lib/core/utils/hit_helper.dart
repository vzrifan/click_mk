import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HitHelper {
  HitHelper._();

  static void fire(WidgetRef ref, String linkHit) {
    if (linkHit.isEmpty) return;

    final client = ref.read(dioClientProvider);

    _send(client, linkHit);
  }

  static Future<void> _send(DioClient client, String url) async {
    try {
      await client.patch<dynamic>(url);
      debugPrint('Hit sent: $url');
    } catch (e) {
      debugPrint('Hit error: $e');
    }
  }
}
