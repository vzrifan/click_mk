
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/models/jabatan.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/jabatan_detail_sheet.dart';
import 'package:click_mk/features/peradilan/providers/peradilan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';

const double _kMinScale = 0.10;
const double _kMaxScale = 3.00;
const double _kNodeWidth = 100.0;
const double _kPadding = 32.0;

class _GraphData {
  final Graph graph;
  final Map<Edge, JabatanRelation> relations;
  final Map<String, Jabatan> jabatanByKey;

  _GraphData(this.graph, this.relations, this.jabatanByKey);
}

class StrukturOrganisasiView extends ConsumerStatefulWidget {
  const StrukturOrganisasiView({super.key});

  @override
  ConsumerState<StrukturOrganisasiView> createState() =>
      _StrukturOrganisasiViewState();
}

class _StrukturOrganisasiViewState
    extends ConsumerState<StrukturOrganisasiView> {
  late final TransformationController _transform;
  final _graphKey = GlobalKey();
  final _viewerKey = GlobalKey();
  bool _didCenter = false;
  List<Jabatan> _allJabatan = const [];

  @override
  void initState() {
    super.initState();
    _transform = TransformationController();
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _centerGraph() {
    final viewerBox =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final graphBox = _graphKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null || graphBox == null) return;

    final viewSize = viewerBox.size;
    final graphSize = graphBox.size;

    final scaleX = viewSize.width / graphSize.width;
    final scaleY = viewSize.height / graphSize.height;
    final scale = ((scaleX < scaleY ? scaleX : scaleY) * 0.90).clamp(
      _kMinScale,
      _kMaxScale,
    );

    final scaledW = graphSize.width * scale;
    final scaledH = graphSize.height * scale;
    final dx = (viewSize.width - scaledW) / 2;
    final dy = (viewSize.height - scaledH) / 2;

    _transform.value = Matrix4.identity()
      ..setEntry(0, 0, scale)
      ..setEntry(1, 1, scale)
      ..setEntry(0, 3, dx)
      ..setEntry(1, 3, dy);
  }

  void _zoomBy(double factor) => _applyZoom(_transform, factor, context);

  void _resetView() {
    _didCenter = false;
    _centerGraph();
  }

  @override
  Widget build(BuildContext context) {
    final asyncJabatan = ref.watch(peradilanJabatanProvider);

    return asyncJabatan.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(err.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('Data jabatan tidak tersedia'));
        }

        _allJabatan = list;
        final data = _buildGraph(list, maxLevel: 2);

        if (data.graph.nodes.isEmpty) {
          return const Center(
            child: Text(
              'Struktur organisasi belum tersedia',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final walkerConfig = _buildWalkerConfig(context);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_didCenter && mounted) {
            _didCenter = true;
            _centerGraph();
          }
        });

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: [
              Expanded(
                child: _GraphContainer(
                  viewerKey: _viewerKey,
                  graphKey: _graphKey,
                  transform: _transform,
                  graph: data.graph,
                  relations: data.relations,
                  config: walkerConfig,
                  onZoomIn: () => _zoomBy(1.25),
                  onZoomOut: () => _zoomBy(0.8),
                  onReset: _resetView,
                  nodeBuilder: (node) {
                    final value = node.key?.value;
                    if (value is! Jabatan) return const SizedBox.shrink();
                    return _OrgNode(
                      jabatan: value,
                      isRoot: data.graph.nodes.first.key?.value == value,
                      onTap: () => _onNodeTap(context, value),
                    );
                  },
                ),
              ),

              const _LegendRow(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Cubit untuk zoom • Geser untuk menjelajah • Ketuk node untuk detail',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onNodeTap(BuildContext context, Jabatan jabatan) {
    final key = _normalizeJabatanKey(jabatan);
    if (key == null) return;
    final treeNode = _findNodeInTree(key);

    if (treeNode == null || !treeNode.hasChildren) {
      _showDetail(context, jabatan);
    } else {
      _showSubGraph(context, treeNode);
    }
  }

  void _showDetail(BuildContext context, Jabatan jabatan) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => JabatanDetailSheet(jabatan: jabatan),
    );
  }

  void _showSubGraph(BuildContext context, JabatanNode treeNode) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _SubGraphSheet(rootNode: treeNode, allJabatan: _allJabatan),
    );
  }

  _GraphData _buildGraph(List<Jabatan> list, {required int maxLevel}) {
    final graph = Graph()..isTree = true;
    final relations = <Edge, JabatanRelation>{};
    final jabatanByKey = <String, Jabatan>{};
    for (final j in list) {
      final k = _normalizeJabatanKey(j);
      if (k != null) jabatanByKey[k] = j;
    }

    void addTree(JabatanNode treeNode, {Node? parent, int level = 0}) {
      Jabatan? jabatan;
      for (final e in jabatanByKey.entries) {
        if (treeNode.matches(e.key)) {
          jabatan = e.value;
          break;
        }
      }
      if (jabatan == null) {
        if (level < maxLevel) {
          for (final c in treeNode.children) {
            addTree(c, parent: parent, level: level + 1);
          }
        }
        return;
      }
      final node = Node.Id(jabatan);
      graph.addNode(node);
      if (parent != null) {
        final edge = graph.addEdge(parent, node);
        relations[edge] = treeNode.relation;
      }
      if (level < maxLevel) {
        for (final c in treeNode.children) {
          addTree(c, parent: node, level: level + 1);
        }
      }
    }

    for (final root in JabatanTree.root) {
      addTree(root);
    }
    return _GraphData(graph, relations, jabatanByKey);
  }
}

