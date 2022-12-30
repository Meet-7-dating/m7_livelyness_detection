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
  Future<String?> detectLivelyness(
    BuildContext context, {
    required M7DetectionConfig config,
  }) async {
    final String? imgPath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => M7LivelynessDetectionScreen(
          config: config,
        ),
      ),
    );
    return imgPath;
  }
}
