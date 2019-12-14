import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_push_view_controller.dart';

/// 七牛云推流预览窗口
class QiniucloudPushView extends StatefulWidget {
  /// 创建事件
  final ValueChanged<QiniucloudPushViewController> onViewCreated;

  const QiniucloudPushView({Key key, this.onViewCreated}) : super(key: key);

  @override
  State<StatefulWidget> createState() => QiniucloudPushViewState();
}

class QiniucloudPushViewState extends State<QiniucloudPushView> {
  /// 唯一标识符，需要与PlatformView标识对应
  static const String type = "plugins.huic.top/QiniucloudPush";

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
      widget.onViewCreated(QiniucloudPushViewController(id));
    }
  }
}