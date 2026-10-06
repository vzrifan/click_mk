import 'package:click_mk/features/video_mkri/data/models/video_status.dart';

class VideoMkri {
  final String idYoutube;
  final String videoThumbnail;
  final String title;
  final String description;
  final VideoStatus status;
  final DateTime? lastUpdatedAt;
  final DateTime? publishtime;
  final int ruangSidang;

  const VideoMkri({
    required this.idYoutube,
    required this.videoThumbnail,
    required this.title,
    required this.description,
    required this.status,
    required this.lastUpdatedAt,
    required this.publishtime,
    required this.ruangSidang,
  });

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$idYoutube';

  bool get isLive => status == VideoStatus.live;

  factory VideoMkri.fromJson(Map<String, dynamic> json) {
    return VideoMkri(
      idYoutube: json['id_youtube']?.toString() ?? '',
      videoThumbnail: json['video_thumbnail']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: VideoStatus.fromApi(json['status']?.toString()),
      lastUpdatedAt: DateTime.tryParse(
        json['last_updated_at']?.toString() ?? '',
      ),
      publishtime: DateTime.tryParse(json['publishtime']?.toString() ?? ''),
      ruangSidang: _parseInt(json['ruang_sidang']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  String get relativeTime {
    final dt = publishtime ?? lastUpdatedAt;
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
    if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} minggu yang lalu';
    }
    if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} bulan yang lalu';
    }
    return '${(diff.inDays / 365).floor()} tahun yang lalu';
  }
}
