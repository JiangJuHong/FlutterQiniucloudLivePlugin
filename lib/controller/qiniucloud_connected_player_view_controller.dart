import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_connected_player_view.dart';

/// 连麦视图控制器
class QiniucloudConnectedPlayerViewController {
  QiniucloudConnectedPlayerViewController(int id)
      : _channel =
            new MethodChannel('${QiniucloudConnectPlayerViewState.type}_$id');

  final MethodChannel _channel;

  /// 配置合流参数(仅主播端设置，连麦观众不设置)
  Future<void> setAbsoluteMixOverlayRect({
    @required int x,
    @required int y,
    @required int width,
    @required int height,
  }) async {
    return _channel.invokeMethod('setAbsoluteMixOverlayRect', {
      "x": x,
      "y": y,
      "width": width,
      "height": height,
    });
  }
}
