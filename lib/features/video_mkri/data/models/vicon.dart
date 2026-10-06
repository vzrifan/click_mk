class ViconInstansi {
  final String instansi;
  final String alamat;

  const ViconInstansi({required this.instansi, required this.alamat});

  factory ViconInstansi.fromJson(Map<String, dynamic> json) {
    return ViconInstansi(
      instansi: json['instansi']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
    );
  }
}
