import 'package:app_ran_san_moi/core/utils/app_colors.dart';
import 'package:app_ran_san_moi/data/models/direction.dart';
import 'package:app_ran_san_moi/data/models/game_status.dart';
import 'package:app_ran_san_moi/features/game/game_controller.dart';
import 'package:app_ran_san_moi/features/game/widgets/board_painter.dart';
import 'package:app_ran_san_moi/features/game/widgets/game_hud.dart';
import 'package:app_ran_san_moi/features/game/widgets/game_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  static const double _swipeThreshold = 16;

  late final GameController _controller;
  final FocusNode _focusNode = FocusNode();
  Offset _swipeDelta = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _controller.pause();
    }
  }

  void _run(VoidCallback action) {
    action();
    _focusNode.requestFocus();
  }

  Direction? _directionForKey(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      return Direction.up;
    }
    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      return Direction.down;
    }
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.keyA) {
      return Direction.left;
    }
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyD) {
      return Direction.right;
    }
    return null;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final direction = _directionForKey(key);
    if (direction != null) {
      _controller.changeDirection(direction);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.enter) {
      _onActionKey();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.keyP) {
      _controller.togglePause();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _onActionKey() {
    switch (_controller.status) {
      case GameStatus.ready:
        _controller.start();
      case GameStatus.gameOver:
        _controller.restart();
      case GameStatus.playing:
      case GameStatus.paused:
        _controller.togglePause();
    }
  }

  void _onPanStart(DragStartDetails details) {
    _swipeDelta = Offset.zero;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _swipeDelta += details.delta;
    if (_swipeDelta.distance < _swipeThreshold) {
      return;
    }

    final isHorizontal = _swipeDelta.dx.abs() > _swipeDelta.dy.abs();
    final Direction direction;
    if (isHorizontal) {
      direction = _swipeDelta.dx > 0 ? Direction.right : Direction.left;
    } else {
      direction = _swipeDelta.dy > 0 ? Direction.down : Direction.up;
    }

    _controller.changeDirection(direction);
    _swipeDelta = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        child: Scaffold(
          body: SafeArea(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  children: [
                    GameHud(
                      score: _controller.score,
                      status: _controller.status,
                      onTogglePause: () => _run(_controller.togglePause),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: _buildBoard(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.snakeBody, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: BoardPainter(
                snake: _controller.snake,
                food: _controller.food,
              ),
            ),
            GameOverlay(
              status: _controller.status,
              score: _controller.score,
              onStart: () => _run(_controller.start),
              onResume: () => _run(_controller.resume),
              onRestart: () => _run(_controller.restart),
            ),
          ],
        ),
      ),
    );
  }
}
