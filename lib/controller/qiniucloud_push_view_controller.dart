import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_listener_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_push_view.dart';

/// 视图控制器
class QiniucloudPushViewController {
  QiniucloudPushViewController(int id)
      : _channel = new MethodChannel('${QiniucloudPushViewState.type}_$id');

  final MethodChannel _channel;

  /// 监听器对象
  QiniucloudPushListener listener;

  /// 添加消息监听
  void addListener(QinniucloudPushListenerValue func) {
    if (listener == null) {
      listener = QiniucloudPushListener(_channel);
    }
    listener.addListener(func);
  }

  /// 移除消息监听
  void removeListener(QinniucloudPushListenerValue func) {
    if (listener == null) {
      listener = QiniucloudPushListener(_channel);
    }
    listener.removeListener(func);
  }

  /// 开始推流
  Future<bool> startStreaming() async {
    return _channel.invokeMethod('startStreaming');
  }
}

/// 七牛云推流监听器
class QiniucloudPushListener {
  /// 监听器列表
  static Set<QinniucloudPushListenerValue> listeners = Set();

  QiniucloudPushListener(MethodChannel channel) {
    // 绑定监听器
    channel.setMethodCallHandler((methodCall) async {
      // 解析参数
      Map<String, dynamic> arguments = jsonDecode(methodCall.arguments);

      switch (methodCall.method) {
        case 'onPushListener':
          // 获得原始类型和参数
          String typeStr = arguments['type'];
          String paramsStr = arguments['params'];

          // 封装回调类型和参数
          QiniucloudPushListenerTypeEnum type;
          Object params;

          // 初始化类型
          for (var item in QiniucloudPushListenerTypeEnum.values) {
            if (item
                    .toString()
                    .replaceFirst("QiniucloudPushListenerTypeEnum.", "") ==
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
  void addListener(QinniucloudPushListenerValue func) {
    listeners.add(func);
  }

  /// 移除消息监听
  void removeListener(QinniucloudPushListenerValue func) {
    listeners.remove(func);
  }
}

/// 推流监听器值模型
typedef QinniucloudPushListenerValue<P> = void Function(
    QiniucloudPushListenerTypeEnum type, P params);
