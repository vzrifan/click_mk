import 'package:carousel_slider/carousel_slider.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> items;
  final double height;

  const Carousel({super.key, required this.items, this.height = 200});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;

  double _calculateLeftOffset() {
    double viewportWidth = 52.0;
    double rowWidth = (widget.items.length - 1) * 16.0 + 20.0;
    double minLeft = viewportWidth - rowWidth;
    if (minLeft > 0) minLeft = 0;
    double idealLeft = 16.0 * (1 - _current);
    return idealLeft.clamp(minLeft, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 14.0,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 52.0,
              height: 28.0,
              child: ClipRect(
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: _calculateLeftOffset(),
                      top: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(widget.items.length, (index) {
                          final isActive = _current == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isActive ? 12.0 : 8.0,
                            height: isActive ? 12.0 : 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(
                                alpha: isActive ? 0.9 : 0.4,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
