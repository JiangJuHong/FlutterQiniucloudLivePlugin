//
//  PushCallBackNoticeEnum.swift
//  flutter_qiniucloud_live_plugin
//
//  Created by 蒋具宏 on 2020/3/6.
//  推流回调枚举
public enum PushCallBackNoticeEnum{
    /// 回调音频采集 PCM 数据
    case AudioSourceAvailable

    /// 根据StreamingProfile.StreamStatusConfig.getIntervalMs（）调用
    case StreamStatusChanged

    /// 录音失败时调用。
    case RecordAudioFailedHandled

    /// 重新启动流式处理通知。
    case RestartStreamingHandled

    /// 在构造相机对象后调用。
    case PreviewSizeSelected

    /// 自定义预览fps，在构造相机对象后调用。
    case PreviewFpsSelected

    /// 状态发生改变
    case StateChanged

    /// 连麦状态改变
    case ConferenceStateChanged

    /// 用户加入连麦
    case UserJoinConference

    /// 用户离开连麦
    case UserLeaveConference
}
