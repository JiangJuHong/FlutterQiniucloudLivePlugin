package top.huic.flutter_qiniucloud_live_plugin.view;

import android.content.Context;
import android.util.Log;
import android.view.View;

import com.alibaba.fastjson.JSON;
import com.qiniu.android.dns.DnsManager;
import com.qiniu.android.dns.IResolver;
import com.qiniu.android.dns.NetworkInfo;
import com.qiniu.android.dns.http.DnspodFree;
import com.qiniu.android.dns.local.AndroidDnsServer;
import com.qiniu.android.dns.local.Resolver;
import com.qiniu.pili.droid.streaming.AVCodecType;
import com.qiniu.pili.droid.streaming.CameraStreamingSetting;
import com.qiniu.pili.droid.streaming.MediaStreamingManager;
import com.qiniu.pili.droid.streaming.MicrophoneStreamingSetting;
import com.qiniu.pili.droid.streaming.StreamingProfile;
import com.qiniu.pili.droid.streaming.WatermarkSetting;

import java.io.IOException;
import java.net.InetAddress;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import top.huic.flutter_qiniucloud_live_plugin.listener.QiniucloudPushListener;
import top.huic.flutter_qiniucloud_live_plugin.widget.CameraPreviewFrameView;
import top.huic.flutter_qiniucloud_live_plugin.util.CommonUtil;

/**
 * 七牛云推流视图
 */
public class QiniucloudPushPlatformView extends PlatformViewFactory implements PlatformView, MethodChannel.MethodCallHandler {
    /**
     * 日志标签
     */
    private static final String TAG = QiniucloudPushPlatformView.class.getName();

    /**
     * 全局上下文
     */
    private Context context;

    /**
     * 消息器
     */
    private BinaryMessenger messenger;

    /**
     * 全局标识
     */
    public static final String SIGN = "plugins.huic.top/QiniucloudPush";

    /**
     * 视图对象
     */
    private CameraPreviewFrameView view;

    /**
     * 流管理器
     */
    private MediaStreamingManager manager;

    /**
     * 初始化视图工厂，注册视图时调用
     */
    public QiniucloudPushPlatformView(Context context, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        this.messenger = messenger;
    }

