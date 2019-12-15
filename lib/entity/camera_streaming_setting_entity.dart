import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_camera_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_focus_mode.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_preview_size_level_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_preview_size_ratio_enum.dart';

import 'face_beauty_setting_entity.dart';

/// 摄像头设置相关参数
class CameraStreamingSettingEntity {
  // 启用美颜功能
  bool builtInFaceBeautyEnabled;

  // 美颜设置
  FaceBeautySettingEntity faceBeauty;

  // 摄像头
  QiniucloudPushCameraTypeEnum cameraFacingId;

  // 启用镜像翻转(预览)
  bool frontCameraPreviewMirror;

  // 启用镜像翻转(播放端)
  bool frontCameraMirror;

  // 启用自动对焦
  bool continuousFocusModeEnabled;

  // 对焦模式
  QiniucloudPushFocusModeEnum focusMode;

  // 预览大小比例
  QiniucloudPushPreviewSizeRatioEnum cameraPrvSizeRatio;

  // 预览大小级别
  QiniucloudPushPreviewSizeLevelEnum cameraPrvSizeLevel;

  // 可以通过 CameraStreamingSetting 对象设置 Recording hint，以此来提升数据源的帧率。需要注意的是，在部分机型开启 Recording Hint 之后，会出现画面卡帧等风险，所以请慎用该 API。如果需要实现高 fps 推流，可以考虑开启并加入白名单机制。
  bool recordingHint;

  CameraStreamingSettingEntity({
    this.builtInFaceBeautyEnabled: true,
    this.cameraFacingId: QiniucloudPushCameraTypeEnum.CAMERA_FACING_BACK,
    this.frontCameraPreviewMirror: false,
    this.faceBeauty,
    this.frontCameraMirror: true,
    this.continuousFocusModeEnabled: true,
    this.focusMode: QiniucloudPushFocusModeEnum.FOCUS_MODE_CONTINUOUS_VIDEO,
    this.cameraPrvSizeRatio: QiniucloudPushPreviewSizeRatioEnum.RATIO_16_9,
    this.cameraPrvSizeLevel: QiniucloudPushPreviewSizeLevelEnum.MEDIUM,
    this.recordingHint,
  });

  CameraStreamingSettingEntity.fromJson(Map<String, dynamic> json) {
    builtInFaceBeautyEnabled = json['builtInFaceBeautyEnabled'];
    cameraFacingId = json['cameraFacingId'];
    frontCameraPreviewMirror = json['frontCameraPreviewMirror'];
    faceBeauty = json['faceBeautySetting'];
    frontCameraMirror = json['frontCameraMirror'];
    continuousFocusModeEnabled = json['continuousFocusModeEnabled'];
    focusMode = json['focusMode'];
    cameraPrvSizeRatio = json['cameraPrvSizeRatio'];
    cameraPrvSizeLevel = json['cameraPrvSizeLevel'];
    recordingHint = json['recordingHint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['builtInFaceBeautyEnabled'] = this.builtInFaceBeautyEnabled;
    data['cameraFacingId'] = this.cameraFacingId != null
        ? this
            .cameraFacingId
            .toString()
            .replaceAll("QiniucloudPushCameraTypeEnum.", "")
        : null;
    data['frontCameraPreviewMirror'] = this.frontCameraPreviewMirror;
    data['faceBeauty'] =
        this.faceBeauty != null ? this.faceBeauty.toJson() : null;
    data['frontCameraMirror'] = this.frontCameraMirror;
    data['continuousFocusModeEnabled'] = this.continuousFocusModeEnabled;
    data['focusMode'] = this.focusMode != null
        ? this
        .focusMode
        .toString()
        .replaceAll("QiniucloudPushFocusModeEnum.", "")
        : null;
    data['cameraPrvSizeRatio'] = this.cameraPrvSizeRatio != null
        ? this
            .cameraPrvSizeRatio
            .toString()
            .replaceAll("QiniucloudPushPreviewSizeRatioEnum.", "")
        : null;
    data['cameraPrvSizeLevel'] = this.cameraPrvSizeLevel != null
        ? this
        .cameraPrvSizeLevel
        .toString()
        .replaceAll("QiniucloudPushPreviewSizeLevelEnum.", "")
        : null;
    data['recordingHint'] = this.recordingHint;
    return data;
  }
}
