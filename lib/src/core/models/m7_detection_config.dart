import 'package:m7_livelyness_detection/index.dart';

class M7DetectionConfig {
  final List<M7LivelynessStepItem> steps;
  final bool startWithInfoScreen;
  final int maxSecToDetect;

  M7DetectionConfig({
    required this.steps,
    this.startWithInfoScreen = false,
    this.maxSecToDetect = 15,
  });
}
