import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_player_view.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_player_view_controller.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_player_listener_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_player_display_aspect_ratio_enum.dart';

/// 播放界面
class PlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  /// 播放控制器
  QiniucloudPlayerViewController controller;

  /// 描述信息
  String hint;

  /// 状态
  int status;

  /// 错误信息
  String error;

  /// 视频宽度
  int width = 0;

  /// 视频高度
  int height = 0;

  /// 是否启用预缓存
  bool bufferingEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.removeListener(onListener);
    }
  }

  /// 控制器初始化
  onViewCreated(QiniucloudPlayerViewController controller) {
    this.controller = controller;
    controller.setDisplayAspectRatio(
        mode: QiniucloudPlayerDisplayAspectRatioEnum.ASPECT_RATIO_PAVED_PARENT);
    controller.addListener(onListener);
  }

  /// 监听器
  onListener(type, params) {
    // 错误
    if (type == QiniucloudPlayerListenerTypeEnum.Error) {
      this.setState(() => error = params.toString());
    }

    // 状态改变
    if (type == QiniucloudPlayerListenerTypeEnum.Info) {
      this.setState(() => status = params);
    }

    // 大小改变
    if (type == QiniucloudPlayerListenerTypeEnum.VideoSizeChanged) {
      Map<String, dynamic> paramsObj = jsonDecode(params);
      this.setState(() {
        width = paramsObj["width"];
        height = paramsObj["height"];
      });
    }
  }

  /// 获得状态文本
  getStatusText() {
    if (status == null) {
      return "等待中";
    }

    if (Platform.isIOS) {
      switch (status) {
        case 0:
          return "未知状态";
        case 1:
          return "准备中";
        case 2:
          return "准备完成";
        case 3:
          return "开始连接";
        case 4:
          return "正在缓存";
        case 5:
          return "正在播放";
        case 6:
          return "暂停";
        case 7:
          return "播放结束或手动停止";
        case 8:
          return "出现错误";
        case 9:
          return "播放器开始自动重连";
        case 10:
          return "点播播放完成";
        default:
          return "未知状态";
      }
    }

    switch (status) {
      case 1:
        return "未知消息";
      case 3:
        return "第一帧视频已成功渲染";
      case 200:
        return "连接成功";
      case 340:
        return "读取到 metadata 信息";
      case 701:
        return "开始缓冲";
      case 702:
        return "停止缓冲";
      case 802:
        return "硬解失败，自动切换软解";
      case 901:
        return "预加载完成";
      case 8088:
        return "loop 中的一次播放完成";
      case 10001:
        return "获取到视频的播放角度";
      case 10002:
        return "第一帧音频已成功播放";
      case 10003:
        return "获取视频的I帧间隔";
      case 20001:
        return "视频的码率统计结果";
      case 20002:
        return "视频的帧率统计结果";
      case 20003:
        return "音频的帧率统计结果";
      case 20003:
        return "音频的帧率统计结果";
      case 10004:
        return "视频帧的时间戳";
      case 10005:
        return "音频帧的时间戳";
      case 1345:
        return "离线缓存的部分播放完成";
      case 565:
        return "上一次 seekTo 操作尚未完成";
      default:
        return "未知状态";
    }
  }

  /// 获得状态文本
  getErrorText() {
    if (Platform.isIOS) {
      return error;
    }

    switch (error) {
      case "-1":
        return "未知错误";
      case "-2":
        return "播放器打开失败";
      case "-3":
        return "网络异常";
      case "-4":
        return "拖动失败";
      case "-5":
        return "预加载失败";
      case "-2003":
        return "硬解失败";
      case "-2008":
        return "播放器已被销毁，需要再次 setVideoURL 或 prepareAsync";
      case "-9527":
        return "so 库版本不匹配，需要升级";
      case "-4410":
        return "AudioTrack 初始化失败，可能无法播放音频";
      default:
        return error;
    }
  }

  /// 开始播放
  onStart() async {
    await controller.start(
      url:
          "rtmp://pili-live-rtmp.tianshitaiyuan.com/zuqulive/test",
    );
  }

  /// 暂停播放
  onPause() async {
    await controller.pause();
  }

  /// 停止播放
  onStopPlayback() async {
    await controller.stopPlayback();
  }

  /// 获得视频时间戳
  onGetRtmpVideoTimestamp() async {
    int time = await controller.getRtmpVideoTimestamp();
    this.setState(() => hint = "视频时间戳为:$time");
  }

  /// 获得音频时间戳
  onGetRtmpAudioTimestamp() async {
    int time = await controller.getRtmpAudioTimestamp();
    this.setState(() => hint = "音频时间戳为:$time");
  }

  /// 启用 / 关闭预缓存
  onSetBufferingEnabled() async {
    bufferingEnabled = !bufferingEnabled;
    await controller.setBufferingEnabled(enabled: bufferingEnabled);
    this.setState(() => hint = "已${bufferingEnabled ? "启用" : "关闭"}播放器预缓存");
  }

  /// 获取已经缓冲的长度
  onGetHttpBufferSize() async {
    int size = await controller.getHttpBufferSize();
    this.setState(() => hint = "已经缓冲的长度:$size");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                QiniucloudPlayerView(
                  onViewCreated: onViewCreated,
                ),
                Align(
                  alignment: new FractionalOffset(0.5, 0.95),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: Colors.red),
                    ),
                    child: Text(
                      "上滑查看功能栏",
                      style: TextStyle(color: Colors.red, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Text(
                        error != null ? "发生错误，错误信息为:${getErrorText()}" : "",
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(hint ?? ""),
                      Text("当前状态:${getStatusText()},视频高宽:$height,$width"),
                      Wrap(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: onStart,
                            child: Text("开始播放"),
                          ),
                          RaisedButton(
                            onPressed: onPause,
                            child: Text("暂停"),
                          ),
                          RaisedButton(
                            onPressed: onStopPlayback,
                            child: Text("停止"),
                          ),
                          RaisedButton(
                            onPressed: onGetRtmpVideoTimestamp,
                            child: Text("获得视频时间戳"),
                          ),
                          RaisedButton(
                            onPressed: onGetRtmpVideoTimestamp,
                            child: Text("获得音频时间戳"),
                          ),
                          RaisedButton(
                            onPressed: onSetBufferingEnabled,
                            child: Text("启用/关闭 播放器预缓存"),
                          ),
                          RaisedButton(
                            onPressed: onGetHttpBufferSize,
                            child: Text("获得已缓冲长度"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
