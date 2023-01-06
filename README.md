# m7_livelyness_detection

<img src="https://storage.googleapis.com/meet7_assets/meet7_app_icon.png" alt="drawing" width="190"/>

![](https://img.shields.io/badge/meet7-open--source-purple?style=for-the-badge) ![](https://img.shields.io/pub/publisher/m7_livelyness_detection?color=purple&style=for-the-badge) ![](https://img.shields.io/github/issues-raw/Meet-7-dating/m7_livelyness_detection?style=for-the-badge&&logo=github) ![](https://img.shields.io/github/languages/count/Meet-7-dating/m7_livelyness_detection?style=for-the-badge&&logo=github)
![](https://img.shields.io/pub/likes/m7_livelyness_detection?style=for-the-badge&logo=dart) ![](https://img.shields.io/pub/points/m7_livelyness_detection?style=for-the-badge&logo=dart) ![](https://img.shields.io/pub/popularity/m7_livelyness_detection?style=for-the-badge&logo=dart) ![](https://img.shields.io/pub/publisher/m7_livelyness_detection?style=for-the-badge) ![](https://img.shields.io/pub/v/m7_livelyness_detection?style=for-the-badge&logo=dart)
![](https://img.shields.io/github/directory-file-count/Meet-7-dating/m7_livelyness_detection?style=for-the-badge&logo=github) ![](https://img.shields.io/github/repo-size/Meet-7-dating/m7_livelyness_detection?style=for-the-badge&logo=github) ![](https://img.shields.io/github/commit-activity/w/Meet-7-dating/m7_livelyness_detection?style=for-the-badge&logo=github) ![](https://img.shields.io/github/contributors/Meet-7-dating/m7_livelyness_detection?style=for-the-badge&logo=github)

## What is the Livelyness Detection?

Liveness detection for face recognition in biometrics is a technique where an algorithm detects if the person in front of the camera is alive and real. The algorithm is able to recognize a live person from presentation attacks - where a bad actor, or fraud perpetrator, uses someone else's physical characteristics or biometric data (known as "spoofs") for impersonation.

`Spoofing` attempts using printed photos, recordings, deep fake pictures, and 3D masks poses a serious threat. `Facial Liveness Detection` incorporates specialized features to identify biometric spoofing attacks, which could be an imitation emulating a person’s unique biometrics scanned through the biometric detector to deceive or bypass the identification and authentication steps provided by the system. Even though face recognition can reliably answer the question, “Is this the right person?” but not the question, “Is this a live person?” This is where liveness detection technology plays a significant role in fraud detection and mitigation. Face biometric matching must be able to detect spoofs in order to be trusted, and to maintain the integrity of biometric data. 

<!-- <iframe src="https://embed.lottiefiles.com/animation/16432" width="100%" aspect-ratio="auto"></iframe> -->

<iframe 
  width="100%"
  src="https://embed.lottiefiles.com/animation/16432"
  frameborder="0"
  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen>
</iframe>

## Platform Support

| iOS | Android | MacOS | Web | Linux | Windows |
| :-: | :----: | :---: | :-: | :---: | :----: |
|   ✔️    | ✔️  |  <iframe src="https://embed.lottiefiles.com/animation/96163" height="25" width="25"></iframe>   | <iframe src="https://embed.lottiefiles.com/animation/96163" height="25" width="25"></iframe>  |  <iframe src="https://embed.lottiefiles.com/animation/96163" height="25" width="25"></iframe>   |   <iframe src="https://embed.lottiefiles.com/animation/96163" height="25" width="25"></iframe>   |

## Installation
First, we have to install the package on flutter.


#### Flutter Setup

Add `m7_livelyness_detection` to your `pubspec.yaml` dependencies.

##### Using command-line
```sh
flutter pub add m7_livelyness_detection
```

#### Native Setup
Next comes the native setup on both android and iOS

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

A call to a single line function will return a temporary path to the captured image.

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

## Known Issues

Here is a list of known issues in the package.

* Face detection does not work on some of the android devices. The problem is still unknown and the issue is from the Google ML Kit. [Here is the link of the open issue](https://github.com/bharat-biradar/Google-Ml-Kit-plugin/issues/314).

## Contributors

| Contributors  |  |
| ------------- | ------------- |
| Sagar Ghag  | <a href="https://github.com/Meet-7-dating/m7_livelyness_detection/graphs/contributors"><img src="https://contrib.rocks/image?repo=Meet-7-dating/m7_livelyness_detection" /></a>  |
| Omkar Tralsawala  | <a href="https://github.com/Meet-7-dating/m7_livelyness_detection/graphs/contributors"><img src="https://storage.googleapis.com/meet7_assets/archive/omkar-tralsawala-modified.png" width="65" height="65" /></a>  |