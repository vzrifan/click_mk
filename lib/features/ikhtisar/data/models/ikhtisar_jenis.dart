enum IkhtisarJenis {
  all(null, 'ALL'),
  puu('PUU', 'PUU'),
  skln('SKLN', 'SKLN'),
  phpu('PHPU', 'PHPU'),
  phpkada('PHPKADA', 'PHPKADA');

  const IkhtisarJenis(this.apiValue, this.label);

  final String? apiValue;
  final String label;

  static IkhtisarJenis fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return IkhtisarJenis.values.firstWhere(
      (e) => e.apiValue == v,
      orElse: () => IkhtisarJenis.all,
    );
  }
}
