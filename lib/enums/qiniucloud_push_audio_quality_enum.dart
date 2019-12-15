/// 七牛云推流音频质量
enum QiniucloudPushAudioQualityEnum {
  AUDIO_QUALITY_LOW1,
  AUDIO_QUALITY_LOW2,
  AUDIO_QUALITY_MEDIUM1,
  AUDIO_QUALITY_MEDIUM2,
  AUDIO_QUALITY_HIGH1,
  AUDIO_QUALITY_HIGH2,
}

/// 枚举工具类
class QiniucloudPushAudioQualityEnumTool {
  // 将枚举转换为int类型
  static int toInt(QiniucloudPushAudioQualityEnum type) {
    switch (type) {
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_LOW1:
        return 0;
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_LOW2:
        return 1;
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_MEDIUM1:
        return 10;
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_MEDIUM2:
        return 11;
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_HIGH1:
        return 20;
      case QiniucloudPushAudioQualityEnum.AUDIO_QUALITY_HIGH2:
        return 21;
      default:
        return null;
    }
  }
}
