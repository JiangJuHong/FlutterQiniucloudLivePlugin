package top.huic.flutter_qiniucloud_live_plugin.view;


import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.qiniu.pili.droid.rtcstreaming.RTCConferenceOptions;
import com.qiniu.pili.droid.rtcstreaming.RTCMediaStreamingManager;
import com.qiniu.pili.droid.rtcstreaming.RTCSurfaceView;
import com.qiniu.pili.droid.rtcstreaming.RTCVideoWindow;
import com.qiniu.pili.droid.streaming.AVCodecType;
import com.qiniu.pili.droid.streaming.CameraStreamingSetting;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import top.huic.flutter_qiniucloud_live_plugin.util.CommonUtil;
import top.huic.flutter_qiniucloud_live_plugin.util.ConnectedUtil;
import top.huic.flutter_qiniucloud_live_plugin.widget.CameraPreviewFrameView;

/**
 * 七牛云连麦推流视图
 */
public class QiniucloudConnectedPlayerPlatformView extends PlatformViewFactory implements PlatformView, MethodChannel.MethodCallHandler {

    /**
     * 日志标签
     */
    private static final String TAG = QiniucloudConnectedPlayerPlatformView.class.getName();

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
    public static final String SIGN = "plugins.huic.top/QiniucloudConnectedPlayer";

    /**
     * 视图管理器
     */
    private RTCVideoWindow window;

    /**
     * 视图ID
     */
    private int viewId;

    /**
     * 预览视图
     */
    private RTCSurfaceView view;

    /**
     * 初始化视图工厂，注册视图时调用
     */
    public QiniucloudConnectedPlayerPlatformView(Context context, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        this.messenger = messenger;
    }

    /**
     * 初始化组件，同时也初始化七牛云推流
     * 每个组件被实例化时调用
     */
    private QiniucloudConnectedPlayerPlatformView(Context context) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "setAbsoluteMixOverlayRect":
                this.setAbsoluteMixOverlayRect(call, result);
                break;
            case "setRelativeMixOverlayRect":
                this.setRelativeMixOverlayRect(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        this.viewId = viewId;
        Map<String, Object> params = (Map<String, Object>) args;
        QiniucloudConnectedPlayerPlatformView view = new QiniucloudConnectedPlayerPlatformView(context);
        // 绑定方法监听器
        MethodChannel methodChannel = new MethodChannel(messenger, SIGN + "_" + viewId);
        methodChannel.setMethodCallHandler(view);
        // 初始化
        view.init(params, methodChannel);
        // 添加到视图队列
        ConnectedUtil.add(this.viewId, view);
        return view;
    }

    @Override
    public void dispose() {
        ConnectedUtil.remove(this.viewId);
    }

    @Override
    public View getView() {
        return window.getRTCSurfaceView();
    }

    /**
     * 初始化
     *
     * @param params        参数
     * @param methodChannel 方法通道
     */
    private void init(Map<String, Object> params, MethodChannel methodChannel) {
        // 初始化视图
        view = new RTCSurfaceView(context);
        window = new RTCVideoWindow(view);
    }

    /**
     * 配置连麦合流的参数（仅主播才配置，连麦观众不用）
     * 使用绝对值来配置该窗口在合流画面中的位置和大小
     */
    private void setAbsoluteMixOverlayRect(MethodCall call, MethodChannel.Result result) {
        int x = CommonUtil.getParam(call, result, "x");
        int y = CommonUtil.getParam(call, result, "y");
        int w = CommonUtil.getParam(call, result, "w");
        int h = CommonUtil.getParam(call, result, "h");
        window.setAbsoluteMixOverlayRect(x, y, w, h);
        result.success(null);
    }

    /**
     * 配置连麦合流的参数（仅主播才配置，连麦观众不用）
     * 使用相对值来配置该窗口在合流画面中的位置和大小
     */
    private void setRelativeMixOverlayRect(MethodCall call, MethodChannel.Result result) {
        int x = CommonUtil.getParam(call, result, "x");
        int y = CommonUtil.getParam(call, result, "y");
        int w = CommonUtil.getParam(call, result, "w");
        int h = CommonUtil.getParam(call, result, "h");
        window.setRelativeMixOverlayRect(x, y, w, h);
        result.success(null);
    }

    public RTCVideoWindow getWindow() {
        return window;
    }
}