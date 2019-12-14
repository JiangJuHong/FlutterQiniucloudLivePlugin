import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_push_view.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_push_view_controller.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_listener_type_enum.dart';

/// 推流界面
class PushPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PushPageState();
}

class PushPageState extends State<PushPage> {
  QiniucloudPushViewController controller;

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
  onViewCreated(QiniucloudPushViewController controller) {
    this.controller = controller;
    controller.addListener(onListener);
  }

  /// 监听器
  onListener(type, params) {
    // 状态改变监听
    if (type == QiniucloudPushListenerTypeEnum.StateChanged) {
      Map<String, dynamic> paramObj = jsonDecode(params);
      stateChanged(paramObj["status"], paramObj["extra"]);
    }
  }

  /// 状态改变事件
  stateChanged(status, extra) async {
    switch (status) {
      case "PREPARING":
        print("StateChanged:PREPARING");
        break;
      case "READY":
        print("StateChanged:准备就绪");
        print("StateChanged:开始推流，结果:${await controller.startStreaming()}");
        break;
      case "CONNECTING":
        print("StateChanged:连接中");
        break;
      case "STREAMING":
        print("StateChanged:推流中");
        break;
      case "SHUTDOWN":
        print("StateChanged:直播中断");
        break;
      case "IOERROR":
        print("StateChanged:网络连接失败：$extra");
        break;
      case "OPEN_CAMERA_FAIL":
        print("StateChanged:摄像头打开失败");
        break;
      case "DISCONNECTED":
        print("StateChanged:已经断开连接");
        break;
      case "TORCH_INFO":
        print("StateChanged:可开启闪光灯");
        break;
      default:
        print("StateChanged:未绑定事件x");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QiniucloudPushView(
            url:
                "rtmp://pili-publish.tianshitaiyuan.com/zuqulive/1576329687316A?e=1576333287&token=v740N_w0pHblR7KZMSPHhfdqjxrHEv5e_yBaiq0e:2bpAwTnvJsH-S0AFveG6FVAguEc=",
            onViewCreated: onViewCreated,
          )
        ],
      ),
    );
  }
}
