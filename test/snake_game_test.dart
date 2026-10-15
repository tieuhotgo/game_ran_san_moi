import 'dart:math';

import 'package:app_ran_san_moi/core/utils/game_constants.dart';
import 'package:app_ran_san_moi/data/models/direction.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:app_ran_san_moi/data/models/grid_point.dart';
import 'package:app_ran_san_moi/features/game/snake_game.dart';
import 'package:flutter_test/flutter_test.dart';

SnakeGame newGame() => SnakeGame(random: Random(1));

void eatAhead(SnakeGame game, int times) {
  for (var i = 0; i < times; i++) {
    game.placeFood(game.head.moved(Direction.right));
    expect(game.tick(), isTrue);
  }
}

void main() {
  test('trang thai ban dau', () {
    final game = newGame();
    expect(game.status, GameStatus.ready);
    expect(game.snake.length, GameConstants.initialSnakeLength);
    expect(
      game.head,
      const GridPoint(GameConstants.columns ~/ 2, GameConstants.rows ~/ 2),
    );
    expect(game.score, 0);
    expect(game.snake.contains(game.food), isFalse);
  });

  test('chua start thi tick khong lam gi', () {
    final game = newGame();
    final before = game.head;
    game.tick();
    expect(game.head, before);
  });

  test('ran di sang phai 1 o moi tick', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    final before = game.head;
    game.start();
    game.tick();
    expect(game.head, GridPoint(before.x + 1, before.y));
    expect(game.snake.length, GameConstants.initialSnakeLength);
  });

  test('khong cho quay dau 180 do', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    game.start();
    game.changeDirection(Direction.left);
    game.tick();
    expect(game.direction, Direction.right);
  });

  test('bam nhanh 2 phim trong 1 tick van nhan du', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    game.start();
    game.changeDirection(Direction.up);
    game.changeDirection(Direction.left);
    game.tick();
    expect(game.direction, Direction.up);
    game.tick();
    expect(game.direction, Direction.left);
  });

  test('phim nguoc voi phim vua bam thi bo qua', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    game.start();
    game.changeDirection(Direction.up);
    game.changeDirection(Direction.down);
    game.tick();
    game.tick();
    expect(game.direction, Direction.up);
  });

  test('bo dem day thi bo bot phim thua', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    game.start();
    game.changeDirection(Direction.up);
    game.changeDirection(Direction.left);
    game.changeDirection(Direction.down);
    game.changeDirection(Direction.right);
    for (var i = 0; i < 4; i++) {
      game.tick();
    }
    expect(game.direction, Direction.down);
    expect(game.status, GameStatus.playing);
  });

  test('dam tuong thi thua', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    game.start();
    var ticks = 0;
    while (game.status == GameStatus.playing && ticks < 100) {
      game.tick();
      ticks++;
    }
    expect(game.status, GameStatus.gameOver);
    expect(ticks, lessThan(100));
  });

  test('an moi thi dai ra, cong diem, tang toc', () {
    final game = newGame();
    game.start();
    eatAhead(game, GameConstants.foodsPerSpeedUp);
    expect(game.snake.length, GameConstants.initialSnakeLength + 3);
    expect(game.score, GameConstants.pointsPerFood * 3);
    expect(game.tickMs, GameConstants.initialTickMs - GameConstants.tickStepMs);
  });

  test('can vao than thi thua', () {
    final game = newGame();
    game.start();
    eatAhead(game, 3);
    game.placeFood(const GridPoint(0, 0));
    game.changeDirection(Direction.up);
    game.tick();
    game.changeDirection(Direction.left);
    game.tick();
    game.changeDirection(Direction.down);
    game.tick();
    expect(game.status, GameStatus.gameOver);
  });

  test('pause roi resume', () {
    final game = newGame();
    game.start();
    game.togglePause();
    expect(game.status, GameStatus.paused);
    game.togglePause();
    expect(game.status, GameStatus.playing);
  });

  test('start lai sau game over thi reset', () {
    final game = newGame();
    game.placeFood(const GridPoint(0, 0));
    game.start();
    while (game.status == GameStatus.playing) {
      game.tick();
    }
    game.start();
    expect(game.status, GameStatus.playing);
    expect(game.score, 0);
    expect(game.snake.length, GameConstants.initialSnakeLength);
  });
}
