/// 七牛云推流自适应码率
enum QiniucloudPushBitrateAdjustModeEnum {
  Auto, // SDK 自适应码率调节
  Manual, // 用户自己实现码率调节, 范围：10kbps~10Mbps
  Disable // 关闭码率调节
}
