import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/conference_options_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/face_beauty_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/entity/watermark_setting_entity.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_audio_source_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_camera_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_listener_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_push_view.dart';

/// 连麦视图控制器
class QiniucloudPushViewController {
  QiniucloudPushViewController(int id)
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
  Future<bool> resume() async {
    return await _channel.invokeMethod('resume');
  }

  /// 关闭摄像头和麦克风采集s
  Future<void> pause() async {
    return await _channel.invokeMethod('pause');
  }

  /// 释放不紧要资源。
  Future<void> destroy() async {
    return await _channel.invokeMethod('destroy');
  }

  /// 开始推流
  Future<bool> startStreaming({
    publishUrl, // 推流地址，为null时使用全局配置上的推流地址
  }) async {
    return await _channel.invokeMethod('startStreaming', {
      "publishUrl": publishUrl,
    });
  }

  /// 停止推流
  Future<bool> stopStreaming() async {
    return await _channel.invokeMethod('stopStreaming');
  }

  /// 开始连麦
  Future<void> startConference({
    @required userId, // 用户ID
    @required roomName, //房间名
    @required roomToken, //房间token
  }) async {
    return await _channel.invokeMethod('startConference', {
      "userId": userId,
      "roomName": roomName,
      "roomToken": roomToken,
    });
  }

  /// 停止连麦
  Future<bool> stopConference() async {
    return await _channel.invokeMethod('stopConference');
  }

  /// 是否支持缩放
  Future<bool> isZoomSupported() async {
    return await _channel.invokeMethod('isZoomSupported');
  }

  /// 设置缩放比例
  Future<void> setZoomValue({
    @required int value,
  }) async {
    return await _channel.invokeMethod('setZoomValue', {"value": value});
  }

  /// 获得最大缩放比例
  Future<int> getMaxZoom() async {
    return await _channel.invokeMethod('getMaxZoom');
  }

  /// 获得当前缩放比例
  Future<int> getZoom() async {
    return await _channel.invokeMethod('getZoom');
  }

  /// 开启闪光灯
  Future<bool> turnLightOn() async {
    return await _channel.invokeMethod('turnLightOn');
  }

  /// 关闭闪光灯
  Future<bool> turnLightOff() async {
    return await _channel.invokeMethod('turnLightOff');
  }

  /// 切换摄像头
  Future<bool> switchCamera({
    @required QiniucloudCameraTypeEnum target, // 目标摄像头，不填代表反向切换,
  }) async {
    return await _channel.invokeMethod('switchCamera', {
      "target": target == null
          ? null
          : target.toString().replaceAll("QiniucloudCameraTypeEnum.", ""),
    });
  }

  /// 静音
  Future<void> mute({
    @required bool mute,
    @required QiniucloudAudioSourceTypeEnum audioSource,
  }) async {
    return await _channel.invokeMethod('mute', {
      "mute": mute,
      "audioSource": audioSource == null
          ? null
          : audioSource
              .toString()
              .replaceAll("QiniucloudAudioSourceTypeEnum.", ""),
    });
  }

  /// 更新水印信息
  Future<void> updateWatermarkSetting(WatermarkSettingEntity data) async {
    return await _channel.invokeMethod('updateWatermarkSetting', data.toJson());
  }

  /// 更新美颜信息
  Future<void> updateFaceBeautySetting(FaceBeautySettingEntity data) async {
    return await _channel.invokeMethod(
        'updateFaceBeautySetting', data.toJson());
  }

  /// 改变预览镜像
  Future<bool> setPreviewMirror({
    @required bool mirror,
  }) async {
    return await _channel.invokeMethod('setPreviewMirror', {
      "mirror": mirror,
    });
  }

  /// 改变推流镜像
  Future<bool> setEncodingMirror({
    @required bool mirror,
  }) async {
    return await _channel.invokeMethod('setEncodingMirror', {
      "mirror": mirror,
    });
  }

  /// 开启耳返
  Future<bool> startPlayback() async {
    return await _channel.invokeMethod('startPlayback');
  }

  /// 关闭耳返
  Future<void> stopPlayback() async {
    return await _channel.invokeMethod('stopPlayback');
  }

  /// 根据用户ID踢出连麦
  Future<void> kickoutUser({
    @required String userId,
  }) async {
    return await _channel.invokeMethod('kickoutUser', {
      "userId": userId,
    });
  }

  /// 设置连麦参数
  Future<bool> setConferenceOptions({
    @required ConferenceOptionsEntity conferenceOptions,
  }) async {
    return await _channel.invokeMethod('setConferenceOptions', {
      "conferenceOptions": conferenceOptions,
    });
  }

  /// 获得参与连麦的人数(不包括自己)
  Future<int> getParticipantsCount() async {
    return await _channel.invokeMethod('getParticipantsCount');
  }

  /// 获取参与连麦的用户ID列表，不包括自己
  Future<List> getParticipants() async {
    return jsonDecode(await _channel.invokeMethod('getParticipants'));
  }

  /// 添加远程视图
  Future<void> addRemoteWindow({
    id, // 视图ID
  }) async {
    return await _channel.invokeMethod('addRemoteWindow', {"id": id});
  }

  /// 获取编码器输出的画面的高宽
  Future<Map> getVideoEncodingSize() async {
    return jsonDecode(await _channel.invokeMethod('getVideoEncodingSize'));
  }

  /// 自定义视频窗口位置(连麦推流模式下有效)
  Future<void> setLocalWindowPosition({
    @required int x,
    @required int y,
    @required int w,
    @required int h,
  }) async {
    return await _channel.invokeMethod('setLocalWindowPosition', {
      "x": x,
      "y": y,
      "w": w,
      "h": h,
    });
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
    QiniucloudPushListenerTypeEnum type, P params);
