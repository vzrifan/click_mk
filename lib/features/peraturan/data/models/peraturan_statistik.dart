class PeraturanStatistik {
  final String label;
  final int value;

  const PeraturanStatistik({required this.label, required this.value});

  factory PeraturanStatistik.fromJson(Map<String, dynamic> json) {
    return PeraturanStatistik(
      label: json['label']?.toString() ?? '',
      value: _parseInt(json['value']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
