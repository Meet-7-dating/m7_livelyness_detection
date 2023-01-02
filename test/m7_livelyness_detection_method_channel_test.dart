import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m7_livelyness_detection/m7_livelyness_detection_method_channel.dart';

void main() {
  MethodChannelM7LivelynessDetection platform =
      MethodChannelM7LivelynessDetection();
  const MethodChannel channel = MethodChannel('m7_livelyness_detection');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
