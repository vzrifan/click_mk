import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/home/data/models/jadwal_sidang.dart';
import 'package:click_mk/features/home/data/models/jadwal_type.dart';
import 'package:click_mk/features/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JadwalSidangCalendar extends ConsumerStatefulWidget {
  const JadwalSidangCalendar({super.key});

  @override
  ConsumerState<JadwalSidangCalendar> createState() =>
      _JadwalSidangCalendarState();
}

class _JadwalSidangCalendarState extends ConsumerState<JadwalSidangCalendar> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  static const _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static Color _colorForType(JadwalType type) => switch (type) {
    JadwalType.sidang => Colors.green,
    JadwalType.putusan => Colors.blue,
    JadwalType.keduanya => Colors.purple,
    JadwalType.tunda => Colors.red,
    JadwalType.libur => Colors.transparent,
    JadwalType.none => Colors.transparent,
  };

  void _prevMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
  });

  void _nextMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
  });

  Future<void> _refresh() async {
    ref.invalidate(
      jadwalSidangProvider((
        month: _focusedMonth.month,
        year: _focusedMonth.year,
      )),
    );

    try {
      await ref.read(
        jadwalSidangProvider((
          month: _focusedMonth.month,
          year: _focusedMonth.year,
        )).future,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final asyncJadwal = ref.watch(
      jadwalSidangProvider((
        month: _focusedMonth.month,
        year: _focusedMonth.year,
      )),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadwal Sidang',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.jadwalSidangName),
                  child: const Text(
                    'Selengkapnya',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _prevMonth,
                  icon: const Icon(Icons.chevron_left),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: _dayNames
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 4),

            asyncJadwal.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _refresh,
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (list) {
                final map = _toDateMap(list);
                return _buildCalendarGrid(map);
              },
            ),

            const Divider(height: 24),
            const Center(
              child: Text(
                'Keterangan',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Map<int, (JadwalType, int)> _toDateMap(List<JadwalSidang> list) {
    final result = <int, (JadwalType, int)>{};
    for (final j in list) {
      final day = int.tryParse(j.tanggal);
      if (day == null) continue;

      final type = JadwalTypeX.fromStatus(j.status);
      final existing = result[day];

      if (existing == null) {
        result[day] = (type, j.total);
      } else {
        final mergedType = existing.$1 == type ? type : JadwalType.keduanya;
        result[day] = (mergedType, existing.$2 + j.total);
      }
    }
    return result;
  }

  Widget _buildCalendarGrid(Map<int, (JadwalType, int)> jadwalData) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    final startOffset = firstDay.weekday - 1;

    final prevMonthLastDay = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      0,
    ).day;

    final cells = <Widget>[];

    for (int i = startOffset - 1; i >= 0; i--) {
      cells.add(_buildDayCell(prevMonthLastDay - i, isOtherMonth: true));
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final jadwal = jadwalData[day];
      cells.add(
        _buildDayCell(
          day,
          type: jadwal?.$1 ?? JadwalType.none,
          count: jadwal?.$2,
        ),
      );
    }

    final remaining = (7 - cells.length % 7) % 7;
    for (int day = 1; day <= remaining; day++) {
      cells.add(_buildDayCell(day, isOtherMonth: true));
    }

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(
        Row(
          children: cells
              .sublist(i, i + 7)
              .map((c) => Expanded(child: c))
              .toList(),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildLegend() {
    final items = [
      ('Sidang', Colors.green, false),
      ('Putusan', Colors.blue, false),
      ('Keduanya', Colors.purple, false),
      ('Tunda', Colors.red, false),
      ('Libur', Colors.red, true),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) {
        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.$3 ? Colors.transparent : item.$2,
                border: item.$3 ? Border.all(color: item.$2, width: 1.5) : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.$1,
              style: const TextStyle(fontSize: 10, color: AppColors.text),
            ),
          ],
        );
      }).toList(),
    );
  }
}

Widget _buildDayCell(
  int day, {
  JadwalType type = JadwalType.none,
  int? count,
  bool isOtherMonth = false,
}) {
  final hasEvent = type != JadwalType.none && !isOtherMonth;
  final isLibur = type == JadwalType.libur && !isOtherMonth;
  final bgColor = hasEvent && !isLibur
      ? _JadwalSidangCalendarState._colorForType(type)
      : Colors.transparent;

  return LayoutBuilder(
    builder: (context, constraints) {
      final cellWidth = constraints.maxWidth;

      final dayFontSize = (cellWidth * 0.35).clamp(10.0, 14.0);
      final countFontSize = (cellWidth * 0.22).clamp(7.0, 10.0);
      final circleSize = (cellWidth * 0.75).clamp(24.0, 40.0);

      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: cellWidth * 0.04,
          horizontal: cellWidth * 0.02,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: circleSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: countFontSize + 4,
                  child: count != null && !isOtherMonth && !isLibur
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: countFontSize,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(
                  height: circleSize,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor,
                      border: isLibur
                          ? Border.all(color: Colors.red, width: 1.5)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: dayFontSize,
                        fontWeight: hasEvent && !isLibur
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isOtherMonth
                            ? Colors.grey.shade400
                            : (hasEvent && !isLibur)
                            ? Colors.white
                            : AppColors.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
