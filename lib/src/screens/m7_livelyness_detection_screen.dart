import 'dart:async';
import 'dart:ui' as ui;

import 'package:m7_livelyness_detection/index.dart';

List<CameraDescription> availableCams = [];

class M7LivelynessDetectionScreen extends StatefulWidget {
  final M7DetectionConfig config;
  const M7LivelynessDetectionScreen({
    required this.config,
    super.key,
  });

  @override
  State<M7LivelynessDetectionScreen> createState() =>
      _MLivelyness7DetectionScreenState();
}

class _MLivelyness7DetectionScreenState
    extends State<M7LivelynessDetectionScreen> {
  //* MARK: - Private Variables
  //? =========================================================
  late bool _isInfoStepCompleted;
  late final List<M7LivelynessStepItem> steps;
  CameraController? _cameraController;
  CustomPaint? _customPaint;
  int _cameraIndex = 0;
  bool _isBusy = false;
  final GlobalKey<M7LivelynessDetectionStepOverlayState> _stepsKey =
      GlobalKey<M7LivelynessDetectionStepOverlayState>();
  bool _isProcessingStep = false;
  bool _didCloseEyes = false;
  bool _isTakingPicture = false;
  Timer? _timerToDetectFace;

  late final List<M7LivelynessStepItem> _steps;

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
      (element) =>
          element.lensDirection == CameraLensDirection.front &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = availableCams.indexOf(
        availableCams.firstWhere((element) =>
            element.lensDirection == CameraLensDirection.front &&
            element.sensorOrientation == 90),
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
    _startTimer();
  }

  void _startTimer() {
    _timerToDetectFace = Timer(
      Duration(seconds: widget.config.maxSecToDetect),
      () => _onDetectionCompleted(
        imgToReturn: null,
      ),
    );
  }

  void _startLiveFeed() async {
    final camera = availableCams[_cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    _cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future<void> _processCameraImage(CameraImage cameraImage) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      cameraImage.width.toDouble(),
      cameraImage.height.toDouble(),
    );

    final camera = availableCams[_cameraIndex];
    final imageRotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (imageRotation == null) return;

    final inputImageFormat = InputImageFormatValue.fromRawValue(
      cameraImage.format.raw,
    );
    if (inputImageFormat == null) return;

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    _processImage(inputImage);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isBusy) {
      return;
    }
    _isBusy = true;
    final faces = await M7MLHelper.instance.processInputImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = M7FaceDetectorPainter(
        faces,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
      );
      _customPaint = CustomPaint(painter: painter);
      if (faces.isEmpty) {
        _resetSteps();
      } else {
        if (_isProcessingStep &&
            _steps[_stepsKey.currentState?.currentIndex ?? 0].step ==
                M7LivelynessStep.blink) {
          if (_didCloseEyes) {
            if ((faces.first.leftEyeOpenProbability ?? 1.0) < 0.75 &&
                (faces.first.rightEyeOpenProbability ?? 1.0) < 0.75) {
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
    setState(() {});
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
    setState(() {});
  }

  void _startProcessing() => setState(
        () => _isProcessingStep = true,
      );

  void _stopProcessing() => setState(
        () => _isProcessingStep = false,
      );

  void _detect({
    required Face face,
    required M7LivelynessStep step,
  }) async {
    if (_isProcessingStep) {
      return;
    }
    switch (step) {
      case M7LivelynessStep.blink:
        if ((face.leftEyeOpenProbability ?? 1.0) < 0.25 &&
            (face.rightEyeOpenProbability ?? 1.0) < 0.25) {
          _startProcessing();
          setState(
            () => _didCloseEyes = true,
          );
        }
        break;
      case M7LivelynessStep.turnLeft:
        if ((face.headEulerAngleY ?? 0) > 45) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
      case M7LivelynessStep.turnRight:
        if ((face.headEulerAngleY ?? 0) > -50) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
      case M7LivelynessStep.smile:
        if ((face.smilingProbability ?? 0) > 0.75) {
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
                  setState(
                    () => _isInfoStepCompleted = true,
                  );
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
    if (_cameraController == null ||
        _cameraController?.value.isInitialized == false) {
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
        cameraView,
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY: 5.0,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Center(
          child: cameraView,
        ),
        if (_customPaint != null) _customPaint!,
        M7LivelynessDetectionStepOverlay(
          key: _stepsKey,
          steps: _steps,
          onCompleted: () => _takePicture(),
        ),
      ],
    );
  }
}
