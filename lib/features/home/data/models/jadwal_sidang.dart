class JadwalSidang {
  final String date;
  final String tanggal;
  final int total;
  final String status;

  const JadwalSidang({
    required this.date,
    required this.tanggal,
    required this.total,
    required this.status,
  });

  factory JadwalSidang.fromJson(Map<String, dynamic> json) {
    return JadwalSidang(
      date: json['date'] as String? ?? '',
      tanggal: json['tanggal'] as String? ?? '',
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'tanggal': tanggal,
    'total': total,
    'status': status,
  };
}
