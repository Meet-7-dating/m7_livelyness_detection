# 0.0.6+4
### Added
* Bug fixes
* Performance Improvements
## 0.0.6+3
### Added
* Configurable dash lines on the face
```dart
    M7LivelynessDetection.instance.configure(
      lineColor: Colors.white,
      dotColor: Colors.purple.shade800,
      dotSize: 2.0,
      lineWidth: 1.6,
      displayDots: false,
      displayLines: true,
      dashValues: [2.0, 5.0], // <--- Dash Values
      thresholds: [
        M7SmileDetectionThreshold(
          probability: 0.8,
        ),
        M7BlinkDetectionThreshold(
          leftEyeProbability: 0.25,
          rightEyeProbability: 0.25,
        ),
      ],
    );
```
## 0.0.6+2
### Added
* Configurable visibility of the contour dots & lines
```dart
    M7LivelynessDetection.instance.configure(
      lineColor: Colors.white,
      dotColor: Colors.purple.shade800,
      dotSize: 2.0,
      lineWidth: 1.6,
      displayDots: false,
      displayLines: true,
      thresholds: [
        M7SmileDetectionThreshold(
          probability: 0.8,
        ),
        M7BlinkDetectionThreshold(
          leftEyeProbability: 0.25,
          rightEyeProbability: 0.25,
        ),
      ],
    );
```
## 0.0.6+1
### Added
* Configurable `detectionColor` on the face using the below-mentioned code
```dart
    M7LivelynessStepItem(
      step: M7LivelynessStep.blink,
      title: "Blink",
      isCompleted: false,
      detectionColor: Colors.amber, // <--- Detection Color
    )
```
## 0.0.6
### Added
* Configurable `contour lines & dots` on the face
```dart
    M7LivelynessDetection.instance.configure(
      lineColor: Colors.white,          // <--- Line Color
      dotColor: Colors.purple.shade800, // <--- Dot Color
      thresholds: [
        M7SmileDetectionThreshold(
          probability: 0.8,
        ),
        M7BlinkDetectionThreshold(
          leftEyeProbability: 0.25,
          rightEyeProbability: 0.25,
        ),
      ],
    );
```
### Changed
* Camera preview now uses direct stream from native camera stream.
## 0.0.5

* Now identify wether the image was captured via the button or not from the below-mentioned code
```dart
    final M7CapturedImage? response =
        await M7LivelynessDetection.instance.detectLivelyness(
      context,
      config: M7DetectionConfig(
        steps: _veificationSteps,
        startWithInfoScreen: _startWithInfo,
        maxSecToDetect: _timeOutDuration == 100 ? 2500 : _timeOutDuration,
        allowAfterMaxSec: _allowAfterTimeOut,
        captureButtonColor: Colors.red,
      ),
    );

    // response?.didCaptureAutomatically
```

## 0.0.4+5

* Added `Index` in the documentation.
* Minor Bug Fixes.

## 0.0.4+4

* Minor Bug Fixes.
## 0.0.4+3

* Minor Bug Fixes.

## 0.0.4+2

* Android issue resilved.

## 0.0.4+1

* When allowing the user to capture even after the `maxSecToDetect` seconds have passed, the background color can be set accordingly.
```dart
final String? response =
    await M7LivelynessDetection.instance.detectLivelyness(
  context,
  config: M7DetectionConfig(
    steps: _veificationSteps,
    startWithInfoScreen: _startWithInfo,
    maxSecToDetect: _timeOutDuration == 100 ? 2500 : _timeOutDuration,
    allowAfterMaxSec: _allowAfterTimeOut,
    captureButtonColor: Colors.red, /// <-------- Pass [captureButtonColor] to set the color.
  ),
);
```

## 0.0.4

* If the user's device does not support face detection and still if you want to capture the image refer to the below-mentioned code.
```dart
M7LivelynessDetection.instance.detectLivelyness(
    context,
    config: M7DetectionConfig(
    steps: _veificationSteps,
    startWithInfoScreen: _startWithInfo,
    maxSecToDetect: _timeOutDuration == 100 ? 2500 : _timeOutDuration,
    allowAfterMaxSec: true, /// <-------- Pass [allowAfterMaxSec] as true.
  ),
)
```

## 0.0.3+hotfix

* A minor hotfix for `image` package.

## 0.0.3

* The user can now add custom threshold for each step using the below-mentioned code
```dart
M7LivelynessDetection.instance.configure(
  thresholds: [
    M7SmileDetectionThreshold(
      probability: 0.8,
    ),
    M7BlinkDetectionThreshold(
      leftEyeProbability: 0.25,
      rightEyeProbability: 0.25,
    ),
  ],
);
```

* NOTE: -
Please call the above function before calling the `M7LivelynessDetection.instance.detectLivelyness`.

## 0.0.2+2

* Updated the README.md with contributors

## 0.0.2+1

* Added Demo video in the README.md file.

## 0.0.2

* Updated the README.md file
* Added documentation for the package.
* Updated the `example` project.

## 0.0.1

* Initial Commit.