    /**
     * 初始化组件，同时也初始化七牛云推流
     * 每个组件被实例化时调用
     */
    private QiniucloudPushPlatformView(Context context) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
    }


    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        QiniucloudPushPlatformView view = new QiniucloudPushPlatformView(context);
        // 绑定方法监听器
        MethodChannel methodChannel = new MethodChannel(messenger, SIGN + "_" + viewId);
        methodChannel.setMethodCallHandler(view);
        // 初始化
        view.init(params, methodChannel);
        return view;
    }

    @Override
    public View getView() {
        return view;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "resume":
                this.resume(call, result);
                break;
            case "pause":
                this.pause(call, result);
                break;
            case "destroy":
                this.destroy(call, result);
                break;
            case "startStreaming":
                this.startStreaming(call, result);
                break;
            case "stopStreaming":
                this.stopStreaming(call, result);
                break;
            case "isZoomSupported":
                this.isZoomSupported(call, result);
                break;
            case "setZoomValue":
                this.setZoomValue(call, result);
                break;
            case "getZoom":
                this.getZoom(call, result);
                break;
            case "getMaxZoom":
                this.getMaxZoom(call, result);
                break;
            case "turnLightOn":
                this.turnLightOn(call, result);
                break;
            case "turnLightOff":
                this.turnLightOff(call, result);
                break;
            case "switchCamera":
                this.switchCamera(call, result);
                break;
            case "mute":
                this.mute(call, result);
                break;
            case "setNativeLoggingEnabled":
                this.setNativeLoggingEnabled(call, result);
                break;
            case "updateWatermarkSetting":
                this.updateWatermarkSetting(call, result);
                break;
            case "updateFaceBeautySetting":
                this.updateFaceBeautySetting(call, result);
                break;
            case "setPreviewMirror":
                this.setPreviewMirror(call, result);
                break;
            case "setEncodingMirror":
                this.setEncodingMirror(call, result);
                break;
            default:
                result.notImplemented();
        }
    }


    /**
     * 获得DNS管理器
     */
    private DnsManager getDnsManager() {
        IResolver r0 = new DnspodFree();
        IResolver r1 = AndroidDnsServer.defaultResolver();
        IResolver r2 = null;
        try {
            r2 = new Resolver(InetAddress.getByName("119.29.29.29"));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return new DnsManager(NetworkInfo.normal, new IResolver[]{r0, r1, r2});
    }

    /**
     * 初始化七牛云推流信息
     *
     * @param params        参数
     * @param methodChannel 方法通道
     */
    private void init(Map<String, Object> params, MethodChannel methodChannel) {
        // 系统参数
        String streamingProfileStr = (String) params.get("streamingProfile");
        // 相机参数
        String cameraSettingStr = (String) params.get("cameraStreamingSetting");
        Map<String, Object> cameraSettingMap = JSON.parseObject(cameraSettingStr);
        // 初始化视图
        view = new CameraPreviewFrameView(context);

        // 主要参数设置
        StreamingProfile mProfile = JSON.parseObject(streamingProfileStr, StreamingProfile.class);
        if (mProfile == null) {
            Log.e(TAG, "init: 系统参数初始化失败!");
        } else {
            // 缺省参数设置
            mProfile.setDnsManager(this.getDnsManager());
        }

        // 预览设置
        CameraStreamingSetting cameraStreamingSetting = JSON.parseObject(cameraSettingStr, CameraStreamingSetting.class);
        if (cameraStreamingSetting == null) {
            Log.e(TAG, "init: 相机信息初始化失败!");
        } else {
            // 美颜过滤(设置美颜后，启用美颜过滤，没设置美颜，则自动过滤空)
            cameraStreamingSetting.setVideoFilter(CameraStreamingSetting.VIDEO_FILTER_TYPE.VIDEO_FILTER_BEAUTY);

            // 美颜设置
            Map faceBeauty = (Map) cameraSettingMap.get("faceBeauty");
            if (faceBeauty != null) {
                cameraStreamingSetting.setFaceBeautySetting(new CameraStreamingSetting.FaceBeautySetting(Float.valueOf(faceBeauty.get("beautyLevel").toString()), Float.valueOf(faceBeauty.get("whiten").toString()), Float.valueOf(faceBeauty.get("redden").toString())));
            }
        }

        // 麦克风设置
        MicrophoneStreamingSetting microphoneStreamingSetting = new MicrophoneStreamingSetting();
        microphoneStreamingSetting.setBluetoothSCOEnabled(true);

        // 流管理实现
        manager = new MediaStreamingManager(context, view, AVCodecType.SW_VIDEO_WITH_SW_AUDIO_CODEC);  // soft codec
        manager.prepare(cameraStreamingSetting, microphoneStreamingSetting, mProfile);

        // 绑定监听器
        QiniucloudPushListener listener = new QiniucloudPushListener(context, methodChannel);
        manager.setStreamingStateListener(listener);
        manager.setStreamingSessionListener(listener);
        manager.setStreamStatusCallback(listener);
        manager.setAudioSourceCallback(listener);
    }

    /**
     * 开启摄像头预览
     */
    private void resume(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.resume());
    }

    /**
     * 退出 MediaStreamingManager，该操作会主动断开当前的流链接，并关闭 Camera 和释放相应的资源。
     */
    private void pause(MethodCall call, final MethodChannel.Result result) {
        manager.pause();
        result.success(null);
    }

    /**
     * 释放不紧要资源。
     */
    private void destroy(MethodCall call, final MethodChannel.Result result) {
        manager.destroy();
        result.success(null);
    }

    /**
     * 开始推流
     */
    private void startStreaming(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.startStreaming());
    }

    /**
     * 停止推流
     */
    private void stopStreaming(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.stopStreaming());
    }

    /**
     * 查询是否支持缩放
     */
    private void isZoomSupported(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.isZoomSupported());
    }

    /**
     * 设置缩放比例
     */
    private void setZoomValue(MethodCall call, final MethodChannel.Result result) {
        int value = CommonUtil.getParam(call, result, "value");
        manager.setZoomValue(value);
        result.success(null);
    }

    /**
     * 获得最大缩放比例
     */
    private void getMaxZoom(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.getMaxZoom());
    }

    /**
     * 获得缩放比例
     */
    private void getZoom(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.getZoom());
    }

    /**
     * 开启闪光灯
     */
    private void turnLightOn(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.turnLightOn());
    }

    /**
     * 关闭闪光灯
     */
    private void turnLightOff(MethodCall call, final MethodChannel.Result result) {
        result.success(manager.turnLightOff());
    }

    /**
     * 切换摄像头
     */
    private void switchCamera(MethodCall call, final MethodChannel.Result result) {
        // 指定摄像头
        String target = call.argument("target");
        CameraStreamingSetting.CAMERA_FACING_ID id = target == null ? null : CameraStreamingSetting.CAMERA_FACING_ID.valueOf(target);
        boolean executeResult;
        if (id == null) {
            executeResult = manager.switchCamera();
        } else {
            executeResult = manager.switchCamera(id);
        }
        result.success(executeResult);
    }

    /**
     * 切换静音
     */
    private void mute(MethodCall call, final MethodChannel.Result result) {
        boolean mute = CommonUtil.getParam(call, result, "mute");
        manager.mute(mute);
        result.success(null);
    }

    /**
     * 启用/关闭日志
     */
    private void setNativeLoggingEnabled(MethodCall call, final MethodChannel.Result result) {
        boolean enabled = CommonUtil.getParam(call, result, "enabled");
        manager.setNativeLoggingEnabled(enabled);
        result.success(null);
    }

    /**
     * 更新动态水印
     */
    private void updateWatermarkSetting(MethodCall call, final MethodChannel.Result result) {
        WatermarkSetting watermarkSetting = new WatermarkSetting(context);
        watermarkSetting.setResourcePath(CommonUtil.getParam(call, result, "resourcePath").toString());
        watermarkSetting.setSize(WatermarkSetting.WATERMARK_SIZE.valueOf(CommonUtil.getParam(call, result, "size").toString()));
        watermarkSetting.setLocation(WatermarkSetting.WATERMARK_LOCATION.valueOf(CommonUtil.getParam(call, result, "location").toString()));
        watermarkSetting.setAlpha(Integer.valueOf(CommonUtil.getParam(call, result, "alpha").toString()));
        manager.updateWatermarkSetting(watermarkSetting);
        result.success(null);
    }

    /**
     * 更新美颜设置
     */
    private void updateFaceBeautySetting(MethodCall call, final MethodChannel.Result result) {
        double beautyLevel = CommonUtil.getParam(call, result, "beautyLevel");
        double redden = CommonUtil.getParam(call, result, "redden");
        double whiten = CommonUtil.getParam(call, result, "whiten");
        manager.setVideoFilterType(CameraStreamingSetting.VIDEO_FILTER_TYPE.VIDEO_FILTER_BEAUTY);
        manager.updateFaceBeautySetting(new CameraStreamingSetting.FaceBeautySetting((float) beautyLevel, (float) whiten, (float) redden));
        result.success(null);
    }

    /**
     * 设置预览镜像
     */
    private void setPreviewMirror(MethodCall call, final MethodChannel.Result result) {
        boolean mirror = CommonUtil.getParam(call, result, "mirror");
        result.success(manager.setPreviewMirror(mirror));
    }

    /**
     * 设置推流镜像
     */
    private void setEncodingMirror(MethodCall call, final MethodChannel.Result result) {
        boolean mirror = CommonUtil.getParam(call, result, "mirror");
        result.success(manager.setEncodingMirror(mirror));
    }
}