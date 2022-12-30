import 'package:flutter_test/flutter_test.dart';
import 'package:m7_livelyness_detection/m7_livelyness_detection_method_channel.dart';
import 'package:m7_livelyness_detection/m7_livelyness_detection_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockM7LivelynessDetectionPlatform
    with MockPlatformInterfaceMixin
    implements M7LivelynessDetectionPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final M7LivelynessDetectionPlatform initialPlatform =
      M7LivelynessDetectionPlatform.instance;

  test('$MethodChannelM7LivelynessDetection is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelM7LivelynessDetection>());
  });

  test('getPlatformVersion', () async {
    MockM7LivelynessDetectionPlatform fakePlatform =
        MockM7LivelynessDetectionPlatform();
    M7LivelynessDetectionPlatform.instance = fakePlatform;
  });
}
