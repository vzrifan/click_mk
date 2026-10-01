import 'package:click_mk/core/audio/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RisalahAudioButton extends StatefulWidget {
  const RisalahAudioButton({
    super.key,
    required this.url,
    this.isCompact = true,
  });

  final String url;

  /// Kalau true, tampilkan hanya ikon. Kalau false, tampilkan ikon + label.
  final bool isCompact;

  @override
  State<RisalahAudioButton> createState() => _RisalahAudioButtonState();
}

class _RisalahAudioButtonState extends State<RisalahAudioButton> {
  final _service = AudioPlayerService.instance;

  bool get _isCurrent => _service.currentUrl == widget.url;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _service.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying =
            _isCurrent &&
            playerState != null &&
            playerState.playing &&
            playerState.processingState != ProcessingState.completed;

        if (widget.isCompact) {
          return IconButton(
            onPressed: _onPressed,
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 28,
              color: Colors.blue,
            ),
            tooltip: isPlaying ? 'Pause' : 'Putar',
          );
        }

        return FilledButton.icon(
          onPressed: _onPressed,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 16),
          label: Text(
            isPlaying ? 'Pause' : 'Putar',
            style: const TextStyle(fontSize: 12),
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
            minimumSize: const Size(0, 36),
          ),
        );
      },
    );
  }

  Future<void> _onPressed() async {
    await _service.toggle(widget.url);
    if (mounted) setState(() {});
  }
}
