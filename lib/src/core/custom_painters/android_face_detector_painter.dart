import 'package:m7_livelyness_detection/index.dart';

class M7AndroidFaceDetectorPainter extends CustomPainter {
  final FaceDetectionModel model;
  final PreviewSize previewSize;
  final Rect previewRect;
  final bool isBackCamera;
  final Color? detectionColor;

  M7AndroidFaceDetectorPainter({
    required this.model,
    required this.previewSize,
    required this.previewRect,
    required this.isBackCamera,
    this.detectionColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final croppedSize = model.croppedSize;

    final ratioAnalysisToPreview = previewSize.width / croppedSize.width;

    bool flipXY = false;
    if (Platform.isAndroid) {
      // Symmetry for Android since native image analysis is not mirrored but preview is
      // It also handles device rotation
      switch (model.imageRotation) {
        case InputImageRotation.rotation0deg:
          if (isBackCamera) {
            flipXY = true;
            canvas.scale(-1, 1);
            canvas.translate(-size.width, 0);
          } else {
            flipXY = true;
            canvas.scale(-1, -1);
            canvas.translate(-size.width, -size.height);
          }
          break;
        case InputImageRotation.rotation90deg:
          if (isBackCamera) {
            // No changes
          } else {
            canvas.scale(1, -1);
            canvas.translate(0, -size.height);
          }
          break;
        case InputImageRotation.rotation180deg:
          if (isBackCamera) {
            flipXY = true;
            canvas.scale(1, -1);
            canvas.translate(0, -size.height);
          } else {
            flipXY = true;
          }
          break;
        default:
          // 270 or null
          if (isBackCamera) {
            canvas.scale(-1, -1);
            canvas.translate(-size.width, -size.height);
          } else {
            canvas.scale(-1, 1);
            canvas.translate(-size.width, 0);
          }
      }
    }

    for (final Face face in model.faces) {
      Map<FaceContourType, Path> paths = {
        for (var fct in FaceContourType.values) fct: Path()
      };
      face.contours.forEach((contourType, faceContour) {
        if (faceContour != null) {
          paths[contourType]!.addPolygon(
              faceContour.points
                  .map(
                    (element) => _croppedPosition(
                      element,
                      croppedSize: croppedSize,
                      painterSize: size,
                      ratio: ratioAnalysisToPreview,
                      flipXY: flipXY,
                    ),
                  )
                  .toList(),
              true);
          for (var element in faceContour.points) {
            canvas.drawCircle(
              _croppedPosition(
                element,
                croppedSize: croppedSize,
                painterSize: size,
                ratio: ratioAnalysisToPreview,
                flipXY: flipXY,
              ),
              4,
              Paint()
                ..color = detectionColor ??
                    M7LivelynessDetection.instance.contourDotColor ??
                    Colors.purple.shade800
                ..strokeWidth =
                    M7LivelynessDetection.instance.contourDotRadius ?? 2,
            );
          }
        }
      });
      paths.removeWhere((key, value) => value.getBounds().isEmpty);
      for (var p in paths.entries) {
        canvas.drawPath(
          p.value,
          Paint()
            ..color = detectionColor ??
                M7LivelynessDetection.instance.contourLineColor ??
                Colors.white
            ..strokeWidth =
                M7LivelynessDetection.instance.contourLineWidth ?? 1.6
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(M7AndroidFaceDetectorPainter oldDelegate) {
    return oldDelegate.isBackCamera != isBackCamera ||
        oldDelegate.previewSize.width != previewSize.width ||
        oldDelegate.previewSize.height != previewSize.height ||
        oldDelegate.previewRect != previewRect ||
        oldDelegate.model != model;
  }

  Offset _croppedPosition(
    Point<int> element, {
    required Size croppedSize,
    required Size painterSize,
    required double ratio,
    required bool flipXY,
  }) {
    num imageDiffX;
    num imageDiffY;
    if (Platform.isIOS) {
      imageDiffX = model.absoluteImageSize.width - croppedSize.width;
      imageDiffY = model.absoluteImageSize.height - croppedSize.height;
    } else {
      imageDiffX = model.absoluteImageSize.height - croppedSize.width;
      imageDiffY = model.absoluteImageSize.width - croppedSize.height;
    }

    return (Offset(
              (flipXY ? element.y : element.x).toDouble() - (imageDiffX / 2),
              (flipXY ? element.x : element.y).toDouble() - (imageDiffY / 2),
            ) *
            ratio)
        .translate(
      (painterSize.width - (croppedSize.width * ratio)) / 2,
      (painterSize.height - (croppedSize.height * ratio)) / 2,
    );
  }
}
