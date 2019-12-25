import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_connected_push_view.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_connected_push_view_controller.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_connected_player_view.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_connected_push_listener_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/face_beauty_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/camera_streaming_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/streaming_profile_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_camera_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_audio_source_type_enum.dart';

/// 连麦界面
class ConnectedPushPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PushPageState();
}

class PushPageState extends State<ConnectedPushPage> {
  /// 推流控制器
  QiniucloudConnectedPushViewController controller;

  /// 当前状态
  String status;

  /// 描述信息
  String info;

  /// 连麦状态
  String connectedStatus;

  /// 美颜对象
  FaceBeautySettingEntity faceBeautySettingEntity =
      FaceBeautySettingEntity(beautyLevel: 0, redden: 0, whiten: 0);

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
  onViewCreated(QiniucloudConnectedPushViewController controller) {
    this.controller = controller;
    controller.addListener(onListener);
  }

  /// 监听器
  onListener(type, params) {
    // 状态改变监听
    if (type == QiniucloudConnectedPushListenerTypeEnum.StateChanged) {
      Map<String, dynamic> paramObj = jsonDecode(params);
      stateChanged(paramObj["status"], paramObj["extra"]);
    }

    // 连麦状态改变监听
    if (type ==
        QiniucloudConnectedPushListenerTypeEnum.ConferenceStateChanged) {
      Map<String, dynamic> paramObj = jsonDecode(params);
      print("连麦状态改变:${paramObj["status"]},${paramObj["extra"]}");
      connectedStateChanged(paramObj["status"], paramObj["extra"]);
    }
  }

  /// 状态改变事件
  stateChanged(status, extra) async {
    this.setState(() => this.status = status);
  }

  /// 设置连麦状态
  connectedStateChanged(status, extra) async {
    this.setState(() => this.connectedStatus = status);
  }

  /// 获得状态文本描述
  getStatusText(status) {
    if (status == null) {
      return "等待预览";
    }

    switch (status) {
      case "PREPARING":
        return "PREPARING";
      case "READY":
        return "准备就绪";
      case "CONNECTING":
        return "连接中";
      case "STREAMING":
        return "推流中";
      case "SHUTDOWN":
        return "直播中断";
      case "IOERROR":
        return "网络连接失败";
      case "OPEN_CAMERA_FAIL":
        return "摄像头打开失败";
      case "AUDIO_RECORDING_FAIL":
        return "麦克风打开失败";
      case "DISCONNECTED":
        return "已经断开连接";
      case "TORCH_INFO":
        return "可开启闪光灯";
      default:
        return "未绑定事件:$status";
    }
  }

  /// 开始预览事件
  onResume() async {
    bool result = await controller.startCapture();
    this.setState(() => info = "预览执行结果: $result");
  }

  /// 开始推流事件
  onPush() async {
    bool result = await controller.startStreaming();
    this.setState(() => info = "推流执行结果: $result");
  }

  /// 停止推流事件
  onStopPush() async {
    bool result = await controller.stopStreaming();
    this.setState(() => info = "停止推流执行结果: $result");
  }

  /// 检测是否支持缩放
  onCheckZoomSupported() async {
    bool result = await controller.isZoomSupported();
    if (result) {
      int current = await controller.getZoom();
      int max = await controller.getMaxZoom();
      this.setState(() => info = "缩放检测结果: 支持，当前缩放比例:$current，最大缩放比例:$max");
    } else {
      this.setState(() => info = "缩放检测结果: 不支持");
    }
  }

  /// 设置最大缩放比例
  onSetMaxZoom() async {
    int max = await controller.getMaxZoom();
    await controller.setZoomValue(value: max);
    this.setState(() => info = "缩放比例设置成功:$max");
  }

  /// 重置缩放比例
  onResetZoom() async {
    await controller.setZoomValue(value: 0);
    this.setState(() => info = "缩放比例设置成功:0");
  }

  /// 开启闪光灯
  onTurnLightOn() async {
    bool result = await controller.turnLightOn();
    this.setState(() => info = "开启闪光灯结果: $result");
  }

  /// 关闭闪光灯
  onTurnLightOff() async {
    bool result = await controller.turnLightOff();
    this.setState(() => info = "关闭闪光灯结果: $result");
  }

