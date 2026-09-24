import 'package:carousel_slider/carousel_slider.dart';
import 'package:click_mk/Utils/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
            height: widget.height,
            aspectRatio: 16 / 9,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            return Container(
              width: _current == entry.key ? 12.0 : 8.0,
              height: _current == entry.key ? 12.0 : 8.0,
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(
                  alpha: _current == entry.key ? 0.9 : 0.4,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
