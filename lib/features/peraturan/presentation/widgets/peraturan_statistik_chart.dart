import 'dart:math' as math;

import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_statistik.dart';
import 'package:flutter/material.dart';

class PeraturanStatistikChart extends StatelessWidget {
  const PeraturanStatistikChart({super.key, required this.items});

  final List<PeraturanStatistik> items;

  static const _colors = [
    Color(0xFF1E4E8C),
    Color(0xFF3B7DB8),
    Color(0xFF5BA3D0),
    Color(0xFF8ECAE6),
    Color(0xFF219EBC),
    Color(0xFF023047),
    Color(0xFFFFB703),
    Color(0xFFFB8500),
  ];

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data statistik',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final total = items.fold<int>(0, (sum, e) => sum + e.value);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Peraturan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _PieChartPainter(items: items, colors: _colors),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          for (int i = 0; i < items.length; i++) ...[
            _buildLegendItem(items[i], _colors[i % _colors.length], total),
            if (i < items.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem(PeraturanStatistik item, Color color, int total) {
    final percent = total == 0 ? 0.0 : (item.value / total * 100);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),

        Text(
          '${item.value}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '(${percent.toStringAsFixed(1)}%)',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({required this.items, required this.colors});

  final List<PeraturanStatistik> items;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<int>(0, (sum, e) => sum + e.value);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = 40.0;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < items.length; i++) {
      final sweepAngle = (items[i].value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final gap = 0.02;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle + gap / 2,
        sweepAngle - gap,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}
