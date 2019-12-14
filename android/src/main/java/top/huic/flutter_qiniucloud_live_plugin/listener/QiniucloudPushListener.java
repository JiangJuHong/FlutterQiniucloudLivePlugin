package top.huic.flutter_qiniucloud_live_plugin.listener;


import android.content.Context;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.qiniu.pili.droid.streaming.AudioSourceCallback;
import com.qiniu.pili.droid.streaming.StreamStatusCallback;
import com.qiniu.pili.droid.streaming.StreamingProfile;
import com.qiniu.pili.droid.streaming.StreamingSessionListener;
import com.qiniu.pili.droid.streaming.StreamingState;
import com.qiniu.pili.droid.streaming.StreamingStateChangedListener;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.UiThread;
import io.flutter.plugin.common.MethodChannel;
import top.huic.flutter_qiniucloud_live_plugin.enums.PushCallBackNoticeEnum;

/**
 * 七牛云推流监听器
 *
 * @author 蒋具宏
 */
public class QiniucloudPushListener implements StreamingStateChangedListener, StreamStatusCallback, AudioSourceCallback, StreamingSessionListener {
    /**
     * 日志标签
     */
    private static final String TAG = QiniucloudPushListener.class.getName();

    /**
     * 监听器回调的方法名
     */
    private final static String LISTENER_FUNC_NAME = "onPushListener";

    /**
     * 全局上下文
     */
    private Context context;

    /**
     * 通信管道
     */
    private MethodChannel channel;

    public QiniucloudPushListener(Context context, MethodChannel channel) {
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

        // 切换到主线程
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                Log.d(TAG, "invokeListener: 触发监听:" + type + "[" + params + "]");
                Map<String, Object> resultParams = new HashMap<>(2, 1);
                resultParams.put("type", type);
                resultParams.put("params", params == null ? null : JSON.toJSONString(params));
                channel.invokeMethod(LISTENER_FUNC_NAME, JSON.toJSONString(resultParams));
            }
        });
    }

    /**
     * 回调音频采集 PCM 数据
     */
    @Override
    public void onAudioSourceAvailable(ByteBuffer srcBuffer, int size, long tsInNanoTime, boolean isEof) {
        Log.i(TAG, "onAudioSourceAvailable: ");
        Map<String, Object> params = new HashMap<>(4, 1);
        params.put("srcBuffer", srcBuffer.array());
        params.put("size", size);
        params.put("tsInNanoTime", tsInNanoTime);
        params.put("isEof", isEof);
        invokeListener(PushCallBackNoticeEnum.AudioSourceAvailable, params);
    }

    @Override
    public void notifyStreamStatusChanged(StreamingProfile.StreamStatus streamStatus) {
        Log.i(TAG, "notifyStreamStatusChanged: ");
        invokeListener(PushCallBackNoticeEnum.StreamStatusChanged, streamStatus);
    }

    @Override
    public boolean onRecordAudioFailedHandled(int i) {
        Log.i(TAG, "onRecordAudioFailedHandled: ");
        invokeListener(PushCallBackNoticeEnum.RecordAudioFailedHandled, i);
        return false;
    }

    @Override
    public boolean onRestartStreamingHandled(int i) {
        Log.i(TAG, "onRestartStreamingHandled: ");
        invokeListener(PushCallBackNoticeEnum.RestartStreamingHandled, i);
        return false;
    }

    @Override
    public Camera.Size onPreviewSizeSelected(List<Camera.Size> list) {
        Log.i(TAG, "onPreviewSizeSelected: ");
        invokeListener(PushCallBackNoticeEnum.PreviewSizeSelected, list);
        return null;
    }

    @Override
    public int onPreviewFpsSelected(List<int[]> list) {
        Log.i(TAG, "onPreviewFpsSelected: ");
        invokeListener(PushCallBackNoticeEnum.PreviewFpsSelected, list);
        return 0;
    }

    @Override
    public void onStateChanged(StreamingState status, Object extra) {
        Log.i(TAG, "onStateChanged: ");
        Map<String, Object> params = new HashMap<>(2, 1);
        params.put("status", status);
        params.put("extra", extra);
        invokeListener(PushCallBackNoticeEnum.StateChanged, params);
    }
}
