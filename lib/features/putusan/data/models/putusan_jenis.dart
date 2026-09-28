enum PutusanJenis {
  all('ALL', 'Semua'),
  puu('PUU', 'PUU'),
  skln('SKLN', 'SKLN'),
  phpu('PHPU', 'PHPU'),
  phpkada('PHPKADA', 'PHPKADA');

  const PutusanJenis(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static PutusanJenis fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return PutusanJenis.values.firstWhere(
      (e) => e.apiValue == v,
      orElse: () => PutusanJenis.all,
    );
  }
}
