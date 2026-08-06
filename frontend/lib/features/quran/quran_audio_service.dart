import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Streams and downloads per-surah recitation audio by Saad Al-Ghamdi from
/// mp3quran.net (reciter id 30, "Rewayat Hafs A'n Assem" moshaf, server
/// `server7.mp3quran.net/s_gmd/`) — a free, no-API-key, CORS-open public
/// Quran audio CDN, verified to serve all 114 surahs as
/// `{surahNumber zero-padded to 3 digits}.mp3` (e.g. `001.mp3`). See
/// content/seed/SOURCES.md for how this was confirmed.
///
/// Downloading to a local file for offline playback only makes sense on
/// platforms with real filesystem access — on web, [isDownloaded] always
/// reports false and [download] is a no-op; [audioUrlForSurah] still
/// works everywhere since `audioplayers` can stream a URL directly on web
/// too.
class QuranAudioService {
  static const _baseUrl = 'https://server7.mp3quran.net/s_gmd/';

  String _fileName(int surahNumber) => '${surahNumber.toString().padLeft(3, '0')}.mp3';

  String audioUrlForSurah(int surahNumber) => '$_baseUrl${_fileName(surahNumber)}';

  Future<Directory> _audioDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${docsDir.path}/quran_audio');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _localFile(int surahNumber) async {
    final dir = await _audioDirectory();
    return File('${dir.path}/${_fileName(surahNumber)}');
  }

  Future<bool> isDownloaded(int surahNumber) async {
    if (kIsWeb) return false;
    final file = await _localFile(surahNumber);
    return file.exists();
  }

  /// The local file path if this surah has already been downloaded, else
  /// null (including always on web).
  Future<String?> localPathIfDownloaded(int surahNumber) async {
    if (kIsWeb) return null;
    final file = await _localFile(surahNumber);
    return (await file.exists()) ? file.path : null;
  }

  /// Downloads the surah's audio to local storage, yielding progress from
  /// 0.0 to 1.0. Streamed to disk rather than buffered in memory, since
  /// the longer surahs are tens of megabytes (Al-Baqarah is ~85MB).
  Stream<double> download(int surahNumber) async* {
    if (kIsWeb) return;

    final request = http.Request('GET', Uri.parse(audioUrlForSurah(surahNumber)));
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Download failed: HTTP ${response.statusCode}');
    }

    final contentLength = response.contentLength ?? 0;
    final file = await _localFile(surahNumber);
    final sink = file.openWrite();
    var received = 0;

    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (contentLength > 0) yield received / contentLength;
      }
    } catch (e) {
      await sink.close();
      if (await file.exists()) await file.delete();
      rethrow;
    }

    await sink.close();
  }

  Future<void> deleteDownload(int surahNumber) async {
    if (kIsWeb) return;
    final file = await _localFile(surahNumber);
    if (await file.exists()) await file.delete();
  }
}
