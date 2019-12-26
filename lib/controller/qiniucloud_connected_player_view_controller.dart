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
  /// 使用绝对值来配置该窗口在合流画面中的位置和大小
  Future<void> setAbsoluteMixOverlayRect({
    @required int x,
    @required int y,
    @required int w,
    @required int h,
  }) async {
    return await _channel.invokeMethod('setAbsoluteMixOverlayRect', {
      "x": w,
      "y": h,
      "w": w,
      "h": h,
    });
  }

  /// 配置合流参数(仅主播端设置，连麦观众不设置)
  /// 使用相对值来配置该窗口在合流画面中的位置和大小
  Future<void> setRelativeMixOverlayRect({
    @required int x,
    @required int y,
    @required int w,
    @required int h,
  }) async {
    return await _channel.invokeMethod('setRelativeMixOverlayRect', {
      "x": w,
      "y": h,
      "w": w,
      "h": h,
    });
  }
}
