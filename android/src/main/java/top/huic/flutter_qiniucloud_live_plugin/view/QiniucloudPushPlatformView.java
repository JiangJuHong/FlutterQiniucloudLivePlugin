package top.huic.flutter_qiniucloud_live_plugin.view;

import android.content.Context;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.widget.RelativeLayout;

import com.alibaba.fastjson.JSON;
import com.qiniu.pili.droid.streaming.AVCodecType;
import com.qiniu.pili.droid.streaming.CameraStreamingSetting;
import com.qiniu.pili.droid.streaming.MediaStreamingManager;
import com.qiniu.pili.droid.streaming.StreamStatusCallback;
import com.qiniu.pili.droid.streaming.StreamingProfile;
import com.qiniu.pili.droid.streaming.StreamingState;
import com.qiniu.pili.droid.streaming.StreamingStateChangedListener;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import top.huic.flutter_qiniucloud_live_plugin.listener.QiniucloudPushListener;
import top.huic.flutter_qiniucloud_live_plugin.ui.CameraPreviewFrameView;
import top.huic.flutter_qiniucloud_live_plugin.util.CommonUtil;

/**
 * 七牛云推流视图(主播)
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
        view.init(params.get("url").toString(), methodChannel);
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
        Log.d(TAG, "调用方法: " + call.method);
        switch (call.method) {
            case "startStreaming":
                this.startStreaming(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    /**
     * 初始化七牛云推流
     *
     * @param url           推流地址
     * @param methodChannel 方法通道
     */
    private void init(String url, MethodChannel methodChannel) {
        Log.d(TAG, "init push,address:`" + url + "`");
        try {
            // 初始化视图
            view = new CameraPreviewFrameView(context);

            // 主要参数设置
            StreamingProfile mProfile = new StreamingProfile();
            mProfile.setVideoQuality(StreamingProfile.VIDEO_QUALITY_HIGH1)
                    .setAudioQuality(StreamingProfile.AUDIO_QUALITY_MEDIUM2)
                    .setEncodingSizeLevel(StreamingProfile.VIDEO_ENCODING_HEIGHT_480)
                    .setEncoderRCMode(StreamingProfile.EncoderRCModes.QUALITY_PRIORITY)
                    .setPublishUrl(url);

            // 预览设置
            CameraStreamingSetting camerasetting = new CameraStreamingSetting();
            camerasetting.setCameraId(Camera.CameraInfo.CAMERA_FACING_BACK)
                    .setContinuousFocusModeEnabled(true)
                    .setCameraPrvSizeLevel(CameraStreamingSetting.PREVIEW_SIZE_LEVEL.MEDIUM)
                    .setCameraPrvSizeRatio(CameraStreamingSetting.PREVIEW_SIZE_RATIO.RATIO_16_9);

            // 流管理实现
            manager = new MediaStreamingManager(context, view, AVCodecType.SW_VIDEO_WITH_SW_AUDIO_CODEC);  // soft codec
            manager.prepare(camerasetting, mProfile);

            // 绑定监听器
            QiniucloudPushListener listener = new QiniucloudPushListener(context, methodChannel);
            manager.setStreamingStateListener(listener);
            manager.setStreamingSessionListener(listener);
            manager.setStreamStatusCallback(listener);
            manager.setAudioSourceCallback(listener);

            // 开启预览
            manager.resume();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    /**
     * 开始推流
     */
    private void startStreaming(MethodCall call, final MethodChannel.Result result) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                final boolean execResult = manager.startStreaming();
                // 切换到主线程
                Handler mainHandler = new Handler(Looper.getMainLooper());
                mainHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        result.success(execResult);
                    }
                });
            }
        }).start();
    }
}