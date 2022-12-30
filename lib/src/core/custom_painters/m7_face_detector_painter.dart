import 'dart:math';

import 'package:m7_livelyness_detection/index.dart';

class M7FaceDetectorPainter extends CustomPainter {
  M7FaceDetectorPainter(
    this.faces,
    this.absoluteImageSize,
    this.rotation,
  );

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xffab48e0);

    for (final Face face in faces) {
      void paintContour(FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
              Offset(
                M7MathHelper.instance.translateX(
                  point.x.toDouble(),
                  rotation,
                  size,
                  absoluteImageSize,
                ),
                M7MathHelper.instance.translateY(
                  point.y.toDouble(),
                  rotation,
                  size,
                  absoluteImageSize,
                ),
              ),
              1,
              paint,
            );
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);
    }
  }

  @override
  bool shouldRepaint(M7FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
