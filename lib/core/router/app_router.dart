import 'package:click_mk/core/router/main_scaffold.dart';
import 'package:click_mk/features/anotasi/presentation/pages/anotasi_page.dart';
import 'package:click_mk/features/hakim/presentation/pages/hakim_detail_page.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_jenis.dart';
import 'package:click_mk/features/putusan/data/models/putusan_jenis.dart';
import 'package:click_mk/features/putusan/presentation/pages/putusan_page.dart';
import 'package:click_mk/features/risalah/data/models/risalah_jenis.dart';
import 'package:click_mk/features/risalah/presentation/pages/risalah_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/hakim/presentation/pages/hakim_page.dart';
import 'package:click_mk/features/home/presentation/pages/home_page.dart';
import 'package:click_mk/features/hubungiMK/hubungi_mk_page.dart';
import 'package:click_mk/features/peradilan/peradilan_page.dart';
import 'package:click_mk/features/peraturan/peraturan_page.dart';

import '../../features/ikhtisar/presentation/pages/ikhtisar_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
      body: Center(child: Text('Route: ${state.uri}')),
    ),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.homeName,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: AppRoutes.putusan,
                    name: AppRoutes.putusanName,
                    builder: (context, state) {
                      final jenis = PutusanJenis.fromApi(
                        state.uri.queryParameters['jenis'],
                      );
                      return PutusanPage(initialJenis: jenis);
                    },
                  ),
                  GoRoute(
                    path: AppRoutes.risalah,
                    name: AppRoutes.risalahName,
                    builder: (context, state) {
                      final jenis = RisalahJenis.fromApi(
                        state.uri.queryParameters['jenis'],
                      );
                      return RisalahPage(initialJenis: jenis);
                    },
                  ),
                  GoRoute(
                    path: AppRoutes.ikhtisar,
                    name: AppRoutes.ikhtisarName,
                    builder: (context, state) {
                      final jenis = IkhtisarJenis.fromApi(
                        state.uri.queryParameters['jenis'],
                      );
                      return IkhtisarPage(initialJenis: jenis);
                    },
                  ),
                  GoRoute(
                    path: 'anotasi',
                    name: AppRoutes.anotasiName,
                    builder: (context, state) => const AnotasiPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.peradilan,
                name: AppRoutes.peradilanName,
                builder: (context, state) => const PeradilanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hakim,
                name: AppRoutes.hakimName,
                builder: (context, state) => const HakimPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRoutes.hakimDetailName,
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const Scaffold(
                          body: Center(child: Text('ID hakim tidak valid')),
                        );
                      }
                      return HakimDetailPage(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.peraturan,
                name: AppRoutes.peraturanName,
                builder: (context, state) => const PeraturanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hubungiMk,
                name: AppRoutes.hubungiMkName,
                builder: (context, state) => const HubungiMKPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
