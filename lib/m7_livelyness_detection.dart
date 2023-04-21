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
  Color? _contourLineColor;
  Color? _contourDotColor;
  double? _contourDotRadius;
  double? _contourLineWidth;
  bool _displayLines = true;
  bool _displayDots = true;
  List<double>? _dashValues;

  late EdgeInsets _safeAreaPadding;

  //* MARK: - Public Variables
  //? =========================================================
  List<M7DetectionThreshold> get thresholdConfig {
    return _thresholds;
  }

  EdgeInsets get safeAreaPadding {
    return _safeAreaPadding;
  }

  Color? get contourLineColor {
    return _contourLineColor;
  }

  Color? get contourDotColor {
    return _contourDotColor;
  }

  double? get contourDotRadius {
    return _contourDotRadius;
  }

  double? get contourLineWidth {
    return _contourLineWidth;
  }

  bool get displayLines {
    return _displayLines;
  }

  bool get displayDots {
    return _displayDots;
  }

  bool get displayDash {
    return _dashValues != null && _dashValues!.length == 2;
  }

  double get dashLength {
    return _dashValues?[0] ?? 5;
  }

  double get dashGap {
    return _dashValues?[1] ?? 5;
  }

  //* MARK: - Public Methods
  //? =========================================================

  /// A single line functoin to detect weather the face is live or not.
  /// Parameters: -
  /// * context: - Positional Parameter that will accept a `BuildContext` using which it will redirect the a new screen.
  /// * config: - Accepts a `M7DetectionConfig` object which will hold all the setup config of the package.
  Future<M7CapturedImage?> detectLivelyness(
    BuildContext context, {
    required M7DetectionConfig config,
  }) async {
    _safeAreaPadding = MediaQuery.of(context).padding;
    final M7CapturedImage? capturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => M7LivelynessDetectionPageV2(
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
    Color lineColor = const Color(0xffab48e0),
    Color dotColor = const Color(0xffab48e0),
    double lineWidth = 1.6,
    double dotSize = 2.0,
    bool displayLines = true,
    bool displayDots = true,
    List<double>? dashValues,
  }) {
    assert(
      thresholds.isNotEmpty,
      "Threshold configuration cannot be empty",
    );
    assert(
      _dashValues == null || _dashValues!.length == 2,
      "Dash values must be of length 2",
    );
    _thresholds.clear();
    _thresholds.addAll(thresholds);
    _contourLineColor = lineColor;
    _contourDotColor = dotColor;
    _contourDotRadius = dotSize;
    _contourLineWidth = lineWidth;
    _displayLines = displayLines;
    _displayDots = displayDots;
    _dashValues = dashValues;
  }
}
