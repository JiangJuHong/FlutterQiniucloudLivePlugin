//
//  PlayerCallBackNoticeEnum.swift
//  flutter_qiniucloud_live_plugin
//
//  Created by 蒋具宏 on 2020/3/3.
//  播放回调枚举
public enum PlayerCallBackNoticeEnum{
    /**
     * 播放结束
     */
    case Completion
    /**
     * 错误事件
     */
    case Error
    /**
     * 状态消息
     */
    case Info
    /**
     * 已经准备好
     */
    case Prepared
    /**
     * 该回调用于监听当前播放的视频流的尺寸信息，在 SDK 解析出视频的尺寸信息后，会触发该回调，开发者可以在该回调中调整 UI 的视图尺寸。
     */
    case VideoSizeChanged
}