  /// 切换摄像头
  onSwitchCamera() async {
    bool result = await controller.switchCamera();
    this.setState(() => info = "切换摄像头: $result");
  }

  /// 切换后置摄像头
  onSwitchBackCamera() async {
    bool result = await controller.switchCamera(
        target: QiniucloudCameraTypeEnum.CAMERA_FACING_BACK);
    this.setState(() => info = "切换后置摄像头: $result");
  }

  /// 切换前置摄像头
  onSwitchFrontCamera() async {
    bool result = await controller.switchCamera(
        target: QiniucloudCameraTypeEnum.CAMERA_FACING_FRONT);
    this.setState(() => info = "切换前置摄像头: $result");
  }

  /// 切换3DR摄像头
  onSwitch3DRCamera() async {
    bool result = await controller.switchCamera(
        target: QiniucloudCameraTypeEnum.CAMERA_FACING_3RD);
    this.setState(() => info = "切换3DR摄像头: $result");
  }

  /// 静音
  onMute(mute) async {
    await controller.mute(
      mute: mute,
      audioSource: QiniucloudAudioSourceTypeEnum.MIC,
    );
    this.setState(() => info = "已成功执行静音/恢复静音步骤");
  }

  /// 暂停
  onPause() async {
    await controller.stopCapture();
    this.setState(() {
      info = "已成功执行暂停";
      status = null;
    });
  }

  /// 销毁
  onDestroy() async {
    await controller.destroy();
    this.setState(() => info = "已成功执行销毁");
  }

  /// 更新美颜信息
  onUpdateFaceBeautySetting() async {
    await controller.updateFaceBeautySetting(faceBeautySettingEntity);
    this.setState(() => info =
        "更新美颜信息成功:${faceBeautySettingEntity.beautyLevel},${faceBeautySettingEntity.redden},${faceBeautySettingEntity.whiten}");
  }

  /// 设置预览镜像
  onSetPreviewMirror(mirror) async {
    bool res = await controller.setPreviewMirror(mirror: mirror);
    this.setState(
        () => info = "预览镜像${mirror ? "打开" : "关闭"}${res ? "成功" : "失败"}");
  }

  /// 设置推流镜像
  onSetEncodingMirror(mirror) async {
    bool res = await controller.setEncodingMirror(mirror: mirror);
    this.setState(
        () => info = "推流镜像${mirror ? "打开" : "关闭"}${res ? "成功" : "失败"}");
  }

  /// 开启耳返
  onStartPlayback() async {
    bool res = await controller.startPlayback();
    this.setState(() => info = "开启耳返${res ? "成功" : "失败"}");
  }

  /// 关闭耳返
  onStopPlayback() async {
    await controller.stopPlayback();
    this.setState(() => info = "关闭执行成功");
  }

  /// 开始连麦
  onStartConference() async {
    try {
      await controller.startConference(
        roomName: "15764969071808",
        userId: "2ef92e08177c46b19cc97999fae296b8",
        roomToken:
            "v740N_w0pHblR7KZMSPHhfdqjxrHEv5e_yBaiq0e:MHo7mCd7Y_6w9E1348lkfkmm9Ps=:eyJyb29tX25hbWUiOiIxNTc2NDk2OTA3MTgwOCIsImV4cGlyZV9hdCI6MTU3NzU3MjEzOCwicGVybSI6ImFkbWluIiwidmVyc2lvbiI6IjIuMCIsInVzZXJfaWQiOiIyZWY5MmUwODE3N2M0NmIxOWNjOTc5OTlmYWUyOTZiOCJ9",
      );
      this.setState(() => info = "连麦执行成功");
    } catch (e) {
      this.setState(() => info = "连麦执行失败:$e");
    }
  }

  /// 开始连麦
  onStopConference() async {
    await controller.stopConference();
    this.setState(() => info = "关闭连麦执行成功");
  }

