import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/home/presentation/widgets/banner_slide.dart';
import 'package:click_mk/features/home/presentation/widgets/carousel.dart';
import 'package:click_mk/features/home/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerCarousel extends ConsumerWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBanner = ref.watch(bannerListProvider);

    return asyncBanner.when(
      loading: () => SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final b in banners) {
            precacheImage(CachedNetworkImageProvider(b.imageUrl), context);
          }
        });

        return Carousel(
          items: banners.map((b) => BannerSlide(banner: b)).toList(),
          height: MediaQuery.of(context).size.height * 0.25,
          onItemTap: (i) {
            final url = banners[i].actionUrlAbsolute;
            if (url != null) UrlHelper.open(url);
          },
        );
      },
    );
  }
}
