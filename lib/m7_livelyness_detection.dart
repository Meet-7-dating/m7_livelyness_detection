import 'package:m7_livelyness_detection/index.dart';

export './src/index.dart';

class M7LivelynessDetection {
  //* MARK: - Converting Package to Singleton
  //? =========================================================
  M7LivelynessDetection._privateConstructor();

  static final M7LivelynessDetection instance =
      M7LivelynessDetection._privateConstructor();

  //* MARK: - Private Variables
  //? =========================================================
  final List<M7DetectionThreshold> _thresholds = [];
  Color? _contourDetectionColor;

  late EdgeInsets _safeAreaPadding;

  //* MARK: - Public Variables
  //? =========================================================
  List<M7DetectionThreshold> get thresholdConfig {
    return _thresholds;
  }

  EdgeInsets get safeAreaPadding {
    return _safeAreaPadding;
  }

  Color? get contourDetectionColor {
    return _contourDetectionColor;
  }

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
    _safeAreaPadding = MediaQuery.of(context).padding;
    final String? capturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => M7LivelynessDetectionScreen(
          config: config,
        ),
      ),
    );
    return capturedFacePath;
  }

  /// Configures the shreshold values of which will be used while verfying
  /// Parameters: -
  /// * thresholds: - List of [M7DetectionThreshold] objects.
  /// * contourColor - Color of the points that are plotted on the face while detecting.
  void configure({
    required List<M7DetectionThreshold> thresholds,
    Color contourColor = const Color(0xffab48e0),
  }) {
    assert(
      thresholds.isNotEmpty,
      "Threshold configuration cannot be empty",
    );
    _thresholds.clear();
    _thresholds.addAll(thresholds);
    _contourDetectionColor = contourColor;
  }
}
