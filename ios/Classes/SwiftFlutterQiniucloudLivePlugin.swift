import Flutter
import UIKit

public class SwiftFlutterQiniucloudLivePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_qiniucloud_live_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterQiniucloudLivePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
