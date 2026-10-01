import 'package:flutter/material.dart';

class RisalahPaginationBar extends StatelessWidget {
  const RisalahPaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    this.maxVisible = 5,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final pages = _buildPageNumbers();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: currentPage > 1
                  ? () => onPageSelected(currentPage - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Sebelumnya',
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: pages.map((p) {
                    if (p == null) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text('...'),
                      );
                    }
                    final isActive = p == currentPage;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Material(
                        color: isActive
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => onPageSelected(p),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$p',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.black87,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            IconButton(
              onPressed: currentPage < totalPages
                  ? () => onPageSelected(currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Berikutnya',
            ),
          ],
        ),
      ),
    );
  }

  List<int?> _buildPageNumbers() {
    final result = <int?>[];
    final half = maxVisible ~/ 2;

    int start = currentPage - half;
    int end = currentPage + half;

    if (start < 1) {
      end += 1 - start;
      start = 1;
    }
    if (end > totalPages) {
      start -= end - totalPages;
      end = totalPages;
    }
    if (start < 1) start = 1;

    if (start > 1) {
      result.add(1);
      if (start > 2) result.add(null);
    }
    for (int i = start; i <= end; i++) {
      result.add(i);
    }
    if (end < totalPages) {
      if (end < totalPages - 1) result.add(null);
      result.add(totalPages);
    }
    return result;
  }
}
