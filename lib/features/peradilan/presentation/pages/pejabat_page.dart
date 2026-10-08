import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/repositories/pejabat_repository.dart';
import 'package:click_mk/features/peradilan/providers/pejabat_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/pejabat_card.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/pejabat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PejabatPage extends StatelessWidget {
  const PejabatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: const Text(
              'Profil Pejabat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
                height: 1.3,
              ),
            ),
          ),

          // Section (langsung, tanpa Expanded)
          const _PejabatSection(
            title: 'Sekjen',
            jabatan: PejabatJabatan.sekjen,
          ),
          const _PejabatSection(
            title: 'Panitera',
            jabatan: PejabatJabatan.panitera,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Section per jabatan (Sekjen, Panitera)
// ─────────────────────────────────────────────────────────────────
class _PejabatSection extends ConsumerStatefulWidget {
  const _PejabatSection({required this.title, required this.jabatan});

  final String title;
  final PejabatJabatan jabatan;

  @override
  ConsumerState<_PejabatSection> createState() => _PejabatSectionState();
}

class _PejabatSectionState extends ConsumerState<_PejabatSection> {
  PejabatStatus _status = PejabatStatus.aktif;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(
      pejabatListProvider((jabatan: widget.jabatan, status: _status)),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Judul section ───────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),

          // ── Tab: aktif / sebelumnya ─────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildTabButton(
                  label: widget.title,
                  isActive: _status == PejabatStatus.aktif,
                  onTap: () => setState(() => _status = PejabatStatus.aktif),
                ),
                const SizedBox(width: 8),
                _buildTabButton(
                  label: '${widget.title} Periode Sebelumnya',
                  isActive: _status == PejabatStatus.nonaktif,
                  onTap: () => setState(() => _status = PejabatStatus.nonaktif),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── List pejabat ────────────────────
          asyncData.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.all(16),
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
                  ],
                ),
              ),
            ),
            data: (list) {
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Belum ada data pejabat',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) => PejabatCard(
                  pejabat: list[i],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            PejabatDetailPage(pejabatId: list[i].id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : Colors.black87,
          ),
        ),
      ),
    );
  }
}
