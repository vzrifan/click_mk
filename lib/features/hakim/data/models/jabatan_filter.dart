enum JabatanFilter {
  all(null, 'Semua'),
  ketua('KETUA', 'Ketua'),
  wakil('WAKIL', 'Wakil Ketua'),
  hakimKonstitusi('HAKIM_KONSTITUSI', 'Hakim Konstitusi');

  const JabatanFilter(this.apiValue, this.label);

  final String? apiValue;
  final String label;

  static JabatanFilter fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return JabatanFilter.values.firstWhere(
      (e) => e.apiValue == v,
      orElse: () => JabatanFilter.all,
    );
  }
}
