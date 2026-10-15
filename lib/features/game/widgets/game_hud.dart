import 'package:app_ran_san_moi/core/utils/app_colors.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:flutter/material.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.score,
    required this.highScore,
    required this.status,
    required this.soundEnabled,
    required this.onTogglePause,
    required this.onToggleSound,
  });

  final int score;
  final int highScore;
  final GameStatus status;
  final bool soundEnabled;
  final VoidCallback onTogglePause;
  final VoidCallback onToggleSound;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canPause =
        status == GameStatus.playing || status == GameStatus.paused;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SCORE', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(_format(score), style: textTheme.headlineMedium),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BEST', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(_format(highScore), style: textTheme.titleLarge),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onToggleSound,
            color: AppColors.textPrimary,
            icon: Icon(soundEnabled ? Icons.volume_up : Icons.volume_off),
          ),
          IconButton(
            onPressed: canPause ? onTogglePause : null,
            color: AppColors.textPrimary,
            icon: Icon(
              status == GameStatus.paused ? Icons.play_arrow : Icons.pause,
            ),
          ),
        ],
      ),
    );
  }

  String _format(int value) => value.toString().padLeft(4, '0');
}
