import PLRTCStreamingKit

//  Created by 蒋具宏 on 2020/3/3.

//  七牛云连麦推流视图工厂
public class QiniucloudPushPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    /**
     * 全局标识
     */
    public static let SIGN = "plugins.huic.top/QiniucloudPush";

    /**
     *   消息器
     */
    private var message: FlutterBinaryMessenger;


    init(message: FlutterBinaryMessenger) {
        self.message = message;
    }

    /**
     *  视图创建
     */
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {

        let view = QiniucloudPushPlatformView(frame);

        // 绑定方法监听
        let methodChannel = FlutterMethodChannel(
                name: "\(QiniucloudPushPlatformViewFactory.SIGN)_\(viewId)",
                binaryMessenger: message
        );
        methodChannel.setMethodCallHandler(view.handle);

        // 初始化
        view.`init`(args, methodChannel);

        return view;
    }

    /**
     *  定义参数解码器
     */
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance();
    }
}

//  七牛云连麦推流视图

public class QiniucloudPushPlatformView: NSObject, FlutterPlatformView, PLMediaStreamingSessionDelegate {
    /**
     * 监听器回调的方法名
     */
    private static let LISTENER_FUNC_NAME = "onPushListener";

    /**
     * 通信管道
     */
    private var channel: FlutterMethodChannel?;

    /**
     *  窗体
     */
    private var frame: CGRect;

    /**
     *  七牛云Session
     */
    private var session: PLMediaStreamingSession?;

    /**
     *  视频采集配置
     */
    private var videoCaptureConfig: PLVideoCaptureConfiguration?;

    /**
     *  音频采集配置
     */
    private var audioCaptureConfig: PLAudioCaptureConfiguration?;

    /**
     *  视频编码配置
     */
    private var videoStreamingConfig: PLVideoStreamingConfiguration?;

    /**
     *  音频编码配置
     */
    private var audioStreamingConfig: PLAudioStreamingConfiguration?;

    init(_ frame: CGRect) {
        self.frame = frame;
    }

    public func view() -> UIView {
        if session == nil {
            return UIView();
        }
        return session!.previewView;
    }

    /**
     *  方法监听器
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "resume":
            self.resume(call: call, result: result);
            break;
        case "pause":
            self.pause(call: call, result: result);
            break;
        case "startConference":
            self.startConference(call: call, result: result);
            break;
        case "stopConference":
            self.stopConference(call: call, result: result);
            break;
        case "startStreaming":
            self.startStreaming(call: call, result: result);
            break;
        case "stopStreaming":
            self.stopStreaming(call: call, result: result);
            break;
        case "destroy":
            self.destroy(call: call, result: result);
            break;
        case "isZoomSupported":
            self.isZoomSupported(call: call, result: result);
            break;
        case "setZoomValue":
            self.setZoomValue(call: call, result: result);
            break;
        case "getZoom":
            self.getZoom(call: call, result: result);
            break;
        case "getMaxZoom":
            self.getMaxZoom(call: call, result: result);
            break;
        case "turnLightOn":
            self.turnLightOn(call: call, result: result);
            break;
        case "turnLightOff":
            self.turnLightOff(call: call, result: result);
            break;
        case "switchCamera":
            self.switchCamera(call: call, result: result);
            break;
        case "mute":
            self.mute(call: call, result: result);
            break;
        case "kickoutUser":
            self.kickoutUser(call: call, result: result);
            break;
        case "setConferenceOptions":
            self.setConferenceOptions(call: call, result: result);
            break;
        case "setStreamingProfile":
            self.setStreamingProfile(call: call, result: result);
            break;
        case "getParticipantsCount":
            self.getParticipantsCount(call: call, result: result);
            break;
        case "getParticipants":
            self.getParticipants(call: call, result: result);
            break;
        case "setPreviewMirror":
            self.setPreviewMirror(call: call, result: result);
            break;
        case "setEncodingMirror":
            self.setEncodingMirror(call: call, result: result);
            break;
        case "startPlayback":
            self.startPlayback(call: call, result: result);
            break;
        case "stopPlayback":
            self.stopPlayback(call: call, result: result);
            break;
        case "updateWatermarkSetting":
            self.updateWatermarkSetting(call: call, result: result);
            break;
        case "updateFaceBeautySetting":
            self.updateFaceBeautySetting(call: call, result: result);
            break;
        case "addRemoteWindow":
            self.addRemoteWindow(call: call, result: result);
            break;
        case "getVideoEncodingSize":
            self.getVideoEncodingSize(call: call, result: result);
            break;
        case "setLocalWindowPosition":
            self.setLocalWindowPosition(call: call, result: result);
            break;
        default:
            result(FlutterMethodNotImplemented);
        }
    }

    /**
     * 初始化
     *
     * @param params        参数
     * @param methodChannel 方法通道
     */
    public func `init`(_ args: Any?, _ methodChannel: FlutterMethodChannel) {
        // 全局赋值方法管道
        self.channel = methodChannel;

        // 初始化视频配置
        self.videoCaptureConfig = PLVideoCaptureConfiguration.default();
        self.videoStreamingConfig = PLVideoStreamingConfiguration.default();

        // 初始化音屏配置
        self.audioCaptureConfig = PLAudioCaptureConfiguration.default();
        self.audioStreamingConfig = PLAudioStreamingConfiguration.default();

        // 初始化会话对象
        self.session = PLMediaStreamingSession(videoCaptureConfiguration: videoCaptureConfig, audioCaptureConfiguration: audioCaptureConfig, videoStreamingConfiguration: videoStreamingConfig, audioStreamingConfiguration: audioStreamingConfig, stream: nil);

        // 加载配置
        let dict = args as! Dictionary<String, Any>;
        self.loadVideoCaptureConfig(dict["cameraStreamingSetting"]);
        self.loadStreamingProfile(dict["streamingProfile"]);
        self.loadConnectOptions(dict["connectOptions"]);

        // 绑定监听器
        self.session?.delegate = self;
    }

