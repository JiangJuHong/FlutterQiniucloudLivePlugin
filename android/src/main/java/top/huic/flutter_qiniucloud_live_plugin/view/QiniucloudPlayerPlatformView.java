package top.huic.flutter_qiniucloud_live_plugin.view;


import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.pili.pldroid.player.widget.PLVideoTextureView;
import com.pili.pldroid.player.widget.PLVideoView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import top.huic.flutter_qiniucloud_live_plugin.util.CommonUtil;
import top.huic.flutter_qiniucloud_live_plugin.widget.MediaController;

/**
 * 七牛云播放器视图
 */
public class QiniucloudPlayerPlatformView extends PlatformViewFactory implements PlatformView, MethodChannel.MethodCallHandler {

    /**
     * 日志标签
     */
    private static final String TAG = QiniucloudPlayerPlatformView.class.getName();

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
    public static final String SIGN = "plugins.huic.top/QiniucloudPlayer";

    /**
     * 播放器
     */
    private PLVideoView view;

    /**
     * 初始化视图工厂，注册视图时调用
     */
    public QiniucloudPlayerPlatformView(Context context, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        this.messenger = messenger;
    }

    /**
     * 初始化组件，同时也初始化七牛云推流
     * 每个组件被实例化时调用
     */
    private QiniucloudPlayerPlatformView(Context context) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG, "调用方法: " + call.method);
        switch (call.method) {
            case "setVideoPath":
                this.setVideoPath(call, result);
                break;
            case "setDisplayAspectRatio":
                this.setDisplayAspectRatio(call, result);
                break;
            case "start":
                this.start(call, result);
                break;
            case "pause":
                this.pause(call, result);
                break;
            case "stopPlayback":
                this.stopPlayback(call, result);
                break;
            case "getRtmpVideoTimestamp":
                this.getRtmpVideoTimestamp(call, result);
                break;
            case "getRtmpAudioTimestamp":
                this.getRtmpAudioTimestamp(call, result);
                break;
            case "setBufferingEnabled":
                this.setBufferingEnabled(call, result);
                break;
            case "getHttpBufferSize":
                this.getHttpBufferSize(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        QiniucloudPlayerPlatformView view = new QiniucloudPlayerPlatformView(context);
        // 绑定方法监听器
        MethodChannel methodChannel = new MethodChannel(messenger, SIGN + "_" + viewId);
        methodChannel.setMethodCallHandler(view);
        // 初始化
        view.init(params, methodChannel);
        return view;
    }

    @Override
    public void dispose() {

    }

    @Override
    public View getView() {
        return view;
    }

    /**
     * 初始化
     *
     * @param params        参数
     * @param methodChannel 方法通道
     */
    private void init(Map<String, Object> params, MethodChannel methodChannel) {
        // 初始化视图
        view = new PLVideoView(context);
        view.setMediaController(new MediaController(context));
        TextView textView = new TextView(context);
        textView.setText("内容加载中");
        view.setBufferingIndicator(textView);
    }

    /**
     * 设置视频路径
     */
    private void setVideoPath(MethodCall call, MethodChannel.Result result) {
        String url = CommonUtil.getParam(call, result, "url");
        view.setVideoPath(url);
        result.success(null);
    }

    /**
     * 设置画面预览模式
     */
    private void setDisplayAspectRatio(MethodCall call, MethodChannel.Result result) {
        int mode = CommonUtil.getParam(call, result, "mode");
        view.setDisplayAspectRatio(mode);
        result.success(null);
    }

    /**
     * 播放
     */
    private void start(MethodCall call, MethodChannel.Result result) {
        view.start();
        result.success(null);
    }

    /**
     * 暂停
     */
    private void pause(MethodCall call, MethodChannel.Result result) {
        view.pause();
        result.success(null);
    }

    /**
     * 停止播放
     */
    private void stopPlayback(MethodCall call, MethodChannel.Result result) {
        view.stopPlayback();
        result.success(null);
    }

    /**
     * 在RTMP消息中获取视频时间戳
     */
    private void getRtmpVideoTimestamp(MethodCall call, MethodChannel.Result result) {
        result.success(view.getRtmpVideoTimestamp());
    }

    /**
     * 在RTMP消息中获取音频时间戳
     */
    private void getRtmpAudioTimestamp(MethodCall call, MethodChannel.Result result) {
        result.success(view.getRtmpAudioTimestamp());
    }

    /**
     * 暂停/恢复播放器的预缓冲
     */
    private void setBufferingEnabled(MethodCall call, MethodChannel.Result result) {
        boolean enabled = CommonUtil.getParam(call, result, "enabled");
        view.setBufferingEnabled(enabled);
        result.success(null);
    }

    /**
     * 获取已经缓冲的长度
     */
    private void getHttpBufferSize(MethodCall call, MethodChannel.Result result) {
        result.success(view.getHttpBufferSize());
    }
}
