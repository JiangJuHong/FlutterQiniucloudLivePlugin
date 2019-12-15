import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_player_view.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_player_view_controller.dart';

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
    controller.addListener(onListener);

    // 设置视频路径
    controller.setVideoPath(
        url:
            "rtmp://pili-live-rtmp.tianshitaiyuan.com/zuqulive/1576400046230A");
  }

  /// 监听器
  onListener(type, params) {}

  /// 开始播放
  onStart() async {
    await controller.start();
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

  /// 获取已经缓冲的长度
  onGetHttpBufferSize() async {
    String size = await controller.getHttpBufferSize();
    this.setState(() => hint = "已经缓冲的长度:$size");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.height / 2,
            child: QiniucloudPlayerView(
              onViewCreated: onViewCreated,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: <Widget>[
                Text(hint ?? ""),
                Expanded(
                  child: ListView(
                    children: <Widget>[
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
