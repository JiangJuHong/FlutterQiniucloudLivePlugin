import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_connected_player_view_controller.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_connected_push_view_controller.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_push_view_controller.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/camera_streaming_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/streaming_profile_entity.dart';

/// 七牛云连麦推流预览窗口
class QiniucloudConnectPlayerView extends StatefulWidget {
  /// 创建事件
  final ViewCreated<QiniucloudConnectedPlayerViewController> onViewCreated;

  const QiniucloudConnectPlayerView({
    Key key,
    this.onViewCreated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QiniucloudConnectPlayerViewState();
}

class QiniucloudConnectPlayerViewState
    extends State<QiniucloudConnectPlayerView> {
  /// 唯一标识符，需要与PlatformView标识对应
  static const String type = "plugins.huic.top/QiniucloudConnectedPlayer";

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: type,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: type,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return Text("不支持的平台");
    }
  }

  /// 创建事件
  void _onPlatformViewCreated(int id) {
    if (widget.onViewCreated != null) {
      widget.onViewCreated(id, QiniucloudConnectedPlayerViewController(id));
    }
  }
}

typedef ViewCreated<T> = void Function(int viewId, T value);
