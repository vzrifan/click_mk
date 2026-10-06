enum VideoStatus {
  live('LIVE', 'LIVE'),
  upcoming('UPCOMING', 'SEGERA'),
  onDemand('ON_DEMAND', 'ON DEMAND');

  const VideoStatus(this.value, this.label);
  final String value;
  final String label;

  static VideoStatus fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return VideoStatus.values.firstWhere(
      (e) => e.value == v,
      orElse: () => VideoStatus.onDemand,
    );
  }
}
