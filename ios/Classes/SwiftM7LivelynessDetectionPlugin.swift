import Flutter
import UIKit

public class SwiftM7LivelynessDetectionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "m7_livelyness_detection", binaryMessenger: registrar.messenger())
    let instance = SwiftM7LivelynessDetectionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