    /**
     *  加载视频采集配置
     */
    private func loadVideoCaptureConfig(_ cameraSettingStr: Any?) {
        if cameraSettingStr == nil || cameraSettingStr is NSNull {
            return;
        }
        let cameraSetting = JsonUtil.getDictionaryFromJSONString(jsonString: cameraSettingStr as! String);

        //  # 摄像头
        if let cameraFacingId = cameraSetting["CAMERA_FACING_BACK"] {
            if cameraFacingId as! String == "CAMERA_FACING_BACK" {
                videoCaptureConfig?.position = AVCaptureDevice.Position.back;
            }
            if cameraFacingId as! String == "CAMERA_FACING_FRONT" {
                videoCaptureConfig?.position = AVCaptureDevice.Position.front;
            }
        }

        //  # 镜像翻转(预览端)
        if let frontCameraPreviewMirror = cameraSetting["frontCameraPreviewMirror"] {
            videoCaptureConfig?.previewMirrorRearFacing = frontCameraPreviewMirror as! Bool;
            videoCaptureConfig?.previewMirrorFrontFacing = frontCameraPreviewMirror as! Bool;
        }

        //  # 镜像翻转(播放端)
        if let frontCameraMirror = cameraSetting["frontCameraMirror"] {
            videoCaptureConfig?.streamMirrorRearFacing = frontCameraMirror as! Bool;
            videoCaptureConfig?.streamMirrorFrontFacing = frontCameraMirror as! Bool;
        }

        // 美颜设置
        self.session?.setBeautifyModeOn(cameraSetting["builtInFaceBeautyEnabled"] as! Bool);
        if cameraSetting["faceBeauty"] != nil {
            let faceBeauty = cameraSetting["faceBeauty"] as! [String: Any];
            // 红润
            self.session?.setRedden(faceBeauty["redden"] as! CGFloat);
            // 美白
            self.session?.setWhiten(faceBeauty["whiten"] as! CGFloat);
            // 美颜等级
            self.session?.setBeautify(faceBeauty["beautyLevel"] as! CGFloat);
        }

        // 自动对焦
        if let continuousFocusModeEnabled = cameraSetting["continuousFocusModeEnabled"] {
            session?.isContinuousAutofocusEnable = continuousFocusModeEnabled as! Bool;
        }
    }

    /**
     *  加载系统参数配置
     */
    private func loadStreamingProfile(_ streamingProfileStr: Any?) {
        if streamingProfileStr == nil || streamingProfileStr is NSNull {
            return;
        }
        let streamingProfile = JsonUtil.getDictionaryFromJSONString(jsonString: streamingProfileStr as! String);

        // 推流地址
        if let publishUrl = streamingProfile["publishUrl"] {
            self.session?.pushURL = URL(string: publishUrl as! String);
        }

        // 视频质量
        if let videoQuality = streamingProfile["videoQuality"] {
            var result = "";
            switch videoQuality as! Int {
            case 0:
                result = kPLVideoStreamingQualityLow1;
                break;
            case 1:
                result = kPLVideoStreamingQualityLow2;
                break;
            case 3:
                result = kPLVideoStreamingQualityLow3;
                break;
            case 10:
                result = kPLVideoStreamingQualityMedium1;
                break;
            case 11:
                result = kPLVideoStreamingQualityMedium2;
                break;
            case 12:
                result = kPLVideoStreamingQualityMedium3;
                break;
            case 20:
                result = kPLVideoStreamingQualityHigh1;
                break;
            case 21:
                result = kPLVideoStreamingQualityHigh2;
                break;
            case 22:
                result = kPLVideoStreamingQualityHigh3;
                break;
            default:
                break;
            }
            self.videoStreamingConfig = PLVideoStreamingConfiguration.init(videoQuality: result);
        }

        // 音频质量
        if let audioQuality = streamingProfile["audioQuality"] {
            var result = "";
            switch audioQuality as! Int {
            case 20:
                result = kPLAudioStreamingQualityHigh2;
                break;
            case 21:
                result = kPLAudioStreamingQualityHigh3;
                break;
            default:
                break;
            }
            self.audioStreamingConfig = PLAudioStreamingConfiguration.init(audioQuality: result);
        }

        // 是否启用 QUIC 推流
        if let quicEnable = streamingProfile["quicEnable"] {
            session?.isQuicEnable = quicEnable as! Bool;
        }
    }

