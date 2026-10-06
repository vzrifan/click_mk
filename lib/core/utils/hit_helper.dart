import 'package:click_mk/core/network/dio_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HitHelper {
  HitHelper._();

  static void fire(WidgetRef ref, String linkHit) {
    if (linkHit.isEmpty) return;

    Future.microtask(() async {
      try {
        final client = ref.read(dioClientProvider);
        await client.patch<dynamic>(linkHit);
        debugPrint('Hit sent: $linkHit');
      } catch (e) {
        debugPrint('Hit error: $e');
      }
    });
  }
}
