import 'dart:collection';
import 'dart:math';

import 'package:app_ran_san_moi/core/utils/game_constants.dart';
import 'package:app_ran_san_moi/data/models/direction.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:app_ran_san_moi/data/models/grid_point.dart';

class SnakeGame {
  SnakeGame({Random? random}) : _random = random ?? Random() {
    reset();
  }

  final Random _random;
  final List<GridPoint> _snake = [];
  late GridPoint _food;
  Direction _direction = Direction.right;
  final List<Direction> _pendingDirections = [];
  GameStatus _status = GameStatus.ready;
  int _score = 0;
  int _foodsEaten = 0;

  UnmodifiableListView<GridPoint> get snake => UnmodifiableListView(_snake);
  GridPoint get head => _snake.first;
  GridPoint get food => _food;
  Direction get direction => _direction;
  GameStatus get status => _status;
  int get score => _score;
  int get foodsEaten => _foodsEaten;

  int get tickMs {
    final speedUps = _foodsEaten ~/ GameConstants.foodsPerSpeedUp;
    final ms = GameConstants.initialTickMs - speedUps * GameConstants.tickStepMs;
    return max(GameConstants.minTickMs, ms);
  }

  void reset() {
    _snake.clear();
    final headX = GameConstants.columns ~/ 2;
    final headY = GameConstants.rows ~/ 2;
    for (var i = 0; i < GameConstants.initialSnakeLength; i++) {
      _snake.add(GridPoint(headX - i, headY));
    }
    _direction = Direction.right;
    _pendingDirections.clear();
    _score = 0;
    _foodsEaten = 0;
    _status = GameStatus.ready;
    _spawnFood();
  }

  void start() {
    if (_status == GameStatus.gameOver) {
      reset();
    }
    if (_status == GameStatus.ready) {
      _status = GameStatus.playing;
    }
  }

  void pause() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
    }
  }

  void resume() {
    if (_status == GameStatus.paused) {
      _status = GameStatus.playing;
    }
  }

  void togglePause() {
    if (_status == GameStatus.playing) {
      pause();
    } else if (_status == GameStatus.paused) {
      resume();
    }
  }

  void changeDirection(Direction newDirection) {
    final reference =
        _pendingDirections.isEmpty ? _direction : _pendingDirections.last;
    if (newDirection == reference || newDirection.isOppositeOf(reference)) {
      return;
    }
    if (_pendingDirections.length >= GameConstants.inputBufferSize) {
      return;
    }
    _pendingDirections.add(newDirection);
  }

  bool tick() {
    if (_status != GameStatus.playing) {
      return false;
    }

    if (_pendingDirections.isNotEmpty) {
      _direction = _pendingDirections.removeAt(0);
    }
    final newHead = head.moved(_direction);

    if (!_isInside(newHead)) {
      _status = GameStatus.gameOver;
      return false;
    }

    final willEat = newHead == _food;
    final bodyToCheck =
        willEat ? _snake : _snake.sublist(0, _snake.length - 1);

    if (bodyToCheck.contains(newHead)) {
      _status = GameStatus.gameOver;
      return false;
    }

    _snake.insert(0, newHead);

    if (!willEat) {
      _snake.removeLast();
      return false;
    }

    _foodsEaten++;
    _score += GameConstants.pointsPerFood;

    if (!_spawnFood()) {
      _status = GameStatus.gameOver;
    }
    return true;
  }

  void placeFood(GridPoint point) {
    if (_isInside(point) && !_snake.contains(point)) {
      _food = point;
    }
  }

  bool _isInside(GridPoint p) {
    return p.x >= 0 &&
        p.x < GameConstants.columns &&
        p.y >= 0 &&
        p.y < GameConstants.rows;
  }

  bool _spawnFood() {
    final freeCells = <GridPoint>[];
    for (var y = 0; y < GameConstants.rows; y++) {
      for (var x = 0; x < GameConstants.columns; x++) {
        final cell = GridPoint(x, y);
        if (!_snake.contains(cell)) {
          freeCells.add(cell);
        }
      }
    }
    if (freeCells.isEmpty) {
      return false;
    }
    _food = freeCells[_random.nextInt(freeCells.length)];
    return true;
  }
}
