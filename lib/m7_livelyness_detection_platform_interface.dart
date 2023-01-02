import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'm7_livelyness_detection_method_channel.dart';

abstract class M7LivelynessDetectionPlatform extends PlatformInterface {
  /// Constructs a M7LivelynessDetectionPlatform.
  M7LivelynessDetectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static M7LivelynessDetectionPlatform _instance =
      MethodChannelM7LivelynessDetection();

  /// The default instance of [M7LivelynessDetectionPlatform] to use.
  ///
  /// Defaults to [MethodChannelM7LivelynessDetection].
  static M7LivelynessDetectionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [M7LivelynessDetectionPlatform] when
  /// they register themselves.
  static set instance(M7LivelynessDetectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
