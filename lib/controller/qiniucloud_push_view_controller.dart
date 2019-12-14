import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_push_view.dart';

/// 视图控制器
class QiniucloudPushViewController {
  QiniucloudPushViewController(int id)
      : _channel = new MethodChannel('${QiniucloudPushViewState.type}_$id');

  final MethodChannel _channel;

  /// 初始化推流
  Future<void> init({
    @required String url, // 推流URL，格式为: rtmp://xxxx
  }) async {
    return _channel.invokeMethod('init', {
      "url": url,
    });
  }
}
