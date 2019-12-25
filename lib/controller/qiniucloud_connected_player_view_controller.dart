import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_connected_player_view.dart';

/// 连麦视图控制器
class QiniucloudConnectedPlayerViewController {
  QiniucloudConnectedPlayerViewController(int id)
      : _channel =
            new MethodChannel('${QiniucloudConnectPlayerViewState.type}_$id');

  final MethodChannel _channel;
}
