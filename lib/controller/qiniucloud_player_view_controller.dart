import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_player_display_aspect_ratio_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_player_listener_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_player_view.dart';

/// 视图控制器
class QiniucloudPlayerViewController {
  QiniucloudPlayerViewController(int id)
      : _channel = new MethodChannel('${QiniucloudPlayerViewState.type}_$id');

  final MethodChannel _channel;

  /// 监听器对象
  QiniucloudPlayerListener listener;

  /// 添加消息监听
  void addListener(QiniucloudPlayerListenerValue func) {
    if (listener == null) {
      listener = QiniucloudPlayerListener(_channel);
    }
    listener.addListener(func);
  }

  /// 移除消息监听
  void removeListener(QiniucloudPlayerListenerValue func) {
    if (listener == null) {
      listener = QiniucloudPlayerListener(_channel);
    }
    listener.removeListener(func);
  }

  /// 设置视频路径
  Future<void> setVideoPath({
    @required String url,
  }) async {
    return _channel.invokeMethod('setVideoPath', {"url": url});
  }

  /// 设置画面预览模式
  Future<void> setDisplayAspectRatio({
    @required QiniucloudPlayerDisplayAspectRatioEnum mode,
  }) async {
    return _channel.invokeMethod('setDisplayAspectRatio', {
      "mode": QiniucloudPlayerDisplayAspectRatioEnumTool.toInt(mode),
    });
  }

  /// 开始播放
  Future<void> start() async {
    return _channel.invokeMethod('start');
  }

  /// 暂停
  Future<void> pause() async {
    return _channel.invokeMethod('pause');
  }

  /// 停止
  Future<void> stopPlayback() async {
    return _channel.invokeMethod('stopPlayback');
  }

  /// 获得视频时间戳
  Future<int> getRtmpVideoTimestamp() async {
    return _channel.invokeMethod('getRtmpVideoTimestamp');
  }

  /// 获得音频时间戳
  Future<int> getRtmpAudioTimestamp() async {
    return _channel.invokeMethod('getRtmpAudioTimestamp');
  }

  /// 暂停/恢复播放器的预缓冲
  Future<void> setBufferingEnabled({
    @required bool enabled,
  }) async {
    return _channel.invokeMethod('setBufferingEnabled', {"enabled": enabled});
  }

  /// 获取已经缓冲的长度
  Future<String> getHttpBufferSize() async {
    return _channel.invokeMethod('getHttpBufferSize');
  }
}

/// 七牛云播放监听器
class QiniucloudPlayerListener {
  /// 监听器列表
  static Set<QiniucloudPlayerListenerValue> listeners = Set();

  QiniucloudPlayerListener(MethodChannel channel) {
    // 绑定监听器
    channel.setMethodCallHandler((methodCall) async {
      // 解析参数
      Map<String, dynamic> arguments = jsonDecode(methodCall.arguments);

      switch (methodCall.method) {
        case 'onPlayerListener':
          // 获得原始类型和参数
          String typeStr = arguments['type'];
          String paramsStr = arguments['params'];

          // 封装回调类型和参数
          QiniucloudPlayerListenerTypeEnum type;
          Object params;

          // 初始化类型
          for (var item in QiniucloudPlayerListenerTypeEnum.values) {
            if (item
                    .toString()
                    .replaceFirst("QiniucloudPlayerListenerTypeEnum.", "") ==
                typeStr) {
              type = item;
              break;
            }
          }

          // 没有找到类型就返回
          if (type == null) {
            throw MissingPluginException();
          }

          // 回调触发
          for (var item in listeners) {
            item(type, params ?? paramsStr);
          }

          break;
        default:
          throw MissingPluginException();
      }
    });
  }

  /// 添加消息监听
  void addListener(QiniucloudPlayerListenerValue func) {
    listeners.add(func);
  }

  /// 移除消息监听
  void removeListener(QiniucloudPlayerListenerValue func) {
    listeners.remove(func);
  }
}

/// 推流监听器值模型
typedef QiniucloudPlayerListenerValue<P> = void Function(
    QiniucloudPlayerListenerTypeEnum type, P params);
