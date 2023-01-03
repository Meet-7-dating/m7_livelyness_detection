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