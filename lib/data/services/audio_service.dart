import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static const String _eatAsset = 'sounds/eating.mp3';
  static const String _startAsset = 'sounds/game_start.mp3';
  static const String _gameOverAsset = 'sounds/game_over.mp3';

  final AudioPlayer _eatPlayer = AudioPlayer();
  final AudioPlayer _startPlayer = AudioPlayer();
  final AudioPlayer _gameOverPlayer = AudioPlayer();

  bool enabled = true;

  void playEat() => unawaited(
        _play(_eatPlayer, _eatAsset, mode: PlayerMode.lowLatency),
      );

  void playStart() => unawaited(_play(_startPlayer, _startAsset));

  void playGameOver() => unawaited(_play(_gameOverPlayer, _gameOverAsset));

  Future<void> _play(
    AudioPlayer player,
    String asset, {
    PlayerMode? mode,
  }) async {
    if (!enabled) {
      return;
    }
    try {
      await player.stop();
      await player.play(AssetSource(asset), mode: mode);
    } catch (error) {
      debugPrint('Khong phat duoc am thanh $asset: $error');
    }
  }

  void dispose() {
    unawaited(_eatPlayer.dispose());
    unawaited(_startPlayer.dispose());
    unawaited(_gameOverPlayer.dispose());
  }
}
