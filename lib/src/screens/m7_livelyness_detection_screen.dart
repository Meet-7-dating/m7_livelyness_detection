import 'dart:async';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:m7_livelyness_detection/index.dart';

List<CameraDescription> availableCams = [];

class M7LivelynessDetectionScreen extends StatefulWidget {
  final M7DetectionConfig config;
  const M7LivelynessDetectionScreen({
    required this.config,
    super.key,
  });

  @override
  State<M7LivelynessDetectionScreen> createState() => _MLivelyness7DetectionScreenState();
}

class _MLivelyness7DetectionScreenState extends State<M7LivelynessDetectionScreen> {
  //* MARK: - Private Variables
  //? =========================================================
  late bool _isInfoStepCompleted;
  late final List<M7LivelynessStepItem> steps;
  CameraController? _cameraController;
  CustomPaint? _customPaint;
  int _cameraIndex = 0;
  bool _isBusy = false;
  final GlobalKey<M7LivelynessDetectionStepOverlayState> _stepsKey = GlobalKey<M7LivelynessDetectionStepOverlayState>();
  bool _isProcessingStep = false;
  bool _didCloseEyes = false;
  bool _isTakingPicture = false;
  Timer? _timerToDetectFace;
  bool _isCaptureButtonVisible = false;

  late final List<M7LivelynessStepItem> _steps;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _preInitCallBack();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _postFrameCallBack(),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timerToDetectFace?.cancel();
    _timerToDetectFace = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _preInitCallBack() {
    _steps = widget.config.steps;
    _isInfoStepCompleted = !widget.config.startWithInfoScreen;
  }

