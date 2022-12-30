class M7AssetConstants {
  static const packageName = "m7_livelyness_detection";
  static _M7LottieAssets lottie = _M7LottieAssets();
}

class _M7LottieAssets {
  String get _initPath {
    // return "packages/${M7AssetConstants.packageName}/lib/src/assets/lottie";
    return "src/assets/lottie";
  }

  String get livelynessStart {
    return "$_initPath/livelyness-start.json";
  }

  String get livelynessSuccess {
    return "$_initPath/livelyness-success.json";
  }

  String get stepCompleted {
    return "$_initPath/step_completed.json";
  }
}
