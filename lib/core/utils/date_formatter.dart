class DateFormatter {
  DateFormatter._();

  static const _bulanPendek = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static const _bulanPanjang = [
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

  /// "30 Sep 2026"
  static String tanggalPendek(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    return '${d.day} ${_bulanPendek[d.month - 1]} ${d.year}';
  }

  /// "30 September 2026"
  static String tanggalPanjang(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    return '${d.day} ${_bulanPanjang[d.month - 1]} ${d.year}';
  }

  /// "30 Sep 2026, 15:15"
  static String tanggalWaktu(DateTime? dt) {
    if (dt == null) return '-';
    final d = dt.toLocal();
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${_bulanPendek[d.month - 1]} ${d.year}, $h:$m';
  }

  /// "30 Sep 2026, 15:15 WIB" — selalu WIB
  static String tanggalWaktuWib(DateTime? dt) {
    if (dt == null) return '-';
    final wib = dt.toUtc().add(const Duration(hours: 7));
    final h = wib.hour.toString().padLeft(2, '0');
    final m = wib.minute.toString().padLeft(2, '0');
    return '${wib.day} ${_bulanPendek[wib.month - 1]} ${wib.year}, $h:$m WIB';
  }

  /// "15:15 WIB" — selalu WIB, tanpa tanggal
  static String waktuWib(DateTime? dt) {
    if (dt == null) return '-';
    final wib = dt.toUtc().add(const Duration(hours: 7));
    final h = wib.hour.toString().padLeft(2, '0');
    final m = wib.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }
}
