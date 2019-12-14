package top.huic.flutter_qiniucloud_live_plugin.view;

import android.content.Context;
import android.hardware.Camera;
import android.util.Log;
import android.view.View;
import android.widget.RelativeLayout;

import com.qiniu.pili.droid.streaming.AVCodecType;
import com.qiniu.pili.droid.streaming.CameraStreamingSetting;
import com.qiniu.pili.droid.streaming.MediaStreamingManager;
import com.qiniu.pili.droid.streaming.StreamStatusCallback;
import com.qiniu.pili.droid.streaming.StreamingProfile;
import com.qiniu.pili.droid.streaming.StreamingState;
import com.qiniu.pili.droid.streaming.StreamingStateChangedListener;

import java.net.URISyntaxException;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
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

    private CameraPreviewFrameView view;


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
        // 初始化
        view.init(params.get("url").toString());

        // 绑定方法监听器
        new MethodChannel(messenger, SIGN + "_" + viewId).setMethodCallHandler(view);
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
//            case "init":
//                this.init(call, result);
//                break;
            default:
                result.notImplemented();
        }
    }

    /**
     * 初始化七牛云推流
     *
     * @param url 推流地址
     */
    private void init(String url) {
        Log.d(TAG, "init push,address:`" + url + "`");
        try {
            // 初始化视图
            view = new CameraPreviewFrameView(context);

            //encoding setting
            StreamingProfile mProfile = new StreamingProfile();
            mProfile.setVideoQuality(StreamingProfile.VIDEO_QUALITY_HIGH1)
                    .setAudioQuality(StreamingProfile.AUDIO_QUALITY_MEDIUM2)
                    .setEncodingSizeLevel(StreamingProfile.VIDEO_ENCODING_HEIGHT_480)
                    .setEncoderRCMode(StreamingProfile.EncoderRCModes.QUALITY_PRIORITY)
                    .setPublishUrl(url);

            //preview setting
            CameraStreamingSetting camerasetting = new CameraStreamingSetting();
            camerasetting.setCameraId(Camera.CameraInfo.CAMERA_FACING_BACK)
                    .setContinuousFocusModeEnabled(true)
                    .setCameraPrvSizeLevel(CameraStreamingSetting.PREVIEW_SIZE_LEVEL.MEDIUM)
                    .setCameraPrvSizeRatio(CameraStreamingSetting.PREVIEW_SIZE_RATIO.RATIO_16_9);
            //streaming engine init and setListener
            MediaStreamingManager mMediaStreamingManager = new MediaStreamingManager(context, view, AVCodecType.SW_VIDEO_WITH_SW_AUDIO_CODEC);  // soft codec
            mMediaStreamingManager.prepare(camerasetting, mProfile);
            mMediaStreamingManager.setStreamingStateListener(new StreamingStateChangedListener() {
                @Override
                public void onStateChanged(StreamingState streamingState, Object o) {
                    Log.i(TAG, "onStateChanged: ");
                }
            });
            mMediaStreamingManager.setStreamStatusCallback(new StreamStatusCallback() {
                @Override
                public void notifyStreamStatusChanged(StreamingProfile.StreamStatus streamStatus) {
                    Log.i(TAG, "notifyStreamStatusChanged: ");
                }
            });
            // 开启预览
            mMediaStreamingManager.resume();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }
}