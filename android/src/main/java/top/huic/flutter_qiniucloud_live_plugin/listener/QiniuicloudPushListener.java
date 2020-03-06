package top.huic.flutter_qiniucloud_live_plugin.listener;

import android.content.Context;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;

import com.alibaba.fastjson.JSON;
import com.qiniu.pili.droid.rtcstreaming.RTCConferenceState;
import com.qiniu.pili.droid.rtcstreaming.RTCConferenceStateChangedListener;
import com.qiniu.pili.droid.rtcstreaming.RTCUserEventListener;
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

import io.flutter.plugin.common.MethodChannel;
import top.huic.flutter_qiniucloud_live_plugin.enums.PushCallBackNoticeEnum;

/**
 * 七牛云连麦推流监听器
 *
 * @author 蒋具宏
 */
public class QiniuicloudPushListener implements RTCConferenceStateChangedListener, StreamingSessionListener, StreamingStateChangedListener, RTCUserEventListener, StreamStatusCallback, AudioSourceCallback {

    /**
     * 日志标签
     */
    private static final String TAG = QiniuicloudPushListener.class.getName();

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
        // 切换到主线程
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                Map<String, Object> resultParams = new HashMap<>(2, 1);
                resultParams.put("type", type);
                resultParams.put("params", params == null ? null : JSON.toJSONString(params));
                channel.invokeMethod(LISTENER_FUNC_NAME, JSON.toJSONString(resultParams));
            }
        });
    }

    @Override
    public void onConferenceStateChanged(RTCConferenceState rtcConferenceState, int i) {
        Map<String, Object> params = new HashMap<>(2, 1);
        params.put("status", rtcConferenceState);
        params.put("extra", i);
        invokeListener(PushCallBackNoticeEnum.ConferenceStateChanged, params);
    }

    @Override
    public void onUserJoinConference(String s) {
        invokeListener(PushCallBackNoticeEnum.UserJoinConference, s);
    }

    @Override
    public void onUserLeaveConference(String s) {
        invokeListener(PushCallBackNoticeEnum.UserLeaveConference, s);
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
        invokeListener(PushCallBackNoticeEnum.StateChanged, status);
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
}