class _GraphContainer extends StatelessWidget {
  const _GraphContainer({
    required this.viewerKey,
    required this.graphKey,
    required this.transform,
    required this.graph,
    required this.relations,
    required this.config,
    required this.nodeBuilder,
    required this.onZoomIn,
    required this.onZoomOut,
    this.onReset,
  });

  final Key viewerKey;
  final Key graphKey;
  final TransformationController transform;
  final Graph graph;
  final Map<Edge, JabatanRelation> relations;
  final BuchheimWalkerConfiguration config;
  final Widget Function(Node) nodeBuilder;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        config.orientation ==
        BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            key: viewerKey,
            child: InteractiveViewer(
              transformationController: transform,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(600),
              minScale: _kMinScale,
              maxScale: _kMaxScale,
              child: Padding(
                padding: const EdgeInsets.all(_kPadding),
                child: GraphView(
                  key: graphKey,
                  graph: graph,
                  algorithm: BuchheimWalkerAlgorithm(
                    config,
                    _OrgEdgeRenderer(
                      isHorizontal: isHorizontal,
                      relations: relations,
                    ),
                  ),
                  paint: _edgePaint(),
                  builder: nodeBuilder,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 12,
            right: 12,
            child: _ZoomControls(
              onZoomIn: onZoomIn,
              onZoomOut: onZoomOut,
              onReset: onReset,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrgNode extends StatelessWidget {
  const _OrgNode({
    required this.jabatan,
    required this.onTap,
    this.isRoot = false,
  });

  final Jabatan jabatan;
  final VoidCallback onTap;
  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    final bg = isRoot ? AppColors.primary : Colors.white;
    final border = isRoot ? AppColors.primary : AppColors.border;
    final fg = isRoot ? Colors.white : AppColors.text;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _kNodeWidth,
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: isRoot ? 0 : 1),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: isRoot ? 6 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            jabatan.jabatan,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _SubGraphSheet extends StatefulWidget {
  const _SubGraphSheet({required this.rootNode, required this.allJabatan});

  final JabatanNode rootNode;
  final List<Jabatan> allJabatan;

  @override
  State<_SubGraphSheet> createState() => _SubGraphSheetState();
}

class _SubGraphSheetState extends State<_SubGraphSheet> {
  late final TransformationController _transform;
  final _graphKey = GlobalKey();
  final _viewerKey = GlobalKey();
  bool _didCenter = false;

  @override
  void initState() {
    super.initState();
    _transform = TransformationController();
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _center() {
    final viewerBox =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final graphBox = _graphKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewerBox == null || graphBox == null) return;

    final viewSize = viewerBox.size;
    final graphSize = graphBox.size;

    final scaleX = viewSize.width / graphSize.width;
    final scaleY = viewSize.height / graphSize.height;
    final scale = ((scaleX < scaleY ? scaleX : scaleY) * 0.90).clamp(
      _kMinScale,
      _kMaxScale,
    );

    final dx = (viewSize.width - graphSize.width * scale) / 2;
    final dy = (viewSize.height - graphSize.height * scale) / 2;

    _transform.value = Matrix4.identity()
      ..setEntry(0, 0, scale)
      ..setEntry(1, 1, scale)
      ..setEntry(0, 3, dx)
      ..setEntry(1, 3, dy);
  }

  void _zoomBy(double factor) => _applyZoom(_transform, factor, context);

  @override
  Widget build(BuildContext context) {
    final data = _buildSubGraph(widget.rootNode, widget.allJabatan);

    if (data.graph.nodes.isEmpty) return _emptySheet();

    final walkerConfig = _buildWalkerConfig(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didCenter && mounted) {
        _didCenter = true;
        _center();
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, _) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _SheetHeader(label: _getLabel(widget.rootNode)),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: _GraphContainer(
                    viewerKey: _viewerKey,
                    graphKey: _graphKey,
                    transform: _transform,
                    graph: data.graph,
                    relations: data.relations,
                    config: walkerConfig,
                    onZoomIn: () => _zoomBy(1.25),
                    onZoomOut: () => _zoomBy(0.8),
                    nodeBuilder: (node) {
                      final value = node.key?.value;
                      if (value is! Jabatan) return const SizedBox.shrink();
                      return _OrgNode(
                        jabatan: value,
                        isRoot: data.graph.nodes.first.key?.value == value,
                        onTap: () => _onNodeTap(context, value),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onNodeTap(BuildContext context, Jabatan jabatan) {
    final key = _normalizeJabatanKey(jabatan);
    if (key == null) return;
    final treeNode = _findNodeInTree(key);

    if (treeNode == null || !treeNode.hasChildren) {
      Navigator.pop(context);
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => JabatanDetailSheet(jabatan: jabatan),
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            _SubGraphSheet(rootNode: treeNode, allJabatan: widget.allJabatan),
      );
    }
  }

  Widget _emptySheet() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Tidak ada sub-struktur',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  _GraphData _buildSubGraph(JabatanNode root, List<Jabatan> allJabatan) {
    final graph = Graph()..isTree = true;
    final relations = <Edge, JabatanRelation>{};
    final jabatanByKey = <String, Jabatan>{};
    for (final j in allJabatan) {
      final k = _normalizeJabatanKey(j);
      if (k != null) jabatanByKey[k] = j;
    }

    void add(JabatanNode treeNode, {Node? parent}) {
      Jabatan? jabatan;
      for (final e in jabatanByKey.entries) {
        if (treeNode.matches(e.key)) {
          jabatan = e.value;
          break;
        }
      }
      if (jabatan == null) {
        for (final c in treeNode.children) {
          add(c, parent: parent);
        }
        return;
      }
      final node = Node.Id(jabatan);
      graph.addNode(node);
      if (parent != null) {
        final edge = graph.addEdge(parent, node);
        relations[edge] = treeNode.relation;
      }
      for (final c in treeNode.children) {
        add(c, parent: node);
      }
    }

    add(root);
    return _GraphData(graph, relations, jabatanByKey);
  }

  String _getLabel(JabatanNode node) {
    for (final j in widget.allJabatan) {
      final k = _normalizeJabatanKey(j);
      if (k != null && node.matches(k)) return j.jabatan;
    }
    return node.key.replaceAll('_', ' ');
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({
    required this.onZoomIn,
    required this.onZoomOut,
    this.onReset,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ZoomButton(icon: Icons.add, onTap: onZoomIn),
        const SizedBox(height: 4),
        _ZoomButton(icon: Icons.remove, onTap: onZoomOut),
        if (onReset != null) ...[
          const SizedBox(height: 4),
          _ZoomButton(icon: Icons.fit_screen, onTap: onReset!),
        ],
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: AppColors.shadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Wrap(
        spacing: 16,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: const [
          _LegendItem(relation: JabatanRelation.komando),
          _LegendItem(relation: JabatanRelation.koordinasi),
          _LegendItem(relation: JabatanRelation.pengawas),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.relation});
  final JabatanRelation relation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 28,
          height: 12,
          child: CustomPaint(painter: _LegendLinePainter(relation)),
        ),
        const SizedBox(width: 6),
        Text(
          relation.label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}

class _LegendLinePainter extends CustomPainter {
  _LegendLinePainter(this.relation);
  final JabatanRelation relation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = relation.color
      ..strokeWidth = relation.isSolid ? 1.5 : 1.2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2);

    if (relation.isSolid) {
      canvas.drawPath(path, paint);
    } else {
      final dash = relation == JabatanRelation.pengawas ? 3.0 : 6.0;
      final gap = relation == JabatanRelation.pengawas ? 3.0 : 4.0;

      for (final metric in path.computeMetrics()) {
        double distance = 0;
        while (distance < metric.length) {
          final end = (distance + dash).clamp(0.0, metric.length);
          canvas.drawPath(metric.extractPath(distance, end), paint);
          distance = end + gap;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LegendLinePainter old) =>
      old.relation != relation;
}

void _drawDashedPath(
  Canvas canvas,
  Path path,
  Paint paint, {
  double dash = 6,
  double gap = 4,
}) {
  for (final metric in path.computeMetrics()) {
    double distance = 0;
    while (distance < metric.length) {
      final end = distance + dash;
      canvas.drawPath(
        metric.extractPath(distance, end.clamp(0, metric.length)),
        paint,
      );
      distance = end + gap;
    }
  }
}

class _OrgEdgeRenderer extends EdgeRenderer {
  _OrgEdgeRenderer({required this.isHorizontal, required this.relations});

  final bool isHorizontal;
  final Map<Edge, JabatanRelation> relations;

  @override
  void renderEdge(Canvas canvas, Edge edge, Paint paint) {
    final relation = relations[edge] ?? JabatanRelation.komando;
    final from = edge.source;
    final to = edge.destination;

    final path = Path();

    if (isHorizontal) {
      final startX = from.position.dx + from.size.width;
      final startY = from.position.dy + from.size.height / 2;
      final endX = to.position.dx;
      final endY = to.position.dy + to.size.height / 2;
      final midX = (startX + endX) / 2;

      path
        ..moveTo(startX, startY)
        ..lineTo(midX, startY)
        ..lineTo(midX, endY)
        ..lineTo(endX, endY);
    } else {
      final startX = from.position.dx + from.size.width / 2;
      final startY = from.position.dy + from.size.height;
      final endX = to.position.dx + to.size.width / 2;
      final endY = to.position.dy;
      final midY = (startY + endY) / 2;

      path
        ..moveTo(startX, startY)
        ..lineTo(startX, midY)
        ..lineTo(endX, midY)
        ..lineTo(endX, endY);
    }

    if (relation.isSolid) {
      final solidPaint = Paint()
        ..color = relation.color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, solidPaint);
    } else {
      final dashedPaint = Paint()
        ..color = relation.color
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      final dashLength = relation == JabatanRelation.pengawas ? 3.0 : 6.0;
      final gapLength = relation == JabatanRelation.pengawas ? 3.0 : 4.0;

      _drawDashedPath(
        canvas,
        path,
        dashedPaint,
        dash: dashLength,
        gap: gapLength,
      );
    }
  }
}

Paint _edgePaint() => Paint()
  ..color = AppColors.border
  ..strokeWidth = 1.2
  ..style = PaintingStyle.stroke;

void _applyZoom(
  TransformationController ctrl,
  double factor,
  BuildContext context,
) {
  final current = ctrl.value.getMaxScaleOnAxis();
  final newScale = (current * factor).clamp(_kMinScale, _kMaxScale);
  if (newScale == current) return;

  final tx = ctrl.value.getTranslation();
  final cx = MediaQuery.of(context).size.width / 2;
  final cy = MediaQuery.of(context).size.height / 2;

  final ratio = newScale / current;
  final newTx = cx + (tx.x - cx) * ratio;
  final newTy = cy + (tx.y - cy) * ratio;

  ctrl.value = Matrix4.identity()
    ..setEntry(0, 0, newScale)
    ..setEntry(1, 1, newScale)
    ..setEntry(0, 3, newTx)
    ..setEntry(1, 3, newTy);
}

JabatanNode? _findNodeInTree(String key, {List<JabatanNode>? nodes}) {
  final list = nodes ?? JabatanTree.root;
  for (final node in list) {
    if (node.matches(key)) return node;
    final found = _findNodeInTree(key, nodes: node.children);
    if (found != null) return found;
  }
  return null;
}

String? _normalizeJabatanKey(Jabatan jabatan) {
  final value = jabatan.jabatan.trim();
  if (value.isEmpty) return null;
  return value
      .toUpperCase()
      .replaceAll(RegExp(r'[^A-Z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

BuchheimWalkerConfiguration _buildWalkerConfig(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final isWide = width >= 600;

  return BuchheimWalkerConfiguration()
    ..siblingSeparation = isWide ? 16 : 12
    ..levelSeparation = isWide ? 52 : 60
    ..subtreeSeparation = isWide ? 20 : 20
    ..orientation = isWide
        ? BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM
        : BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
}
