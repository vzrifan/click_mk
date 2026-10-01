import 'package:click_mk/core/audio/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RisalahAudioControl extends StatefulWidget {
  const RisalahAudioControl({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title; // nomor perkara, untuk label

  @override
  State<RisalahAudioControl> createState() => _RisalahAudioControlState();
}

class _RisalahAudioControlState extends State<RisalahAudioControl> {
  final _service = AudioPlayerService.instance;
  Duration? _dragValue;

  bool get _isCurrent => _service.isActive(widget.url);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _service.playerStateStream,
      builder: (context, stateSnap) {
        final state = stateSnap.data;
        final isThisActive = _isCurrent;
        final isPlaying = isThisActive && (state?.playing ?? false);
        final isBuffering =
            isThisActive &&
            (state?.processingState == ProcessingState.loading ||
                state?.processingState == ProcessingState.buffering);

        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Baris kontrol ─────────────────
              Row(
                children: [
                  // Play/Pause
                  IconButton(
                    onPressed: isBuffering
                        ? null
                        : () => _service.toggle(widget.url),
                    icon: isBuffering
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            size: 32,
                            color: Colors.blue,
                          ),
                    tooltip: isPlaying ? 'Pause' : 'Putar',
                  ),

                  // Skip -10s
                  if (isThisActive)
                    IconButton(
                      iconSize: 22,
                      onPressed: () {
                        final pos = _service.player.position;
                        final target = pos - const Duration(seconds: 10);
                        _service.seek(
                          target < Duration.zero ? Duration.zero : target,
                        );
                      },
                      icon: const Icon(Icons.replay_10),
                      tooltip: 'Mundur 10 detik',
                    ),

                  // Skip +10s
                  if (isThisActive)
                    IconButton(
                      iconSize: 22,
                      onPressed: () {
                        final pos = _service.player.position;
                        final dur = _service.player.duration ?? Duration.zero;
                        final target = pos + const Duration(seconds: 10);
                        _service.seek(target > dur ? dur : target);
                      },
                      icon: const Icon(Icons.forward_10),
                      tooltip: 'Maju 10 detik',
                    ),

                  const SizedBox(width: 4),

                  // Judul
                  Expanded(
                    child: Text(
                      isThisActive ? 'Sedang diputar' : 'Putar audio sidang',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isThisActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: Colors.blue.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Stop (hanya saat aktif)
                  if (isThisActive)
                    IconButton(
                      iconSize: 20,
                      onPressed: () => _service.stop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Tutup',
                    ),
                ],
              ),

              // ── Progress bar (hanya saat aktif) ──
              if (isThisActive) _buildProgressBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: _service.positionStream,
      builder: (context, posSnap) {
        final position = _dragValue ?? posSnap.data ?? Duration.zero;
        final duration = _service.player.duration ?? Duration.zero;

        final safePosition = position > duration ? duration : position;
        final maxMs = duration.inMilliseconds.toDouble();
        final valueMs = safePosition.inMilliseconds
            .clamp(0, duration.inMilliseconds)
            .toDouble();

        return Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 12,
                  ),
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Colors.blue.shade100,
                  thumbColor: Colors.blue,
                ),
                child: Slider(
                  min: 0,
                  max: maxMs <= 0 ? 1 : maxMs,
                  value: maxMs <= 0 ? 0 : valueMs,
                  onChanged: maxMs <= 0
                      ? null
                      : (v) => setState(() {
                          _dragValue = Duration(milliseconds: v.toInt());
                        }),
                  onChangeEnd: (v) async {
                    await _service.seek(Duration(milliseconds: v.toInt()));
                    if (mounted) {
                      setState(() => _dragValue = null);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(safePosition),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}
