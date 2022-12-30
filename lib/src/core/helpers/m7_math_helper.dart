import 'package:m7_livelyness_detection/index.dart';

class M7MathHelper {
  //* MARK: - Converting class to Singleton
  //? =========================================================
  M7MathHelper._privateConstructor();
  static final M7MathHelper instance = M7MathHelper._privateConstructor();

  //* MARK: - Public Methods
  //? =========================================================
  double translateX(double x, InputImageRotation rotation, Size size,
      Size absoluteImageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x *
            size.width /
            (Platform.isIOS
                ? absoluteImageSize.width
                : absoluteImageSize.height);
      case InputImageRotation.rotation270deg:
        return size.width -
            x *
                size.width /
                (Platform.isIOS
                    ? absoluteImageSize.width
                    : absoluteImageSize.height);
      default:
        return x * size.width / absoluteImageSize.width;
    }
  }

  double translateY(double y, InputImageRotation rotation, Size size,
      Size absoluteImageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y *
            size.height /
            (Platform.isIOS
                ? absoluteImageSize.height
                : absoluteImageSize.width);
      default:
        return y * size.height / absoluteImageSize.height;
    }
  }
}
