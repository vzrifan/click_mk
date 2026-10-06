enum BeritaKategori {
  sidang('SIDANG', 'Berita Sidang'),
  nonSidang('NON_SIDANG', 'Berita Non Sidang'),
  duaMenit('DUA_MENIT', 'Berita Dua Menit'),
  populer('POPULER', 'Berita Populer'),
  siaranPers('SIARAN_PERS', 'Siaran Pers');

  const BeritaKategori(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static BeritaKategori fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return BeritaKategori.values.firstWhere(
      (e) => e.apiValue == v,
      orElse: () => BeritaKategori.sidang,
    );
  }
}
