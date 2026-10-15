import 'package:app_ran_san_moi/core/utils/app_colors.dart';
import 'package:app_ran_san_moi/core/utils/game_constants.dart';
import 'package:app_ran_san_moi/data/models/grid_point.dart';
import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter {
  const BoardPainter({required this.snake, required this.food});

  final List<GridPoint> snake;
  final GridPoint food;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / GameConstants.columns;
    final cellHeight = size.height / GameConstants.rows;

    _paintBoard(canvas, cellWidth, cellHeight);
    _paintFood(canvas, cellWidth, cellHeight);
    _paintSnake(canvas, cellWidth, cellHeight);
  }

  void _paintBoard(Canvas canvas, double cellWidth, double cellHeight) {
    final light = Paint()..color = AppColors.boardLight;
    final dark = Paint()..color = AppColors.boardDark;

    for (var y = 0; y < GameConstants.rows; y++) {
      for (var x = 0; x < GameConstants.columns; x++) {
        final rect = Rect.fromLTRB(
          x * cellWidth,
          y * cellHeight,
          (x + 1) * cellWidth,
          (y + 1) * cellHeight,
        );
        canvas.drawRect(rect, (x + y).isEven ? light : dark);
      }
    }
  }

  void _paintFood(Canvas canvas, double cellWidth, double cellHeight) {
    final center = Offset(
      (food.x + 0.5) * cellWidth,
      (food.y + 0.5) * cellHeight,
    );
    final radius = Size(cellWidth, cellHeight).shortestSide * 0.38;
    canvas.drawCircle(center, radius, Paint()..color = AppColors.food);
  }

  void _paintSnake(Canvas canvas, double cellWidth, double cellHeight) {
    final headPaint = Paint()..color = AppColors.snakeHead;
    final bodyPaint = Paint()..color = AppColors.snakeBody;
    final inset = cellWidth * 0.08;
    final radius = Radius.circular(cellWidth * 0.25);

    for (var i = snake.length - 1; i >= 0; i--) {
      final p = snake[i];
      final rect = Rect.fromLTRB(
        p.x * cellWidth + inset,
        p.y * cellHeight + inset,
        (p.x + 1) * cellWidth - inset,
        (p.y + 1) * cellHeight - inset,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        i == 0 ? headPaint : bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) => true;
}
