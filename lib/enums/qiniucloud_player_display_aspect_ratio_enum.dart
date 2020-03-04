/// 七牛云播放 画面预览模式
enum QiniucloudPlayerDisplayAspectRatioEnum {
  ASPECT_RATIO_ORIGIN,
  // 适应屏幕(IOS不支持该属性)
  ASPECT_RATIO_FIT_PARENT,
  ASPECT_RATIO_PAVED_PARENT,
  ASPECT_RATIO_16_9,
  ASPECT_RATIO_4_3,
}

/// 枚举工具类
class QiniucloudPlayerDisplayAspectRatioEnumTool {
  // 将枚举转换为int类型
  static int toInt(QiniucloudPlayerDisplayAspectRatioEnum type) {
    switch (type) {
      case QiniucloudPlayerDisplayAspectRatioEnum.ASPECT_RATIO_ORIGIN:
        return 0;
      case QiniucloudPlayerDisplayAspectRatioEnum.ASPECT_RATIO_FIT_PARENT:
        return 1;
      case QiniucloudPlayerDisplayAspectRatioEnum.ASPECT_RATIO_PAVED_PARENT:
        return 2;
      case QiniucloudPlayerDisplayAspectRatioEnum.ASPECT_RATIO_16_9:
        return 3;
      case QiniucloudPlayerDisplayAspectRatioEnum.ASPECT_RATIO_4_3:
        return 4;
      default:
        return null;
    }
  }
}
