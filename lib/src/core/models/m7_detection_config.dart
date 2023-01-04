import 'package:m7_livelyness_detection/index.dart';

class M7DetectionConfig {
  /// Types of checks to be added while detecting the face.
  final List<M7LivelynessStepItem> steps;

  /// A boolean value that defines weather the detection should start with a `Info` screen or not.
  /// Default is *false*
  final bool startWithInfoScreen;

  /// Duration in which the face detection should get completed.
  /// Default is *15*
  final int maxSecToDetect;

  /// A boolean value that deinfes whether to allow the user to click the selfie even if the face is not detected.
  final bool allowAfterMaxSec;

  M7DetectionConfig({
    required this.steps,
    this.startWithInfoScreen = false,
    this.maxSecToDetect = 15,
    this.allowAfterMaxSec = false,
  }) {
    assert(
      steps.isNotEmpty,
      '''
Cannot pass an empty array of [M7LivelynessStepItem].
      ''',
    );
  }
}
