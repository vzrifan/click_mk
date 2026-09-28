import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/hakim_repository.dart';

final hakimRepositoryProvider = Provider<HakimRepository>((ref) {
  return HakimRepository(ref.watch(dioClientProvider));
});
