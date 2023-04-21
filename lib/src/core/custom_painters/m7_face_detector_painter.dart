//sky_engine/lib/ui/painting.dart
import 'package:m7_livelyness_detection/index.dart';

class M7FaceDetectorPainter extends CustomPainter {
  M7FaceDetectorPainter(
    this.face,
    this.absoluteImageSize,
    this.rotation,
  );

  final Face face;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = M7LivelynessDetection.instance.contourLineColor ??
          const Color(0xffab48e0);

    void paintContour(FaceContourType type) {
      final faceContour = face.contours[type];
      if (faceContour?.points != null) {
        for (var i = 0; i < faceContour!.points.length; i++) {
          final Point<int> p1 = faceContour.points[i];
          if (i + 1 < faceContour.points.length) {
            final Point<int> p2 = faceContour.points[i + 1];
            canvas.drawLine(
              Offset(
                M7MathHelper.instance.translateX(
                  p1.x.toDouble(),
                  rotation,
                  size,
                  absoluteImageSize,
                ),
                M7MathHelper.instance.translateY(
                  p1.y.toDouble(),
                  rotation,
                  size,
                  absoluteImageSize,
                ),
              ),
              Offset(
                M7MathHelper.instance.translateX(
                  p2.x.toDouble(),
                  rotation,
                  size,
                  absoluteImageSize,
                ),
                M7MathHelper.instance.translateY(
                  p2.y.toDouble(),
                  rotation,
                  size,
                  absoluteImageSize,
                ),
              ),
              paint,
            );
          }
        }
        for (final Point point in faceContour.points) {
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

  @override
  bool shouldRepaint(M7FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.face != face;
  }
}

//! TODO: - Kept for future release
//? =========================================================
// class M7MeshPainter extends CustomPainter {
//   M7MeshPainter(
//     this.face,
//     this.absoluteImageSize,
//     this.rotation,
//   );

//   final Face face;
//   final Size absoluteImageSize;
//   final InputImageRotation rotation;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0
//       ..color = const Color(0xffab48e0);

//     final Paint paint2 = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.red;

//     void paintContour(FaceContourType type) {
//       final faceContour = face.contours[type];
//       if (faceContour?.points != null) {
//         for (final Point point in faceContour!.points) {
//           canvas.drawCircle(
//             Offset(
//               M7MathHelper.instance.translateX(
//                 point.x.toDouble(),
//                 rotation,
//                 size,
//                 absoluteImageSize,
//               ),
//               M7MathHelper.instance.translateY(
//                 point.y.toDouble(),
//                 rotation,
//                 size,
//                 absoluteImageSize,
//               ),
//             ),
//             1,
//             paint,
//           );
//         }
//       }
//     }

//     void dwarLine({
//       required int px,
//       required int py,
//       required int qx,
//       required int qy,
//     }) {
//       canvas.drawLine(
//         Offset(
//           M7MathHelper.instance.translateX(
//             px.toDouble(),
//             rotation,
//             size,
//             absoluteImageSize,
//           ),
//           M7MathHelper.instance.translateY(
//             py.toDouble(),
//             rotation,
//             size,
//             absoluteImageSize,
//           ),
//         ),
//         Offset(
//           M7MathHelper.instance.translateX(
//             qx.toDouble(),
//             rotation,
//             size,
//             absoluteImageSize,
//           ),
//           M7MathHelper.instance.translateY(
//             qy.toDouble(),
//             rotation,
//             size,
//             absoluteImageSize,
//           ),
//         ),
//         paint2,
//       );
//     }

//     final List<Point<int>> faceEdges =
//         face.contours[FaceContourType.face]?.points ?? [];

//     //* MARK: - Left Side
//     //? =========================================================
//     final List<Point<int>> leftEyebrowBottom =
//         face.contours[FaceContourType.leftEyebrowBottom]?.points ?? [];
//     final List<Point<int>> leftEyebrowTop =
//         face.contours[FaceContourType.leftEyebrowTop]?.points ?? [];
//     final List<Point<int>> leftEye =
//         face.contours[FaceContourType.leftEye]?.points ?? [];
//     final List<Point<int>> leftCheek =
//         face.contours[FaceContourType.leftCheek]?.points ?? [];

//     //* MARK: - Right Side
//     //? =========================================================
//     final List<Point<int>> rightEyebrowTop =
//         face.contours[FaceContourType.rightEyebrowTop]?.points ?? [];
//     final List<Point<int>> rightEyebrowBottom =
//         face.contours[FaceContourType.rightEyebrowBottom]?.points ?? [];
//     final List<Point<int>> rightEye =
//         face.contours[FaceContourType.rightEye]?.points ?? [];
//     final List<Point<int>> rightCheek =
//         face.contours[FaceContourType.rightCheek]?.points ?? [];

//     //* MARK: - Nose
//     //? =========================================================
//     final List<Point<int>> noseBottom =
//         face.contours[FaceContourType.noseBottom]?.points ?? [];
//     final List<Point<int>> noseBridge =
//         face.contours[FaceContourType.noseBridge]?.points ?? [];

//     //* MARK: - Lips
//     //? =========================================================
//     final List<Point<int>> upperLipTop =
//         face.contours[FaceContourType.upperLipTop]?.points ?? [];
//     final List<Point<int>> upperLipBottom =
//         face.contours[FaceContourType.upperLipBottom]?.points ?? [];

//     final List<Point<int>> lowerLipTop =
//         face.contours[FaceContourType.lowerLipTop]?.points ?? [];
//     final List<Point<int>> lowerLipBottom =
//         face.contours[FaceContourType.lowerLipBottom]?.points ?? [];

//     final List<List<Point<int>>> partitions = faceEdges.splitInChunks(
//       chunkSize: faceEdges.length ~/ 4,
//     );
//     if (partitions.length != 4) {
//       return;
//     }

//     //* MARK: - Top Right
//     //? =========================================================
//     final List<Point<int>> topRightFaceEdges = partitions[0];
//     if (topRightFaceEdges.length == 9) {
//       final List<Point<int>> rightEyebrowTopR =
//           rightEyebrowTop.reversed.toList();
//       for (var i = 0; i < rightEyebrowTopR.length; i++) {
//         final p0 = rightEyebrowTopR[i];
//         final p1 = topRightFaceEdges[i];
//         dwarLine(
//           px: p0.x,
//           py: p0.y,
//           qx: p1.x,
//           qy: p1.y,
//         );
//       }
//     }

//     //* MARK: - Bottom Right
//     //? =========================================================
//     final List<Point<int>> bottomRightFaceEdges = partitions[1];
//     if (bottomRightFaceEdges.length == 9) {
//       final List<Point<int>> rightEyeBottom = rightEye
//           .splitInChunks(
//             chunkSize: rightEye.length ~/ 2,
//           )
//           .last;

//       for (var i = 0; i < rightEyeBottom.length; i++) {
//         final p0 = M7Utils.middlePoint(
//           from: rightEyeBottom[i],
//           to: bottomRightFaceEdges[i],
//         );
//         final p1 = bottomRightFaceEdges[i];
//         dwarLine(
//           px: p0.x,
//           py: p0.y,
//           qx: p1.x,
//           qy: p1.y,
//         );
//         if (i != rightEye.length - 1) {
//           final p2 = rightEyeBottom[i + 1];
//           dwarLine(
//             px: p0.x,
//             py: p0.y,
//             qx: p2.x,
//             qy: p2.y,
//           );
//         }
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(M7MeshPainter oldDelegate) {
//     return oldDelegate.absoluteImageSize != absoluteImageSize ||
//         oldDelegate.face != face;
//   }
// }
