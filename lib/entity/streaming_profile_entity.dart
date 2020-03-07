import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_audio_quality_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_video_quality_enum.dart';

/// 系统参数
class StreamingProfileEntity {
  /// 推流URL，格式为: rtmp://xxxx，如果在初始化时不设置，则需要在推流时进行设置
  String publishUrl;

  /// 视频质量
  QiniucloudPushVideoQualityEnum videoQuality;

  /// 音频质量
  QiniucloudPushAudioQualityEnum audioQuality;

  /// 是否启用 QUIC 推流
  bool quicEnable;

  StreamingProfileEntity({
    this.publishUrl,
    this.videoQuality: QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_HIGH3,
    this.quicEnable: true,
  });

  StreamingProfileEntity.fromJson(Map<String, dynamic> json) {
    publishUrl = json["publishUrl"];
    videoQuality = json["videoQuality"];
    audioQuality = json["audioQuality"];
    quicEnable = json["quicEnable"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.publishUrl != null){
      data["publishUrl"] = this.publishUrl;
    }
    data["videoQuality"] = this.videoQuality == null
        ? null
        : QiniucloudPushVideoQualityEnumTool.toInt(this.videoQuality);
    data["audioQuality"] = this.audioQuality == null
        ? null
        : QiniucloudPushAudioQualityTool.toInt(this.audioQuality);
    data["quicEnable"] = this.quicEnable;
    return data;
  }
}