    /**
     *  加载连麦参数配置
     */
    private func loadConnectOptions(_ connectOptiionsStr: Any?) {
        if connectOptiionsStr == nil || connectOptiionsStr is NSNull {
            return;
        }
        let connectOptiions = JsonUtil.getDictionaryFromJSONString(jsonString: connectOptiionsStr as! String)

        // 编码方向
        if let videoEncodingOrientation = connectOptiions["videoEncodingOrientation"] {
            if (videoEncodingOrientation as! String) == "PORT" {
                session?.videoOrientation = AVCaptureVideoOrientation.portrait;
            }

            if (videoEncodingOrientation as! String) == "LAND" {
                session?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft;
            }
        }
    }

    /**
     * 打开摄像头和麦克风采集
     */
    private func resume(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.invokeListener(type: PushCallBackNoticeEnum.StateChanged, params: "PREPARING");
        session?.startCapture();
        result(true);
        self.invokeListener(type: PushCallBackNoticeEnum.StateChanged, params: "READY");
    }


    /**
     * 关闭摄像头和麦克风采集
     */
    private func pause(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session?.stopCapture();
        result(nil);
    }

    /**
     * 开始连麦
     */
    private func startConference(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let userId = CommonUtils.getParam(call: call, result: result, param: "userId") as? String,
           let roomName = CommonUtils.getParam(call: call, result: result, param: "roomName") as? String,
           let roomToken = CommonUtils.getParam(call: call, result: result, param: "roomToken") as? String {
            session?.startConference(withRoomName: roomName, userID: userId, roomToken: roomToken, rtcConfiguration: PLRTCConfiguration())
            result(nil);
        }
    }

    /**
     * 停止连麦
     */
    private func stopConference(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session?.stopConference();
        result(nil);
    }

    /**
     * 开始推流
     */
    private func startStreaming(call: FlutterMethodCall, result: @escaping FlutterResult) {
        var publishUrl = ((call.arguments as! [String: Any])["publishUrl"]) as? String;
        publishUrl = publishUrl ?? session?.pushURL.absoluteString;

        // 开始推流
        session?.startStreaming(withPush: URL(string: publishUrl!), feedback: {
            (feedback: PLStreamStartStateFeedback) -> Void in
            result(feedback == PLStreamStartStateFeedback.success);
        });
    }

    /**
     * 停止推流
     */
    private func stopStreaming(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session?.stopStreaming();
        result(nil);
    }

    /**
     * 销毁
     */
    private func destroy(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session?.destroy();
        result(nil);
    }

    /**
     * 查询是否支持缩放
     */
    private func isZoomSupported(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(true);
    }

    /**
     * 设置缩放比例
     */
    private func setZoomValue(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let value = CommonUtils.getParam(call: call, result: result, param: "value") as? Int {
            session?.videoZoomFactor = CGFloat(value);
            result(nil);
        }
    }

