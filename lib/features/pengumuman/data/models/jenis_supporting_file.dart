enum JenisSupportingFile {
  pdf('PDF'),
  img('IMG'),
  link('LINK'),
  none('NONE');

  const JenisSupportingFile(this.value);
  final String value;

  static JenisSupportingFile fromApi(String? value) {
    final v = (value ?? '').toUpperCase();
    return JenisSupportingFile.values.firstWhere(
      (e) => e.value == v,
      orElse: () => JenisSupportingFile.none,
    );
  }
}
