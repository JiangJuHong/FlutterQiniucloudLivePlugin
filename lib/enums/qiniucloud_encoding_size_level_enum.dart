/// 七牛云推流Encoding size 的设定
enum QiniucloudEncodingSizeLevelEnum {
  VIDEO_ENCODING_HEIGHT_240,
  VIDEO_ENCODING_HEIGHT_480,
  VIDEO_ENCODING_HEIGHT_544,
  VIDEO_ENCODING_HEIGHT_720,
  VIDEO_ENCODING_HEIGHT_1088,
}

/// 枚举工具类
class QiniucloudEncodingSizeLevelEnumTool {
  // 将枚举转换为int类型
  static int toInt(QiniucloudEncodingSizeLevelEnum type) {
    switch (type) {
      case QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_240:
        return 0;
      case QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_480:
        return 1;
      case QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_544:
        return 2;
      case QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_720:
        return 3;
      case QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_1088:
        return 4;
      default:
        return null;
    }
  }
}