    /**
     * 获得最大缩放比例
     */
    private func getMaxZoom(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Int(session!.videoActiveFormat.videoMaxZoomFactor));
    }

    /**
     * 获得缩放比例
     */
    private func getZoom(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Int(session!.videoZoomFactor));
    }

    /**
     * 开启闪光灯
     */
    private func turnLightOn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session!.isTorchOn = true;
        result(nil);
    }

    /**
     * 关闭闪光灯
     */
    private func turnLightOff(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session!.isTorchOn = false;
        result(nil);
    }

    /**
     * 切换摄像头
     */
    private func switchCamera(call: FlutterMethodCall, result: @escaping FlutterResult) {
        session?.toggleCamera();
        result(true);
    }

    /**
     * 切换静音
     */
    private func mute(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let mute = CommonUtils.getParam(call: call, result: result, param: "mute") as? Bool,
           let audioSource = CommonUtils.getParam(call: call, result: result, param: "audioSource") as? String {
            if audioSource == "MIC" {
                session?.isMuted = mute;
                session?.isMuteMixedAudio = mute;
            }
            if audioSource == "SPEAKER" {
                session?.isMuteSpeaker = mute;
            }
            result(nil);
        }
    }


    /**
     * 根据用户ID踢人
     */
    private func kickoutUser(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let userId = CommonUtils.getParam(call: call, result: result, param: "userId") as? String {
            session?.kickoutUserID(userId)
            result(nil);
        }
    }

    /**
     * 设置连麦参数
     */
    private func setConferenceOptions(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(nil);
    }


    /**
     * 更新推流参数
     */
    private func setStreamingProfile(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.session!.reloadVideoStreamingConfiguration(videoStreamingConfig);
        result(nil);
    }

    /**
     * 获取参与连麦的人数，不包括自己
     */
    private func getParticipantsCount(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 获取参与连麦的用户ID列表，不包括自己
     */
    private func getParticipants(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 设置预览镜像
     */
    private func setPreviewMirror(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let mirror = CommonUtils.getParam(call: call, result: result, param: "mirror") as? Bool {
            session?.previewMirrorFrontFacing = mirror;
            result(true);
        }
    }

    /**
     * 设置推流镜像
     */
    private func setEncodingMirror(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let mirror = CommonUtils.getParam(call: call, result: result, param: "mirror") as? Bool {
            session?.streamMirrorFrontFacing = mirror;
            result(true);
        }
    }

    /**
     * 开启耳返
     */
    private func startPlayback(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 关闭耳返
     */
    private func stopPlayback(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 更新动态水印
     */
    private func updateWatermarkSetting(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 更新美颜设置
     */
    private func updateFaceBeautySetting(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let redden = CommonUtils.getParam(call: call, result: result, param: "redden") as? CGFloat,
           let whiten = CommonUtils.getParam(call: call, result: result, param: "whiten") as? CGFloat,
           let beautyLevel = CommonUtils.getParam(call: call, result: result, param: "beautyLevel") as? CGFloat {
            self.session?.setRedden(redden);
            self.session?.setWhiten(whiten);
            self.session?.setBeautify(beautyLevel);
            result(nil);
        }
    }

    /**
     * 添加远程视图
     */
    private func addRemoteWindow(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 获取编码器输出的画面的高宽
     */
    private func getVideoEncodingSize(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 自定义视频窗口位置(连麦推流模式下有效)
     */
    private func setLocalWindowPosition(call: FlutterMethodCall, result: @escaping FlutterResult) {

    }

    /**
     * 调用监听器
     *
     * @param type   类型
     * @param params 参数
     */
    private func invokeListener(type: PushCallBackNoticeEnum, params: Any?) {
        var resultParams: [String: Any] = [:];
        resultParams["type"] = type;
        if let p = params {
            resultParams["params"] = JsonUtil.toJson(p);
        }

        self.channel!.invokeMethod(QiniucloudPushPlatformView.LISTENER_FUNC_NAME, arguments: JsonUtil.toJson(resultParams));
    }


    /**
     *  RTC状态发生改变
     */
    public func mediaStreamingSession(_ session: PLMediaStreamingSession!, rtcStateDidChange state: PLRTCState) {
        print(1);
    }

    /**
     *  媒体流状态发生改变
     */
    public func mediaStreamingSession(_ session: PLMediaStreamingSession!, streamStateDidChange state: PLStreamState) {
        if state == PLStreamState.connected {
            self.invokeListener(type: PushCallBackNoticeEnum.StateChanged, params: "CONNECTING");
        }
        if state == PLStreamState.disconnected {
            self.invokeListener(type: PushCallBackNoticeEnum.StateChanged, params: "DISCONNECTED");
        }
    }

    /**
     *  媒体流实时状态发生改变
     */
    public func mediaStreamingSession(_ session: PLMediaStreamingSession!, streamStatusDidUpdate status: PLStreamStatus!) {
        self.invokeListener(type: PushCallBackNoticeEnum.StateChanged, params: "STREAMING");
        self.invokeListener(type: PushCallBackNoticeEnum.StreamStatusChanged, params: [
            "audioFps": status.audioFPS,
            "videoFps": status.videoFPS,
            "totalAVBitrate": status.totalBitrate
        ]);
    }

    /**
     *  连接错误
     */
    public func mediaStreamingSession(_ session: PLMediaStreamingSession!, didDisconnectWithError error: Error!) {
        self.invokeListener(type: PushCallBackNoticeEnum.StateChanged, params: "IOERROR");
    }

}
