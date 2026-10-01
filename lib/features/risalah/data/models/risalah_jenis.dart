enum RisalahJenis {
  all('ALL', 'Semua'),
  puu('PUU', 'PUU'),
  skln('SKLN', 'SKLN'),
  phpu('PHPU', 'PHPU'),
  phpkada('PHPKADA', 'PHPKADA');

  const RisalahJenis(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static RisalahJenis fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return RisalahJenis.values.firstWhere(
      (e) => e.apiValue == v,
      orElse: () => RisalahJenis.all,
    );
  }
}
