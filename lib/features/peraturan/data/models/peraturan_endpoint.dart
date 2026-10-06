enum PeraturanEndpoint {
  mk('/peraturan/mk', 'Peraturan MK'),
  ketuaMk('/peraturan/ketua-mk', 'Peraturan Ketua MK'),
  sekjen('/peraturan/sekjen', 'Peraturan & Keputusan Sekjen');

  const PeraturanEndpoint(this.path, this.title);

  final String path;
  final String title;
}
