enum JadwalType { sidang, putusan, keduanya, tunda, libur, none }

extension JadwalTypeX on JadwalType {
  static JadwalType fromStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SIDANG':
        return JadwalType.sidang;
      case 'PUTUSAN':
        return JadwalType.putusan;
      case 'KEDUANYA':
      case 'SIDANG_PUTUSAN':
        return JadwalType.keduanya;
      case 'TUNDA':
        return JadwalType.tunda;
      case 'LIBUR':
        return JadwalType.libur;
      default:
        return JadwalType.none;
    }
  }
}
