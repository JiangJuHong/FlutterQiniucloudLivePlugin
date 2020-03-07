/// 七牛云推流音频质量
enum QiniucloudPushAudioQualityEnum {
  AUDIO_QUALITY_96,
  AUDIO_QUALITY_128,
}

/// 枚举工具类
class QiniucloudPushAudioQualityTool {
  // 将枚举转换为int类型
  static int toInt(QiniucloudPushAudioQualityEnum type) {
    switch (type) {
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_96:
        return 20;
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_128:
        return 21;
      default:
        return null;
    }
  }
}
