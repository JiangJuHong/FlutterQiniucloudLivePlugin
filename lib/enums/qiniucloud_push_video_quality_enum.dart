/// 七牛云推流视频质量
enum QiniucloudPushVideoQualityEnum {
  VIDEO_QUALITY_LOW1,
  VIDEO_QUALITY_LOW2,
  VIDEO_QUALITY_LOW3,
  VIDEO_QUALITY_MEDIUM1,
  VIDEO_QUALITY_MEDIUM2,
  VIDEO_QUALITY_MEDIUM3,
  VIDEO_QUALITY_HIGH1,
  VIDEO_QUALITY_HIGH2,
  VIDEO_QUALITY_HIGH3,
}

/// 枚举工具类
class QiniucloudPushVideoQualityEnumTool {
  // 将枚举转换为int类型
  static int toInt(QiniucloudPushVideoQualityEnum type) {
    switch (type) {
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_LOW1:
        return 0;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_LOW2:
        return 1;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_LOW3:
        return 2;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_MEDIUM1:
        return 10;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_MEDIUM2:
        return 11;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_MEDIUM3:
        return 12;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_HIGH1:
        return 20;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_HIGH2:
        return 21;
      case QiniucloudPushVideoQualityEnum.VIDEO_QUALITY_HIGH3:
        return 22;
      default:
        return null;
    }
  }
}
