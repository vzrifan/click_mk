import 'package:click_mk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum JadwalType { sidang, putusan, keduanya, tunda, libur, none }

class JadwalSidangCalendar extends StatefulWidget {
  const JadwalSidangCalendar({super.key});

  @override
  State<JadwalSidangCalendar> createState() => _JadwalSidangCalendarState();
}

class _JadwalSidangCalendarState extends State<JadwalSidangCalendar> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  Map<int, (JadwalType, int)> get _jadwalData {
    return {
      1: (JadwalType.sidang, 8),
      2: (JadwalType.sidang, 5),
      3: (JadwalType.sidang, 6),
      7: (JadwalType.keduanya, 9),
      8: (JadwalType.sidang, 9),
      9: (JadwalType.sidang, 8),
      10: (JadwalType.sidang, 3),
      14: (JadwalType.sidang, 10),
      15: (JadwalType.sidang, 9),
      16: (JadwalType.keduanya, 21),
      17: (JadwalType.sidang, 3),
      21: (JadwalType.sidang, 12),
      22: (JadwalType.sidang, 9),
      23: (JadwalType.sidang, 6),
      24: (JadwalType.sidang, 2),
      28: (JadwalType.sidang, 11),
      30: (JadwalType.sidang, 6),
    };
  }

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

  Color _colorForType(JadwalType type) {
    return switch (type) {
      JadwalType.sidang => Colors.green,
      JadwalType.putusan => Colors.blue,
      JadwalType.keduanya => Colors.purple,
      JadwalType.tunda => Colors.red,
      JadwalType.libur => Colors.transparent,
      JadwalType.none => Colors.transparent,
    };
  }

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {},
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
              children: _dayNames.map((d) {
                return Expanded(
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
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            _buildCalendarGrid(),
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

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    int startOffset = firstDay.weekday - 1;

    final prevMonthLastDay = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      0,
    ).day;

    List<Widget> cells = [];

    for (int i = startOffset - 1; i >= 0; i--) {
      cells.add(_buildDayCell(prevMonthLastDay - i, isOtherMonth: true));
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final jadwal = _jadwalData[day];
      cells.add(
        _buildDayCell(
          day,
          type: jadwal?.$1 ?? JadwalType.none,
          count: jadwal?.$2,
        ),
      );
    }

    int remaining = (7 - cells.length % 7) % 7;
    for (int day = 1; day <= remaining; day++) {
      cells.add(_buildDayCell(day, isOtherMonth: true));
    }
    List<Widget> rows = [];
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

  Widget _buildDayCell(
    int day, {
    JadwalType type = JadwalType.none,
    int? count,
    bool isOtherMonth = false,
  }) {
    final hasEvent = type != JadwalType.none && !isOtherMonth;
    final bgColor = hasEvent ? _colorForType(type) : Colors.transparent;
    final isLibur = type == JadwalType.libur && !isOtherMonth;

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
                    child: count != null && !isOtherMonth
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
                          fontWeight: hasEvent
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
