import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'm7_livelyness_detection_platform_interface.dart';

/// An implementation of [M7LivelynessDetectionPlatform] that uses method channels.
class MethodChannelM7LivelynessDetection extends M7LivelynessDetectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('m7_livelyness_detection');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
