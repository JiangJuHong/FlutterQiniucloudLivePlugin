import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/face_beauty_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/watermark_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_audio_source_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_camera_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_connected_push_listener_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_push_view.dart';

/// 连麦视图控制器
class QiniucloudConnectedPushViewController {
  QiniucloudConnectedPushViewController(int id)
      : _channel = new MethodChannel('${QiniucloudPushViewState.type}_$id');

  final MethodChannel _channel;

  /// 监听器对象
  QiniucloudConnectedPushListener listener;

  /// 添加消息监听
  void addListener(QiniucloudPushListenerValue func) {
    if (listener == null) {
      listener = QiniucloudConnectedPushListener(_channel);
    }
    listener.addListener(func);
  }

  /// 移除消息监听
  void removeListener(QiniucloudPushListenerValue func) {
    if (listener == null) {
      listener = QiniucloudConnectedPushListener(_channel);
    }
    listener.removeListener(func);
  }

  /// 打开摄像头和麦克风采集
  Future<bool> startCapture() async {
    return _channel.invokeMethod('startCapture');
  }

  /// 关闭摄像头和麦克风采集s
  Future<void> stopCapture() async {
    return _channel.invokeMethod('stopCapture');
  }

  /// 释放不紧要资源。
  Future<void> destroy() async {
    return _channel.invokeMethod('destroy');
  }

  /// 开始推流
  Future<bool> startStreaming({
    publishUrl, // 推流地址，为null时使用全局配置上的推流地址
  }) async {
    return _channel.invokeMethod('startStreaming', {
      "publishUrl": publishUrl,
    });
  }

  /// 停止推流
  Future<bool> stopStreaming() async {
    return _channel.invokeMethod('stopStreaming');
  }

  /// 开始连麦
  Future<bool> startConference({
    userId, // 用户ID
    roomName, //房间名
    roomToken, //房间token
  }) async {
    return _channel.invokeMethod('startConference', {
      "userId": userId,
      "roomName": roomName,
      "roomToken": roomToken,
    });
  }

  /// 停止连麦
  Future<bool> stopConference() async {
    return _channel.invokeMethod('stopConference');
  }

  /// 是否支持缩放
  Future<bool> isZoomSupported() async {
    return _channel.invokeMethod('isZoomSupported');
  }

  /// 设置缩放比例
  Future<void> setZoomValue({
    @required int value,
  }) async {
    return _channel.invokeMethod('setZoomValue', {"value": value});
  }

  /// 获得最大缩放比例
  Future<int> getMaxZoom() async {
    return _channel.invokeMethod('getMaxZoom');
  }

  /// 获得当前缩放比例
  Future<int> getZoom() async {
    return _channel.invokeMethod('getZoom');
  }

  /// 开启闪光灯
  Future<bool> turnLightOn() async {
    return _channel.invokeMethod('turnLightOn');
  }

  /// 关闭闪光灯
  Future<bool> turnLightOff() async {
    return _channel.invokeMethod('turnLightOff');
  }

  /// 切换摄像头
  Future<bool> switchCamera({
    QiniucloudCameraTypeEnum target, // 目标摄像头，不填代表反向切换,
  }) async {
    return _channel.invokeMethod('switchCamera', {
      "target": target == null
          ? null
          : target.toString().replaceAll("QiniucloudCameraTypeEnum.", ""),
    });
  }

  /// 静音
  Future<bool> mute({
    @required bool mute,
    @required QiniucloudAudioSourceTypeEnum audioSource,
  }) async {
    return _channel.invokeMethod('mute', {
      "mute": mute,
      "audioSource": audioSource == null
          ? null
          : audioSource
              .toString()
              .replaceAll("QiniucloudAudioSourceTypeEnum.", ""),
    });
  }

  /// 关闭/启用日志
  Future<bool> setNativeLoggingEnabled({
    @required bool enabled,
  }) async {
    return _channel.invokeMethod('setNativeLoggingEnabled', {
      "enabled": enabled,
    });
  }

  /// 更新水印信息
  Future<void> updateWatermarkSetting(WatermarkSettingEntity data) async {
    return _channel.invokeMethod('updateWatermarkSetting', data.toJson());
  }

  /// 更新美颜信息
  Future<void> updateFaceBeautySetting(FaceBeautySettingEntity data) async {
    return _channel.invokeMethod('updateFaceBeautySetting', data.toJson());
  }

  /// 改变预览镜像
  Future<bool> setPreviewMirror({
    @required bool mirror,
  }) async {
    return _channel.invokeMethod('setPreviewMirror', {
      "mirror": mirror,
    });
  }

  /// 改变推流镜像
  Future<bool> setEncodingMirror({
    @required bool mirror,
  }) async {
    return _channel.invokeMethod('setEncodingMirror', {
      "mirror": mirror,
    });
  }

  /// 开启耳返
  Future<bool> startPlayback() async {
    return _channel.invokeMethod('setEncodingMirror');
  }

  /// 关闭耳返
  Future<bool> stopPlayback() async {
    return _channel.invokeMethod('stopPlayback');
  }
}

/// 七牛云连麦监听器
class QiniucloudConnectedPushListener {
  /// 监听器列表
  static Set<QiniucloudPushListenerValue> listeners = Set();

  QiniucloudConnectedPushListener(MethodChannel channel) {
    // 绑定监听器
    channel.setMethodCallHandler((methodCall) async {
      // 解析参数
      Map<String, dynamic> arguments = jsonDecode(methodCall.arguments);

      switch (methodCall.method) {
        case 'onConnectedPushListener':
          // 获得原始类型和参数
          String typeStr = arguments['type'];
          String paramsStr = arguments['params'];

          // 封装回调类型和参数
          QiniucloudConnectedPushListenerTypeEnum type;
          Object params;

          // 初始化类型
          for (var item in QiniucloudConnectedPushListenerTypeEnum.values) {
            if (item.toString().replaceFirst(
                    "QiniucloudConnectedPushListenerTypeEnum.", "") ==
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
  void addListener(QiniucloudPushListenerValue func) {
    listeners.add(func);
  }

  /// 移除消息监听
  void removeListener(QiniucloudPushListenerValue func) {
    listeners.remove(func);
  }
}

/// 推流监听器值模型
typedef QiniucloudPushListenerValue<P> = void Function(
    QiniucloudConnectedPushListenerTypeEnum type, P params);
