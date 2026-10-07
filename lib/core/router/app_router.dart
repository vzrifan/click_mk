import 'package:click_mk/core/router/main_scaffold.dart';
import 'package:click_mk/features/anotasi/presentation/pages/anotasi_page.dart';
import 'package:click_mk/features/berita/presentation/pages/berita_detail_page.dart';
import 'package:click_mk/features/berita/presentation/pages/berita_page.dart';
import 'package:click_mk/features/hakim/presentation/pages/hakim_detail_page.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_jenis.dart';
import 'package:click_mk/features/jadwal_sidang/presentations/pages/jadwal_sidang_page.dart';
import 'package:click_mk/features/pengumuman/presentation/pages/pengumuman_page.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_endpoint.dart';
import 'package:click_mk/features/peraturan/presentation/pages/peraturan_list_page.dart';
import 'package:click_mk/features/peraturan/presentation/pages/peraturan_page.dart';
import 'package:click_mk/features/peraturan/presentation/pages/peraturan_uud_page.dart';
import 'package:click_mk/features/putusan/data/models/putusan_jenis.dart';
import 'package:click_mk/features/putusan/presentation/pages/putusan_page.dart';
import 'package:click_mk/features/risalah/data/models/risalah_jenis.dart';
import 'package:click_mk/features/risalah/presentation/pages/risalah_page.dart';
import 'package:click_mk/features/video_mkri/presentation/pages/video_mkri_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/hakim/presentation/pages/hakim_page.dart';
import 'package:click_mk/features/home/presentation/pages/home_page.dart';
import 'package:click_mk/features/hubungi_mk/hubungi_mk_page.dart';
import 'package:click_mk/features/peradilan/presentation/pages/peradilan_page.dart';

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
                    path: AppRoutes.anotasi,
                    name: AppRoutes.anotasiName,
                    builder: (context, state) => const AnotasiPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.jadwalSidang,
                    name: AppRoutes.jadwalSidangName,
                    builder: (context, state) => const JadwalSidangPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.pengumuman,
                    name: AppRoutes.pengumumanName,
                    builder: (context, state) => const PengumumanPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.videoMkri,
                    name: AppRoutes.videoMkriName,
                    builder: (context, state) => const VideoMkriPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.berita,
                    name: AppRoutes.beritaName,
                    builder: (context, state) => const BeritaPage(),
                  ),
                  GoRoute(
                    path: AppRoutes.beritaDetail,
                    name: AppRoutes.beritaDetailName,
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      if (id == null) {
                        return const Scaffold(
                          body: Center(child: Text('ID berita tidak valid')),
                        );
                      }
                      return BeritaDetailPage(id: id);
                    },
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
                routes: [
                  GoRoute(
                    path: AppRoutes.peraturanMk,
                    name: AppRoutes.peraturanMkName,
                    builder: (context, state) =>
                        const PeraturanListPage(endpoint: PeraturanEndpoint.mk),
                  ),
                  GoRoute(
                    path: AppRoutes.peraturanKetuaMk,
                    name: AppRoutes.peraturanKetuaMkName,
                    builder: (context, state) => const PeraturanListPage(
                      endpoint: PeraturanEndpoint.ketuaMk,
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.peraturanSekjen,
                    name: AppRoutes.peraturanSekjenName,
                    builder: (context, state) => const PeraturanListPage(
                      endpoint: PeraturanEndpoint.sekjen,
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.peraturanUud,
                    name: AppRoutes.peraturanUudName,
                    builder: (context, state) => const PeraturanUudPage(),
                  ),
                ],
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
