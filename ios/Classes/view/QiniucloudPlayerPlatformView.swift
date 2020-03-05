import PLPlayerKit
import UIKit
import SwiftyJSON

//  Created by 蒋具宏 on 2020/3/3.
//  七牛云播放器视图工厂
public class QiniucloudPlayerPlatformViewFactory : NSObject,FlutterPlatformViewFactory{
    /**
     * 全局标识
     */
    public static let SIGN = "plugins.huic.top/QiniucloudPlayer";
    
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
        let view = QiniucloudPlayerPlatformView(frame);
        
        // 绑定方法监听
        let methodChannel = FlutterMethodChannel(
            name: "\(QiniucloudPlayerPlatformViewFactory.SIGN)_\(viewId)",
            binaryMessenger: message
        );
        methodChannel.setMethodCallHandler(view.handle);
        
        // 初始化
        view.`init`(args,methodChannel);
        
        return view;
    }
    
    /**
     *  定义参数解码器
     */
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance();
    }
}

//  七牛云播放器视图
public class QiniucloudPlayerPlatformView : NSObject,FlutterPlatformView,PLPlayerDelegate{
    /**
     * 监听器回调的方法名
     */
    private static let LISTENER_FUNC_NAME = "onPlayerListener";
    
    /**
     * 通信管道
     */
    private var channel : FlutterMethodChannel?;
    
    /**
     *  窗体
     */
    private var frame : CGRect;
    
    /**
     *   播放对象
     */
    private var player : PLPlayer?;
    
    init(_ frame : CGRect) {
        self.frame = frame;
    }
    
    public func view() -> UIView {
        return player!.playerView!;
    }
    
    /**
     *  方法监听器
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setDisplayAspectRatio":
            self.setDisplayAspectRatio(call: call, result: result);
            break;
        case "start":
            self.start(call: call, result: result);
            break;
        case "pause":
            self.pause(call: call, result: result);
            break;
        case "stopPlayback":
            self.stopPlayback(call: call, result: result);
            break;
        case "getRtmpVideoTimestamp":
            self.getRtmpVideoTimestamp(call: call, result: result);
            break;
        case "getRtmpAudioTimestamp":
            self.getRtmpAudioTimestamp(call: call, result: result);
            break;
        case "setBufferingEnabled":
            self.setBufferingEnabled(call: call, result: result);
            break;
        case "getHttpBufferSize":
            self.getHttpBufferSize(call: call, result: result);
            break;
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    /**
     *  初始化
     */
    public func `init`(_ args : Any?, _ methodChannel : FlutterMethodChannel){
        // 参数转换为字典格式
        let dict = args as! Dictionary<String, Any>;
        
        // 初始化播放器
        self.player = PLPlayer(
            url: URL(
                string: dict["url"]! is NSNull ? "" : (dict["url"] as! String)
            ),
            option: PLPlayerOption.default()
            )!;
        self.player?.videoClipFrame = self.frame;
        
        // 绑定监听器并全局赋值
        self.player!.delegate = self;
        self.channel = methodChannel;
    }
    
    /**
     * 设置画面预览模式
     */
    private func setDisplayAspectRatio(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let mode =  CommonUtils.getParam(call: call, result: result, param: "mode") as? Int{
            var rc = self.player!.playerView!.frame;
            switch mode {
            case 0:
                rc = CGRect.zero;
                break;
            case 2:
                break;
            case 3:
                var width : CGFloat = 0;
                var height : CGFloat = 0;
                if (rc.size.width / rc.size.height > 16.0 / 9.0) {
                    height = rc.size.height;
                    width = rc.size.height * 16.0 / 9.0;
                    rc.origin.x = (rc.size.width - width ) / 2;
                } else {
                    width = rc.size.width;
                    height = rc.size.width * 9.0 / 16.0;
                    rc.origin.y = (rc.size.height - height ) / 2;
                }
                rc.size.width = width;
                rc.size.height = height;
                break;
            case 4:
                var width : CGFloat = 0;
                var height : CGFloat = 0;
                if (rc.size.width / rc.size.height > 4.0 / 3.0) {
                    height = rc.size.height;
                    width = rc.size.height * 4.0 / 3.0;
                    rc.origin.x = (rc.size.width - width ) / 2;
                } else {
                    width = rc.size.width;
                    height = rc.size.width * 3.0 / 4.0;
                    rc.origin.y = (rc.size.height - height ) / 2;
                }
                rc.size.width = width;
                rc.size.height = height;
                break;
            default:
                rc = CGRect.zero;
                break;
            }
            player!.videoClipFrame = rc;
            result(nil);
        }
    }
    
    /**
     * 播放
     */
    private func start(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let url = ((call.arguments as! [String:Any])["url"]) as? String;
        if let sameSource =  CommonUtils.getParam(call: call, result: result, param: "sameSource") as? Bool{
            player!.play(with: url == nil ? nil : URL(string: url!), sameSource: sameSource);
            result(nil);
        }
    }
    
    /**
     * 暂停
     */
    private func pause(call: FlutterMethodCall, result: @escaping FlutterResult) {
        player!.pause();
        result(nil);
    }
    
    /**
     * 停止播放
     */
    private func stopPlayback(call: FlutterMethodCall, result: @escaping FlutterResult) {
        player!.stop();
        result(nil);
    }
    
    /**
     * 在RTMP消息中获取视频时间戳
     */
    private func getRtmpVideoTimestamp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Int(CMTimeGetSeconds(player!.rtmpVideoTimeStamp) * 1000));
    }
    
    /**
     * 在RTMP消息中获取音频时间戳
     */
    private func getRtmpAudioTimestamp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Int(CMTimeGetSeconds(player!.rtmpAudioTimeStamp) * 1000));
    }
    
    /**
     * 暂停/恢复播放器的预缓冲
     */
    private func setBufferingEnabled(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let enabled =  CommonUtils.getParam(call: call, result: result, param: "enabled") as? Bool{
            player!.setBufferingEnabled(enabled);
            result(nil);
        }
    }
    
    /**
     * 获取已经缓冲的长度
     */
    private func getHttpBufferSize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(player!.getHttpBufferSize());
    }
    
    /**
     * 调用监听器
     *
     * @param type   类型
     * @param params 参数
     */
    private func invokeListener(type : PlayerCallBackNoticeEnum, params : Any?) {
        var resultParams : [String:Any] = [:];
        resultParams["type"] = type;
        if let p = params{
            resultParams["params"] = JsonUtil.toJson(p);
        }
        
        self.channel!.invokeMethod(QiniucloudPlayerPlatformView.LISTENER_FUNC_NAME, arguments:JsonUtil.toJson(resultParams));
    }
    
    
    
    /**
     *  错误事件
     */
    public func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        self.invokeListener(type: PlayerCallBackNoticeEnum.Error, params:error?.localizedDescription);
    }
    
    /**
     *  播放状态改变事件
     */
    public func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        // 准备好
        if state == PLPlayerStatus.statusReady{
            self.invokeListener(type: PlayerCallBackNoticeEnum.Prepared, params:nil);
        }
        
        // 准备结束
        if state == PLPlayerStatus.statusCompleted{
            self.invokeListener(type: PlayerCallBackNoticeEnum.Completion, params:nil);
        }
        
        
        self.invokeListener(type: PlayerCallBackNoticeEnum.Info, params: state.rawValue);
    }
    
}
