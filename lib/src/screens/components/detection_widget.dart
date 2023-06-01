import 'package:m7_livelyness_detection/index.dart';

class M7PreviewDecoratorWidget extends StatelessWidget {
  final CameraState cameraState;
  final Stream<FaceDetectionModel> faceDetectionStream;
  final PreviewSize previewSize;
  final Rect previewRect;
  final Color? detectionColor;

  const M7PreviewDecoratorWidget({
    super.key,
    required this.cameraState,
    required this.faceDetectionStream,
    required this.previewSize,
    required this.previewRect,
    this.detectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: StreamBuilder(
        stream: cameraState.sensorConfig$,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return StreamBuilder<FaceDetectionModel>(
              stream: faceDetectionStream,
              builder: (_, faceModelSnapshot) {
                if (!faceModelSnapshot.hasData) return const SizedBox();
                return CustomPaint(
                  painter: M7AndroidFaceDetectorPainter(
                    model: faceModelSnapshot.requireData,
                    previewSize: previewSize,
                    previewRect: previewRect,
                    isBackCamera: snapshot.requireData.sensor == Sensors.back,
                    detectionColor: detectionColor,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
