import 'package:app_ran_san_moi/data/models/direction.dart';

class GridPoint {
  const GridPoint(this.x, this.y);

  final int x;
  final int y;

  GridPoint moved(Direction direction) {
    return GridPoint(x + direction.dx, y + direction.dy);
  }

  @override
  bool operator ==(Object other) {
    return other is GridPoint && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'GridPoint($x, $y)';
}
