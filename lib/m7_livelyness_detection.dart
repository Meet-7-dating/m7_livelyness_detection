import 'package:m7_livelyness_detection/index.dart';

export './src/index.dart';

class M7LivelynessDetection {
  //* MARK: - Converting Package to Singleton
  //? =========================================================
  M7LivelynessDetection._privateConstructor();

  static final M7LivelynessDetection instance =
      M7LivelynessDetection._privateConstructor();

  //* MARK: - Public Methods
  //? =========================================================

  /// A single line functoin to detect weather the face is live or not.
  /// Parameters: -
  /// * context: - Positional Parameter that will accept a `BuildContext` using which it will redirect the a new screen.
  /// * config: - Accepts a `M7DetectionConfig` object which will hold all the setup config of the package.
  Future<String?> detectLivelyness(
    BuildContext context, {
    required M7DetectionConfig config,
  }) async {
    final String? capturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => M7LivelynessDetectionScreen(
          config: config,
        ),
      ),
    );
    return capturedFacePath;
  }
}
