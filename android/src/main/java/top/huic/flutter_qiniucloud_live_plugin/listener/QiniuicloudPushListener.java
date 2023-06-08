package top.huic.flutter_qiniucloud_live_plugin.listener;

import android.content.Context;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;

import com.alibaba.fastjson.JSON;
import com.qiniu.pili.droid.rtcstreaming.RTCAudioLevelCallback;
import com.qiniu.pili.droid.streaming.AudioSourceCallback;
import com.qiniu.pili.droid.streaming.StreamStatusCallback;
import com.qiniu.pili.droid.streaming.StreamingProfile;
import com.qiniu.pili.droid.streaming.StreamingSessionListener;
import com.qiniu.pili.droid.streaming.StreamingState;
import com.qiniu.pili.droid.streaming.StreamingStateChangedListener;
import com.qiniu.pili.droid.streaming.SurfaceTextureCallback;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import top.huic.flutter_qiniucloud_live_plugin.enums.PushCallBackNoticeEnum;

/**
 * 七牛云连麦推流监听器
 *
 * @author 蒋具宏
 */
public class QiniuicloudPushListener implements StreamingSessionListener, StreamingStateChangedListener, StreamStatusCallback, AudioSourceCallback, SurfaceTextureCallback, RTCAudioLevelCallback {

    /**
     * 日志标签
     */
    private static final String TAG = QiniuicloudPushListener.class.getName();

    /**
     * 监听器回调的方法名
     */
    private final static String LISTENER_FUNC_NAME = "onPushListener";

    /**
     * 回调监听器
     */
    public static SurfaceTextureCallback callback;

    /**
     * 全局上下文
     */
    private Context context;

    /**
     * 通信管道
     */
    private MethodChannel channel;

    public QiniuicloudPushListener(Context context, MethodChannel channel) {
        this.context = context;
        this.channel = channel;
    }

    /**
     * 调用监听器
     *
     * @param type   类型
     * @param params 参数
     */
    private void invokeListener(final PushCallBackNoticeEnum type, final Object params) {
        invokeListener(type, params, null, true);
    }


    /**
     * 调用监听器
     *
     * @param type      类型
     * @param params    参数
     * @param callback  回调
     * @param jsonParam 是否序列化参数
     */
    private void invokeListener(final PushCallBackNoticeEnum type, final Object params, final MethodChannel.Result callback, final boolean jsonParam) {
        // 切换到主线程
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                Map<String, Object> resultParams = new HashMap<>(2, 1);
                resultParams.put("type", type);
                resultParams.put("params", params == null ? null : (jsonParam ? JSON.toJSONString(params) : params));
                channel.invokeMethod(LISTENER_FUNC_NAME, JSON.toJSONString(resultParams), callback);
            }
        });
    }

    @Override
    public boolean onRecordAudioFailedHandled(int i) {
        invokeListener(PushCallBackNoticeEnum.RecordAudioFailedHandled, i);
        return false;
    }

    @Override
    public boolean onRestartStreamingHandled(int i) {
        invokeListener(PushCallBackNoticeEnum.RestartStreamingHandled, i);
        return false;
    }

    @Override
    public Camera.Size onPreviewSizeSelected(List<Camera.Size> list) {
        invokeListener(PushCallBackNoticeEnum.PreviewSizeSelected, list);
        return null;
    }

    @Override
    public int onPreviewFpsSelected(List<int[]> list) {
        invokeListener(PushCallBackNoticeEnum.PreviewFpsSelected, list);
        return 0;
    }

    @Override
    public void onStateChanged(StreamingState status, Object extra) {
        invokeListener(PushCallBackNoticeEnum.StateChanged, status, null, false);
    }

    @Override
    public void onAudioSourceAvailable(ByteBuffer srcBuffer, int size, long tsInNanoTime, boolean isEof) {
        Map<String, Object> params = new HashMap<>(4, 1);
        params.put("srcBuffer", srcBuffer.array());
        params.put("size", size);
        params.put("tsInNanoTime", tsInNanoTime);
        params.put("isEof", isEof);
        invokeListener(PushCallBackNoticeEnum.AudioSourceAvailable, params);
    }

    @Override
    public void notifyStreamStatusChanged(StreamingProfile.StreamStatus streamStatus) {
        invokeListener(PushCallBackNoticeEnum.StreamStatusChanged, streamStatus);
    }

    @Override
    public void onSurfaceCreated() {

    }

    @Override
    public void onSurfaceChanged(int i, int i1) {

    }

    @Override
    public void onSurfaceDestroyed() {

    }

    @Override
    public int onDrawFrame(final int texId, int width, int height, float[] transformMatrix) {
        if (callback != null) {
            return callback.onDrawFrame(texId, width, height, transformMatrix);
        }
        return texId;
    }

    @Override
    public void onAudioLevelChanged(String userId, int level) {
        System.out.println("userId:" + userId + ",level:" + level);
    }
}
