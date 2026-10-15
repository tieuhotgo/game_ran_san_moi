import 'dart:math';

import 'package:app_ran_san_moi/core/utils/game_constants.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:app_ran_san_moi/data/models/grid_point.dart';
import 'package:app_ran_san_moi/features/game/game_controller.dart';
import 'package:app_ran_san_moi/features/game/snake_game.dart';
import 'package:flutter_test/flutter_test.dart';

const tick = Duration(milliseconds: GameConstants.initialTickMs);

SnakeGame newGame() {
  final game = SnakeGame(random: Random(1));
  game.placeFood(const GridPoint(0, 0));
  return game;
}

void main() {
  testWidgets('start thi timer tu dong cho ran di', (tester) async {
    final game = newGame();
    final controller = GameController(game: game);
    final before = game.head;

    controller.start();
    expect(controller.status, GameStatus.playing);

    await tester.pump(tick);
    expect(game.head, GridPoint(before.x + 1, before.y));

    await tester.pump(tick);
    expect(game.head, GridPoint(before.x + 2, before.y));

    controller.dispose();
  });

  testWidgets('pause thi ran dung, resume thi chay tiep', (tester) async {
    final game = newGame();
    final controller = GameController(game: game);

    controller.start();
    await tester.pump(tick);
    controller.pause();
    final paused = game.head;

    await tester.pump(tick * 3);
    expect(game.head, paused);
    expect(controller.status, GameStatus.paused);

    controller.resume();
    await tester.pump(tick);
    expect(game.head, GridPoint(paused.x + 1, paused.y));

    controller.dispose();
  });

  testWidgets('an moi thi goi onEat', (tester) async {
    final game = newGame();
    var eaten = 0;
    final controller = GameController(game: game, onEat: () => eaten++);

    game.placeFood(game.head.moved(game.direction));
    controller.start();
    await tester.pump(tick);

    expect(eaten, 1);
    expect(controller.score, GameConstants.pointsPerFood);

    controller.dispose();
  });

  testWidgets('dam tuong thi goi onGameOver 1 lan', (tester) async {
    final game = newGame();
    var overCount = 0;
    final controller = GameController(
      game: game,
      onGameOver: () => overCount++,
    );

    controller.start();
    await tester.pump(tick * 15);

    expect(controller.status, GameStatus.gameOver);
    expect(overCount, 1);

    controller.dispose();
  });

  testWidgets('restart sau game over thi choi lai tu dau', (tester) async {
    final game = newGame();
    final controller = GameController(game: game);

    controller.start();
    await tester.pump(tick * 15);
    expect(controller.status, GameStatus.gameOver);

    controller.restart();
    expect(controller.status, GameStatus.playing);
    expect(controller.score, 0);
    expect(controller.snake.length, GameConstants.initialSnakeLength);

    controller.dispose();
  });

  testWidgets('notifyListeners moi tick', (tester) async {
    final game = newGame();
    final controller = GameController(game: game);
    var notified = 0;
    controller.addListener(() => notified++);

    controller.start();
    final afterStart = notified;
    await tester.pump(tick);

    expect(notified, afterStart + 1);

    controller.dispose();
  });
}
