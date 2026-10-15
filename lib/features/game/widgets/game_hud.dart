import 'package:app_ran_san_moi/core/utils/app_colors.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:flutter/material.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.score,
    required this.status,
    required this.onTogglePause,
  });

  final int score;
  final GameStatus status;
  final VoidCallback onTogglePause;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canPause =
        status == GameStatus.playing || status == GameStatus.paused;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SCORE', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                score.toString().padLeft(4, '0'),
                style: textTheme.headlineMedium,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: canPause ? onTogglePause : null,
            iconSize: 32,
            color: AppColors.textPrimary,
            icon: Icon(
              status == GameStatus.paused ? Icons.play_arrow : Icons.pause,
            ),
          ),
        ],
      ),
    );
  }
}
