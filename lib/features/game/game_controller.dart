import 'dart:async';
import 'dart:collection';

import 'package:app_ran_san_moi/data/models/direction.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:app_ran_san_moi/data/models/grid_point.dart';
import 'package:app_ran_san_moi/features/game/snake_game.dart';
import 'package:flutter/foundation.dart';

class GameController extends ChangeNotifier {
  GameController({SnakeGame? game, this.onStart, this.onEat, this.onGameOver})
    : _game = game ?? SnakeGame();

  final SnakeGame _game;
  final VoidCallback? onStart;
  final VoidCallback? onEat;
  final VoidCallback? onGameOver;
  Timer? _timer;

  UnmodifiableListView<GridPoint> get snake => _game.snake;
  GridPoint get food => _game.food;
  Direction get direction => _game.direction;
  GameStatus get status => _game.status;
  int get score => _game.score;

  void start() {
    if (_game.status == GameStatus.paused) {
      resume();
      return;
    }
    if (_game.status == GameStatus.playing) {
      return;
    }
    _game.start();
    onStart?.call();
    _scheduleNextTick();
    notifyListeners();
  }

  void pause() {
    if (_game.status != GameStatus.playing) {
      return;
    }
    _game.pause();
    _cancelTimer();
    notifyListeners();
  }

  void resume() {
    if (_game.status != GameStatus.paused) {
      return;
    }
    _game.resume();
    _scheduleNextTick();
    notifyListeners();
  }

  void togglePause() {
    if (_game.status == GameStatus.playing) {
      pause();
    } else if (_game.status == GameStatus.paused) {
      resume();
    }
  }

  void restart() {
    _cancelTimer();
    _game.reset();
    start();
  }

  void changeDirection(Direction newDirection) {
    _game.changeDirection(newDirection);
  }

  void _scheduleNextTick() {
    _cancelTimer();
    _timer = Timer(Duration(milliseconds: _game.tickMs), _onTick);
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTick() {
    final ate = _game.tick();
    final status = _game.status;

    if (status == GameStatus.playing) {
      _scheduleNextTick();
    }
    notifyListeners();

    if (ate) {
      onEat?.call();
    }
    if (status == GameStatus.gameOver) {
      onGameOver?.call();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