  void _postFrameCallBack() async {
    availableCams = await availableCameras();
    if (availableCams.any(
      (element) => element.lensDirection == CameraLensDirection.front && element.sensorOrientation == 90,
    )) {
      _cameraIndex = availableCams.indexOf(
        availableCams
            .firstWhere((element) => element.lensDirection == CameraLensDirection.front && element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = availableCams.indexOf(
        availableCams.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
        ),
      );
    }
    if (!widget.config.startWithInfoScreen) {
      _startLiveFeed();
    }
  }

  void _startTimer() {
    _timerToDetectFace = Timer(
      Duration(seconds: widget.config.maxSecToDetect),
      () {
        _timerToDetectFace?.cancel();
        _timerToDetectFace = null;
        if (widget.config.allowAfterMaxSec) {
          _isCaptureButtonVisible = true;
          setState(() {});
          return;
        }
        _onDetectionCompleted(
          imgToReturn: null,
        );
      },
    );
  }

  void _startLiveFeed() async {
    final camera = availableCams[_cameraIndex];
    // _cameraController = CameraController(
    //   camera,
    //   ResolutionPreset.high,
    //   imageFormatGroup: ImageFormatGroup.jpeg,
    //   enableAudio: false,
    // );
    // _cameraController?.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //   _cameraController?.startImageStream(_processCameraImage);
    //   if (mounted) {
    //     _startTimer();
    //     setState(() {});
    //   }
    // });
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    _cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _startTimer();
      _cameraController?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = availableCams[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    _processImage(inputImage);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isBusy) {
      return;
    }
    _isBusy = true;
    final faces = await M7MLHelper.instance.processInputImage(inputImage);

    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      if (faces.isEmpty) {
        _resetSteps();
      } else {
        final firstFace = faces.first;
        final painter = M7FaceDetectorPainter(firstFace, inputImage.metadata!.size, inputImage.metadata!.rotation);
        _customPaint = CustomPaint(
          painter: painter,
          child: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
          ),
        );
        if (_isProcessingStep && _steps[_stepsKey.currentState?.currentIndex ?? 0].step == M7LivelynessStep.blink) {
          if (_didCloseEyes) {
            if ((faces.first.leftEyeOpenProbability ?? 1.0) < 0.75 && (faces.first.rightEyeOpenProbability ?? 1.0) < 0.75) {
              await _completeStep(
                step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
              );
            }
          }
        }
        _detect(
          face: faces.first,
          step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
        );
      }
    } else {
      _resetSteps();
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _completeStep({
    required M7LivelynessStep step,
  }) async {
    final int indexToUpdate = _steps.indexWhere(
      (p0) => p0.step == step,
    );

    _steps[indexToUpdate] = _steps[indexToUpdate].copyWith(
      isCompleted: true,
    );
    if (mounted) {
      setState(() {});
    }
    await _stepsKey.currentState?.nextPage();
    _stopProcessing();
  }

  void _takePicture() async {
    try {
      if (_cameraController == null) return;
      // if (face == null) return;
      if (_isTakingPicture) {
        return;
      }
      setState(
        () => _isTakingPicture = true,
      );
      await _cameraController?.stopImageStream();
      final XFile? clickedImage = await _cameraController?.takePicture();
      if (clickedImage == null) {
        _startLiveFeed();
        return;
      }
      _onDetectionCompleted(imgToReturn: clickedImage);
    } catch (e) {
      _startLiveFeed();
    }
  }

  void _onDetectionCompleted({
    XFile? imgToReturn,
  }) {
    final String? imgPath = imgToReturn?.path;
    Navigator.of(context).pop(imgPath);
  }

  void _resetSteps() async {
    for (var p0 in _steps) {
      final int index = _steps.indexWhere(
        (p1) => p1.step == p0.step,
      );
      _steps[index] = _steps[index].copyWith(
        isCompleted: false,
      );
    }
    _customPaint = null;
    _didCloseEyes = false;
    if (_stepsKey.currentState?.currentIndex != 0) {
      _stepsKey.currentState?.reset();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _startProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = true,
    );
  }

  void _stopProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = false,
    );
  }

  void _detect({
    required Face face,
    required M7LivelynessStep step,
  }) async {
    if (_isProcessingStep) {
      return;
    }
    switch (step) {
      case M7LivelynessStep.blink:
        final M7BlinkDetectionThreshold? blinkThreshold = M7LivelynessDetection.instance.thresholdConfig.firstWhereOrNull(
          (p0) => p0 is M7BlinkDetectionThreshold,
        ) as M7BlinkDetectionThreshold?;
        if ((face.leftEyeOpenProbability ?? 1.0) < (blinkThreshold?.leftEyeProbability ?? 0.25) &&
            (face.rightEyeOpenProbability ?? 1.0) < (blinkThreshold?.rightEyeProbability ?? 0.25)) {
          _startProcessing();
          if (mounted) {
            setState(
              () => _didCloseEyes = true,
            );
          }
        }
        break;
      case M7LivelynessStep.turnLeft:
        final M7HeadTurnDetectionThreshold? headTurnThreshold = M7LivelynessDetection.instance.thresholdConfig.firstWhereOrNull(
          (p0) => p0 is M7HeadTurnDetectionThreshold,
        ) as M7HeadTurnDetectionThreshold?;
        if ((face.headEulerAngleY ?? 0) > (headTurnThreshold?.rotationAngle ?? 45)) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
      case M7LivelynessStep.turnRight:
        final M7HeadTurnDetectionThreshold? headTurnThreshold = M7LivelynessDetection.instance.thresholdConfig.firstWhereOrNull(
          (p0) => p0 is M7HeadTurnDetectionThreshold,
        ) as M7HeadTurnDetectionThreshold?;
        if ((face.headEulerAngleY ?? 0) > (headTurnThreshold?.rotationAngle ?? -50)) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
      case M7LivelynessStep.smile:
        final M7SmileDetectionThreshold? smileThreshold = M7LivelynessDetection.instance.thresholdConfig.firstWhereOrNull(
          (p0) => p0 is M7SmileDetectionThreshold,
        ) as M7SmileDetectionThreshold?;
        if ((face.smilingProbability ?? 0) > (smileThreshold?.probability ?? 0.75)) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
    }
  }

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  Widget _buildBody() {
    return Stack(
      children: [
        _isInfoStepCompleted
            ? _buildDetectionBody()
            : M7LivelynessInfoWidget(
                onStartTap: () {
                  if (mounted) {
                    setState(
                      () => _isInfoStepCompleted = true,
                    );
                  }
                  _startLiveFeed();
                },
              ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 10,
              top: 10,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black,
              child: IconButton(
                onPressed: () => _onDetectionCompleted(
                  imgToReturn: null,
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetectionBody() {
    if (_cameraController == null || _cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    final Widget cameraView = CameraPreview(_cameraController!);
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: cameraView,
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: cameraView,
        ),
        if (_customPaint != null) _customPaint!,
        M7LivelynessDetectionStepOverlay(
          key: _stepsKey,
          steps: _steps,
          onCompleted: () => Future.delayed(
            const Duration(milliseconds: 500),
            () => _takePicture(),
          ),
        ),
        Visibility(
          visible: _isCaptureButtonVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(
                flex: 20,
              ),
              MaterialButton(
                onPressed: () => _takePicture(),
                color: widget.config.captureButtonColor ?? Theme.of(context).primaryColor,
                textColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.camera_alt,
                  size: 24,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
