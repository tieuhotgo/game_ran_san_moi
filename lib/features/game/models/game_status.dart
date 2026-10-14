enum GameStatus {
  ready,
  playing,
  paused,
  gameOver;

  bool get isPlaying => this == GameStatus.playing;
  bool get isGameOver => this == GameStatus.gameOver;
}
