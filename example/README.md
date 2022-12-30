![](https://secureservercdn.net/160.153.137.91/nns.2aa.myftpupload.com/wp-content/uploads/thegem-logos/logo_02b434f906abd43095b870f23c028412_2x.png)

# m7_livelyness_detection

A Flutter package to detect livelyness of a face.

## Installation
Nothing much complicated, just a few steps and you're good to go.

### Android
Open the `android/app/build.gradle` file and set the `minSdkVersion`.
```
        minSdkVersion 21
```

### iOS
Open the `ios/Runner/Info.plist` and add the below code snippet.
```xml
	<!-- Camera Access -->
	<key>NSCameraUsageDescription</key>
	<string>Camera Access for Scanning</string>

	<!-- Microphone Access -->
	<key>NSMicrophoneUsageDescription</key>
	<string>Microphone for playing instructions audio.</string>
```

## Demo
This is a very simple example. Just call a function and you are good to go.

```dart
    final String? response = await M7LivelynessDetection.instance.detectLivelyness(
      context,
      config: M7DetectionConfig(
        steps: [
          M7LivelynessStepItem(
            step: M7LivelynessStep.blink,
            title: "Blink",
            isCompleted: false,
          ),
          M7LivelynessStepItem(
            step: M7LivelynessStep.smile,
            title: "Smile",
            isCompleted: false,
          ),
        ],
        startWithInfoScreen: true,
      ),
    );
```