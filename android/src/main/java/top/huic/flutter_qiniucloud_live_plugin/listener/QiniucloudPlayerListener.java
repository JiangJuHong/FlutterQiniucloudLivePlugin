package top.huic.flutter_qiniucloud_live_plugin.listener;


import android.content.Context;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.pili.pldroid.player.PLOnCompletionListener;
import com.pili.pldroid.player.PLOnErrorListener;
import com.pili.pldroid.player.PLOnInfoListener;
import com.pili.pldroid.player.PLOnPreparedListener;
import com.pili.pldroid.player.PLOnVideoSizeChangedListener;
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
import top.huic.flutter_qiniucloud_live_plugin.enums.PlayerCallBackNoticeEnum;
import top.huic.flutter_qiniucloud_live_plugin.enums.PushCallBackNoticeEnum;

/**
 * 七牛云播放监听器
 *
 * @author 蒋具宏
 */
public class QiniucloudPlayerListener implements PLOnPreparedListener, PLOnInfoListener, PLOnCompletionListener, PLOnVideoSizeChangedListener, PLOnErrorListener {
    /**
     * 日志标签
     */
    private static final String TAG = QiniucloudPlayerListener.class.getName();

    /**
     * 监听器回调的方法名
     */
    private final static String LISTENER_FUNC_NAME = "onPlayerListener";

    /**
     * 全局上下文
     */
    private Context context;

    /**
     * 通信管道
     */
    private MethodChannel channel;

    public QiniucloudPlayerListener(Context context, MethodChannel channel) {
        this.context = context;
        this.channel = channel;
    }

    /**
     * 调用监听器
     *
     * @param type   类型
     * @param params 参数
     */
    private void invokeListener(final PlayerCallBackNoticeEnum type, final Object params) {
        Map<String, Object> resultParams = new HashMap<>(2, 1);
        resultParams.put("type", type);
        resultParams.put("params", params == null ? null : JSON.toJSONString(params));
        channel.invokeMethod(LISTENER_FUNC_NAME, JSON.toJSONString(resultParams));
    }

    /**
     * 播放结束
     */
    @Override
    public void onCompletion() {
        invokeListener(PlayerCallBackNoticeEnum.Completion, null);
    }

    /**
     * 错误事件
     */
    @Override
    public boolean onError(int i) {
        invokeListener(PlayerCallBackNoticeEnum.Error, i);
        return false;
    }

    /**
     * 状态信息
     */
    @Override
    public void onInfo(int i, int i1) {
        Map<String, Object> params = new HashMap<>(2, 1);
        params.put("what", i);
        params.put("extra", i1);
        invokeListener(PlayerCallBackNoticeEnum.Info, params);
    }

    /**
     * 准备好
     */
    @Override
    public void onPrepared(int i) {
        invokeListener(PlayerCallBackNoticeEnum.Prepared, i);
    }

    /**
     * 播放的视频流的尺寸信息，在 SDK 解析出视频的尺寸信息后，会触发该回调，开发者可以在该回调中调整 UI 的视图尺寸
     */
    @Override
    public void onVideoSizeChanged(int i, int i1) {
        Map<String, Object> params = new HashMap<>(2, 1);
        params.put("width", i);
        params.put("height", i1);
        invokeListener(PlayerCallBackNoticeEnum.VideoSizeChanged, params);
    }
}
