import 'dart:async';

import 'package:click_mk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    super.key,
    required this.items,
    this.height = 200,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.viewportFraction = 1.0,
    this.borderRadius = 0,
    this.onItemTap,
  });

  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final double viewportFraction;
  final double borderRadius;
  final void Function(int index)? onItemTap;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final PageController _controller;
  final _currentNotifier = ValueNotifier<int>(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
      viewportFraction: widget.viewportFraction,
    );
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _currentNotifier.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (!widget.autoPlay || widget.items.length <= 1) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_currentNotifier.value + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _pauseAutoPlay() {
    _timer?.cancel();
  }

  void _resumeAutoPlay() {
    _startAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final hasMultiple = widget.items.length > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollStartNotification && n.dragDetails != null) {
                    _pauseAutoPlay();
                  } else if (n is ScrollEndNotification) {
                    _resumeAutoPlay();
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.items.length,
                  allowImplicitScrolling: true,
                  onPageChanged: (index) {
                    _currentNotifier.value = index;
                  },
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final child = widget.borderRadius > 0
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              widget.borderRadius,
                            ),
                            child: item,
                          )
                        : item;

                    if (widget.onItemTap == null) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.viewportFraction < 1.0 ? 4 : 0,
                        ),
                        child: child,
                      );
                    }

                    return GestureDetector(
                      onTap: () => widget.onItemTap!(index),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.viewportFraction < 1.0 ? 4 : 0,
                        ),
                        child: child,
                      ),
                    );
                  },
                ),
              ),

              if (hasMultiple) ...[
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavButton(
                      icon: Icons.chevron_left,
                      onTap: () {
                        _pauseAutoPlay();
                        final prev = (_currentNotifier.value - 1).clamp(
                          0,
                          widget.items.length - 1,
                        );
                        _controller.animateToPage(
                          prev,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                        _resumeAutoPlay();
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavButton(
                      icon: Icons.chevron_right,
                      onTap: () {
                        _pauseAutoPlay();
                        final next = (_currentNotifier.value + 1).clamp(
                          0,
                          widget.items.length - 1,
                        );
                        _controller.animateToPage(
                          next,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                        _resumeAutoPlay();
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        if (hasMultiple)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ValueListenableBuilder<int>(
              valueListenable: _currentNotifier,
              builder: (context, current, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.items.length, (index) {
                    final isActive = current == index;
                    return GestureDetector(
                      onTap: () {
                        _controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        width: isActive ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isActive
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
