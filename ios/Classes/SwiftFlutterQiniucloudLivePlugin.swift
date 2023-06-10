import Flutter
import UIKit
import PLPlayerKit
import PLRTCStreamingKit

public class SwiftFlutterQiniucloudLivePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // 初始化七牛云推流环境
    PLStreamingEnv.initEnv()

    let channel = FlutterMethodChannel(name: "flutter_qiniucloud_live_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterQiniucloudLivePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // 播放界面
    registrar.register(
        QiniucloudPlayerPlatformViewFactory(message: registrar.messenger()),
        withId: QiniucloudPlayerPlatformViewFactory.SIGN
    );
    // 推流界面
    registrar.register(
        QiniucloudPushPlatformViewFactory(message: registrar.messenger()),
        withId: QiniucloudPushPlatformViewFactory.SIGN
    );
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
  }
}
