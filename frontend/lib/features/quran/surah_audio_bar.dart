import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'quran_audio_service.dart';

/// Play/download bar for this surah's recitation by Saad Al-Ghamdi, shown
/// above the ayah list on [SurahDetailScreen]. Streams directly from
/// mp3quran.net when just playing; downloads to local storage first when
/// the user wants offline playback (native platforms only — see
/// [QuranAudioService]).
class SurahAudioBar extends StatefulWidget {
  const SurahAudioBar({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  State<SurahAudioBar> createState() => _SurahAudioBarState();
}

class _SurahAudioBarState extends State<SurahAudioBar> {
  final _audioService = QuranAudioService();
  final _player = AudioPlayer();

  bool _isDownloaded = false;
  double? _downloadProgress; // null when not downloading
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _refreshDownloadState();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
    _player.onPositionChanged.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    _player.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });
  }

  @override
  void didUpdateWidget(covariant SurahAudioBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.surahNumber != widget.surahNumber) {
      _player.stop();
      _refreshDownloadState();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _refreshDownloadState() async {
    final downloaded = await _audioService.isDownloaded(widget.surahNumber);
    if (mounted) setState(() => _isDownloaded = downloaded);
  }

  Future<void> _play() async {
    final localPath = await _audioService.localPathIfDownloaded(widget.surahNumber);
    if (localPath != null) {
      await _player.play(DeviceFileSource(localPath));
    } else {
      await _player.play(UrlSource(_audioService.audioUrlForSurah(widget.surahNumber)));
    }
  }

  Future<void> _startDownload() async {
    setState(() => _downloadProgress = 0);
    try {
      await for (final progress in _audioService.download(widget.surahNumber)) {
        if (!mounted) return;
        setState(() => _downloadProgress = progress);
      }
      if (mounted) {
        setState(() {
          _downloadProgress = null;
          _isDownloaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _downloadProgress = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not download this recitation: $e')));
      }
    }
  }

  Future<void> _deleteDownload() async {
    await _player.stop();
    await _audioService.deleteDownload(widget.surahNumber);
    if (mounted) setState(() => _isDownloaded = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isPlaying = _playerState == PlayerState.playing;
    final isDownloading = _downloadProgress != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Recitation — Saad Al-Ghamdi',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  iconSize: 32,
                  color: colors.primary,
                  tooltip: isPlaying ? 'Pause' : 'Play',
                  onPressed: isPlaying ? _player.pause : _play,
                ),
                if (!kIsWeb)
                  if (isDownloading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(value: _downloadProgress),
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(_isDownloaded ? Icons.delete_outline : Icons.download_outlined),
                      tooltip: _isDownloaded ? 'Remove downloaded audio' : 'Download for offline listening',
                      onPressed: _isDownloaded ? _deleteDownload : _startDownload,
                    ),
              ],
            ),
            if (_duration > Duration.zero)
              Slider(
                value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
                max: _duration.inMilliseconds.toDouble(),
                onChanged: (value) => _player.seek(Duration(milliseconds: value.round())),
              ),
          ],
        ),
      ),
    );
  }
}