  /// 连麦视图创建事件
  onPlayerViewCreated(viewId, playerController) {
    controller.addRemoteWindow(id: viewId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: <Widget>[
                QiniucloudConnectPushView(
                  cameraStreamingSetting: CameraStreamingSettingEntity(
                      faceBeauty: faceBeautySettingEntity),
                  streamingProfile: StreamingProfileEntity(
                    publishUrl:
                        "rtmp://pili-publish.tianshitaiyuan.com/zuqulive/1576400046230A?e=1581756846&token=v740N_w0pHblR7KZMSPHhfdqjxrHEv5e_yBaiq0e:nlza8l7AsBDNkp47AD09ItfZSKA=",
                  ),
                  onViewCreated: onViewCreated,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.red,
                    child: QiniucloudConnectPlayerView(
                      onViewCreated: onPlayerViewCreated,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: <Widget>[
                Text("当前状态:${getStatusText(this.status)}"),
                Text("连麦状态:${this.connectedStatus ?? ""}"),
                Text(info ?? ""),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(width: 10),
                              Text("磨皮"),
                              Expanded(
                                child: new Slider(
                                  value: faceBeautySettingEntity.beautyLevel,
                                  max: 1,
                                  min: 0,
                                  activeColor: Colors.blue,
                                  onChanged: (double val) {
                                    this.setState(() {
                                      this.faceBeautySettingEntity.beautyLevel =
                                          val;
                                    });
                                    onUpdateFaceBeautySetting();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10),
                              Text("红润"),
                              Expanded(
                                child: new Slider(
                                  value: faceBeautySettingEntity.redden,
                                  max: 1,
                                  min: 0,
                                  activeColor: Colors.blue,
                                  onChanged: (double val) {
                                    this.setState(() {
                                      this.faceBeautySettingEntity.redden = val;
                                    });
                                    onUpdateFaceBeautySetting();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(width: 10),
                              Text("美白"),
                              Expanded(
                                child: new Slider(
                                  value: faceBeautySettingEntity.whiten,
                                  max: 1,
                                  min: 0,
                                  activeColor: Colors.blue,
                                  onChanged: (double val) {
                                    this.setState(() {
                                      this.faceBeautySettingEntity.whiten = val;
                                    });
                                    onUpdateFaceBeautySetting();
                                  },
                                ),
                              ),
                            ],
                          ),
                          RaisedButton(
                            onPressed: this.status == null ? onResume : null,
                            child: Text("开始预览"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null ? onPause : null,
                            child: Text("暂停预览"),
                          ),
                          RaisedButton(
                            onPressed: this.status == null ? onDestroy : null,
                            child: Text("销毁资源"),
                          ),
                          RaisedButton(
                            onPressed: this.status == "READY" ? onPush : null,
                            child: Text("开始推流"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status == "STREAMING" ? onStopPush : null,
                            child: Text("停止推流"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? onCheckZoomSupported
                                : null,
                            child: Text("是否支持缩放"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onSetMaxZoom : null,
                            child: Text("设置为最大缩放比例"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null ? onResetZoom : null,
                            child: Text("重置缩放比例"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onTurnLightOn : null,
                            child: Text("开启闪光灯"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onTurnLightOff : null,
                            child: Text("关闭闪光灯"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onSwitchCamera : null,
                            child: Text("切换摄像头"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? onSwitchFrontCamera
                                : null,
                            child: Text("切换前置摄像头"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onSwitchBackCamera : null,
                            child: Text("切换后置摄像头"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onSwitch3DRCamera : null,
                            child: Text("切换3DR摄像头"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? () => onMute(true) : null,
                            child: Text("开启静音"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? () => onMute(false)
                                : null,
                            child: Text("恢复声音"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? () => onSetPreviewMirror(true)
                                : null,
                            child: Text("打开预览镜像"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? () => onSetPreviewMirror(false)
                                : null,
                            child: Text("关闭预览镜像"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? () => onSetEncodingMirror(true)
                                : null,
                            child: Text("打开推流镜像"),
                          ),
                          RaisedButton(
                            onPressed: this.status != null
                                ? () => onSetEncodingMirror(false)
                                : null,
                            child: Text("关闭推流镜像"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onStartPlayback : null,
                            child: Text("开启耳返"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onStopPlayback : null,
                            child: Text("关闭耳返"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onStartConference : null,
                            child: Text("开始连麦"),
                          ),
                          RaisedButton(
                            onPressed:
                                this.status != null ? onStopConference : null,
                            child: Text("关闭连麦"),
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
