import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.highScore});

  final int highScore;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/snake_logo.png', height: 180),
        const SizedBox(height: 32),
        Text('SNAKE', style: textTheme.displayLarge),
        const SizedBox(height: 16),
        Text(
          'BEST ${highScore.toString().padLeft(4, '0')}',
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }
}
