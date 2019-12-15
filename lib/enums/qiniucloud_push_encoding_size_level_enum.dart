/// 七牛云推流Encoding size 的设定
enum QiniucloudPushEncodingSizeLevelEnum {
  VIDEO_ENCODING_HEIGHT_240,
  VIDEO_ENCODING_HEIGHT_480,
  VIDEO_ENCODING_HEIGHT_544,
  VIDEO_ENCODING_HEIGHT_720,
  VIDEO_ENCODING_HEIGHT_1088,
}

/// 枚举工具类
class QiniucloudPushEncodingSizeLevelEnumTool {
  // 将枚举转换为int类型
  static int toInt(QiniucloudPushEncodingSizeLevelEnum type) {
    switch (type) {
      case QiniucloudPushEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_240:
        return 0;
      case QiniucloudPushEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_480:
        return 1;
      case QiniucloudPushEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_544:
        return 2;
      case QiniucloudPushEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_720:
        return 3;
      case QiniucloudPushEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_1088:
        return 4;
      default:
        return null;
    }
  }
}
