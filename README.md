# m7_livelyness_detection

<img src="https://storage.googleapis.com/meet7_assets/meet7_app_icon.png" alt="drawing" width="190"/>

![](https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white)
![](https://img.shields.io/badge/meet7-open--source-purple) ![](https://img.shields.io/pub/likes/m7_livelyness_detection) ![](https://img.shields.io/pub/points/m7_livelyness_detection) ![](https://img.shields.io/pub/popularity/m7_livelyness_detection) ![](https://img.shields.io/pub/publisher/m7_livelyness_detection) ![](https://img.shields.io/pub/v/m7_livelyness_detection?include_prereleases)



## What is the Livelyness Detection?
A single line flutter package that will help you detect weather the captured image is a live face or not.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :----: |
|   ✔️    | ✔️  |  ⏱️   | ⏱️  |  ⏱️   |   ⏱️   |

## Installation

#### Flutter Setup

Add `m7_livelyness_detection` to your `pubspec.yaml` dependencies.

##### Using command-line
```sh
flutter pub add m7_livelyness_detection
```

#### Native Setup

<details>
  <summary>iOS</summary>
  
  #### iOS Setup
  1. Open the project in Xcode and set the deployment
  2. Open the `ios/Runner/Info.plist` file as `Source Code`.
  3. Add the below-mentioned code inside the `<dict>` tag.

  ```xml
    <key>NSCameraUsageDescription</key>
    <string>Camera Access for Scanning</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Microphone for playing instructions audio.</string>
  ```

  4. Open the `ios/Runner/Podfile` and uncomment the second line.
  ```yaml
	platform :ios, '14.0' # <---------- Uncomment this line
  ```
  5. Set the deployment target in the Xcode project

  <img width="1440" alt="Screenshot 2023-01-02 at 11 03 17 AM" src="https://user-images.githubusercontent.com/106381741/210199508-72c0572c-c153-4178-b29a-4ae490f1e989.png">
</details>

<details>
  <summary>Android</summary>
  
  #### Android Setup
  1. Open the `example/android/app/build.gradle` file and set the `minSdkVersion` as `21`.
</details>

## Example

Nothing fancy just a single line function that will return a temporary path to the captured image.

#### Code
```dart
    final String? response =
        await M7LivelynessDetection.instance.detectLivelyness(
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

#### Example Video

https://user-images.githubusercontent.com/106381741/210200724-ae4af9cc-ffeb-49e4-a3f9-9971b2f256b6.MP4

## Contributors

| Contributors  |  |
| ------------- | ------------- |
| Sagar Ghag  | <a href="https://github.com/Meet-7-dating/m7_livelyness_detection/graphs/contributors"><img src="https://contrib.rocks/image?repo=Meet-7-dating/m7_livelyness_detection" /></a>  |
| Omkar Tralsawala  | <a href="https://github.com/Meet-7-dating/m7_livelyness_detection/graphs/contributors"><img src="https://storage.googleapis.com/meet7_assets/archive/omkar-tralsawala-modified.png" width="65" height="65" /></a>  |