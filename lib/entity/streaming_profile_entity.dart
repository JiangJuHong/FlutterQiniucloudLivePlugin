import 'package:flutter/cupertino.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_audio_quality_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_bitrate_adjust_mode.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_encoder_rc_mode.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_encoding_size_level_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_video_quality_enum.dart';

/// 系统参数
class StreamingProfileEntity {
  /// 推流URL，格式为: rtmp://xxxx
  String publishUrl;

  /// 视频质量
  QiniucloudPushVideoQualityEnum videoQuality;

  /// 音频质量
  QiniucloudPushAudioQualityEnum audioQuality;

  /// 软编的 EncoderRCModes
  QiniucloudPushEncoderRCModeEnum encoderRCMode;

  /// Encoding size 的设定
  QiniucloudPushEncodingSizeLevelEnum encodingSizeLevel;

  /// 自适应码率
  QiniucloudPushBitrateAdjustModeEnum bitrateAdjustMode;

  /// 是否启用 QUIC 推流
  bool quicEnable;

  StreamingProfileEntity({
    @required this.publishUrl,
    this.videoQuality: QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_HIGH3,
    this.audioQuality: QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_MEDIUM2,
    this.encoderRCMode: QiniucloudPushEncoderRCModeEnum.QUALITY_PRIORITY,
    this.encodingSizeLevel:
        QiniucloudPushEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_480,
    this.bitrateAdjustMode: QiniucloudPushBitrateAdjustModeEnum.Auto,
    this.quicEnable: true,
  });

  StreamingProfileEntity.fromJson(Map<String, dynamic> json) {
    publishUrl = json["publishUrl"];
    videoQuality = json["videoQuality"];
    audioQuality = json["audioQuality"];
    encoderRCMode = json["encoderRCMode"];
    encodingSizeLevel = json["encodingSizeLevel"];
    bitrateAdjustMode = json["bitrateAdjustMode"];
    quicEnable = json["quicEnable"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["publishUrl"] = this.publishUrl;
    data["videoQuality"] = this.videoQuality == null
        ? null
        : QiniucloudPushVideoQualityEnumTool.toInt(this.videoQuality);
    data["audioQuality"] = this.audioQuality == null
        ? null
        : QiniucloudPushAudioQualityEnumTool.toInt(this.audioQuality);
    data["encoderRCMode"] = this.encoderRCMode == null
        ? null
        : encoderRCMode
            .toString()
            .replaceAll("QiniucloudPushEncoderRCModeEnum.", "");
    data["encodingSizeLevel"] = this.encodingSizeLevel == null
        ? null
        : QiniucloudPushEncodingSizeLevelEnumTool.toInt(this.encodingSizeLevel);
    data["bitrateAdjustMode"] = this.bitrateAdjustMode == null
        ? null
        : bitrateAdjustMode
            .toString()
            .replaceAll("QiniucloudPushBitrateAdjustModeEnum.", "");
    data["quicEnable"] = this.quicEnable;
    return data;
  }
}
