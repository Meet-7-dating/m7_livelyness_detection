import 'package:m7_livelyness_detection/index.dart';

class M7Utils {
  static Point<int> middlePoint({
    required Point<int> from,
    required Point<int> to,
  }) {
    final int p0 = from.x;
    final int p1 = from.y;
    final int q0 = to.x;
    final int q1 = to.y;

    return Point<int>(
      (p0 + q0) ~/ 2,
      (p1 + q1) ~/ 2,
    );
  }

  static String generate() {
    return const Uuid().v4();
  }
}
