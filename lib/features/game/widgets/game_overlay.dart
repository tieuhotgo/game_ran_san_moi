import 'package:app_ran_san_moi/core/utils/app_colors.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:flutter/material.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay({
    super.key,
    required this.status,
    required this.score,
    required this.onStart,
    required this.onResume,
    required this.onRestart,
  });

  final GameStatus status;
  final int score;
  final VoidCallback onStart;
  final VoidCallback onResume;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      GameStatus.playing => const SizedBox.shrink(),
      GameStatus.ready => _panel(
          context,
          title: 'SNAKE',
          subtitle: 'ARROWS OR SWIPE',
          buttonLabel: 'START',
          onPressed: onStart,
        ),
      GameStatus.paused => _panel(
          context,
          title: 'PAUSED',
          subtitle: 'SCORE $score',
          buttonLabel: 'RESUME',
          onPressed: onResume,
        ),
      GameStatus.gameOver => _panel(
          context,
          title: 'GAME OVER',
          subtitle: 'SCORE $score',
          buttonLabel: 'PLAY AGAIN',
          onPressed: onRestart,
        ),
    };
  }

  Widget _panel(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.overlay,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title, style: textTheme.headlineMedium),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(subtitle, style: textTheme.bodyMedium),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onPressed, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}
