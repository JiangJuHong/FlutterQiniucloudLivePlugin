//  Created by 蒋具宏 on 2020/3/3.
//  七牛云连麦播放视图工厂
public class QiniucloudConnectedPlayerPlatformViewFactory : NSObject,FlutterPlatformViewFactory{
    /**
     * 全局标识
     */
    public static let SIGN = "plugins.huic.top/QiniucloudConnectedPlayer";
    
    /**
     *   消息器
     */
    private var message : FlutterBinaryMessenger;
    
    
    init(message : FlutterBinaryMessenger) {
        self.message = message;
    }
    
    /**
     *  视图创建
     */
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        let view = QiniucloudPushPlatformView(frame);
        
        // 绑定方法监听
        FlutterMethodChannel(
            name: "\(QiniucloudConnectedPlayerPlatformViewFactory.SIGN)_\(viewId)",
            binaryMessenger: message
        ).setMethodCallHandler(view.handle);
        
        return view;
    }
}

//  七牛云连麦播放器视图
public class QiniucloudConnectedPlayerPlatformView : NSObject,FlutterPlatformView{
    /**
     *  窗体
     */
    private var frame : CGRect;
    
    init(_ frame : CGRect) {
        self.frame = frame;
    }
    
    /**
     *  方法监听器
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startRemoteView":
//            self.startRemoteView(call: call, result: result);
            break;
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    public func view() -> UIView {
        return UIView();
    }
}
