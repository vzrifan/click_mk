import 'package:click_mk/features/video_mkri/data/models/video_mkri.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LiveStreamingView extends StatefulWidget {
  const LiveStreamingView({super.key, required this.videos});

  final List<VideoMkri> videos;

  @override
  State<LiveStreamingView> createState() => _LiveStreamingViewState();
}

class _LiveStreamingViewState extends State<LiveStreamingView> {
  int _selectedRuang = 1;
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  VideoMkri? get _liveVideo {
    for (final v in widget.videos) {
      if (v.isLive && v.ruangSidang == _selectedRuang) return v;
    }
    return null;
  }

  void _loadVideo(VideoMkri? video) {
    _controller?.close();
    _controller = null;

    if (video != null && video.idYoutube.isNotEmpty) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: video.idYoutube,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
          enableCaption: false,
          loop: false,
        ),
      );
    }

    if (mounted) setState(() {});
  }

  void _selectRuang(int room) {
    if (_selectedRuang == room) return;
    setState(() => _selectedRuang = room);
    _loadVideo(_liveVideo);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo(_liveVideo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final live = _liveVideo;
    final hasLive = live != null && live.idYoutube.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Column(
                  children: List.generate(4, (i) {
                    final room = i + 1;
                    final isSelected = room == _selectedRuang;
                    final hasLiveInRoom = widget.videos.any(
                      (v) => v.isLive && v.ruangSidang == room,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Material(
                        color: isSelected
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _selectRuang(room),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_circle_right,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Ruang Sidang $room',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (hasLiveInRoom)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: hasLive && _controller != null
                        ? _buildPlayer()
                        : _buildPlaceholder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    return YoutubePlayer(controller: _controller!, aspectRatio: 16 / 10);
  }

  Widget _buildPlaceholder() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.videocam_off_outlined, size: 40, color: Colors.black54),
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Saat ini video livestreaming tidak tersedia.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
