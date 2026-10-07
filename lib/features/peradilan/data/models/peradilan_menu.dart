import 'package:flutter/material.dart';

enum PeradilanMenu {
  peradilan('peradilan', 'Peradilan', Icons.info_outline),
  kedudukanKewenangan(
    'kedudukan-kewenangan',
    'Kedudukan & Kewenangan',
    Icons.gavel,
  ),
  sumpahJanjiHakim(
    'sumpah-janji-hakim',
    'Sumpah & Janji Hakim',
    Icons.handshake_outlined,
  ),
  sejarahPerkembangan(
    'sejarah-perkembangan',
    'Sejarah & Perkembangan',
    Icons.history_edu,
  ),
  strukturOrganisasi(
    'struktur-organisasi',
    'Struktur Organisasi',
    Icons.account_tree_outlined,
  ),
  profilPejabat('profil-pejabat', 'Profil Pejabat', Icons.badge_outlined),
  emblemHymneMars(
    'emblem-hymne-mars',
    'Emblem, Hymne & Mars',
    Icons.music_note_outlined,
  ),
  visiMisi('visi-misi', 'Visi & Misi', Icons.flag_outlined),
  tugasPokokFungsi(
    'tugas-pokok-fungsi',
    'Tugas Pokok & Fungsi',
    Icons.assignment_outlined,
  ),
  lokasi('lokasi', 'Lokasi', Icons.location_on_outlined),
  majelisKehormatan(
    'majelis-kehormatan',
    'Majelis Kehormatan MK',
    Icons.verified_user_outlined,
  );

  const PeradilanMenu(this.slug, this.title, this.icon);

  final String slug;
  final String title;
  final IconData icon;

  static PeradilanMenu? fromSlug(String slug) {
    for (final m in PeradilanMenu.values) {
      if (m.slug == slug) return m;
    }
    return null;
  }
}
