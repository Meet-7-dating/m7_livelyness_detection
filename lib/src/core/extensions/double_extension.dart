extension M7LDDoubleExtension on double {
  bool get isEven {
    return round() % 2 == 0;
  }

  bool get isOdd {
    return round() % 2 == 1;
  }
}
