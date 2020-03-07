import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_camera_type_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_push_preview_size_level_enum.dart';

import 'face_beauty_setting_entity.dart';

/// 摄像头设置相关参数
class CameraStreamingSettingEntity {
  // 启用美颜功能
  bool builtInFaceBeautyEnabled;

  // 美颜设置
  FaceBeautySettingEntity faceBeauty;

  // 摄像头
  QiniucloudCameraTypeEnum cameraFacingId;

  // 启用镜像翻转(预览)
  bool frontCameraPreviewMirror;

  // 启用镜像翻转(播放端)
  bool frontCameraMirror;

  // 启用自动对焦
  bool continuousFocusModeEnabled;

  // 预览大小级别
  QiniucloudPushPreviewSizeLevelEnum cameraPrvSizeLevel;

  CameraStreamingSettingEntity({
    this.builtInFaceBeautyEnabled: true,
    this.cameraFacingId: QiniucloudCameraTypeEnum.CAMERA_FACING_BACK,
    this.frontCameraPreviewMirror: false,
    this.faceBeauty,
    this.frontCameraMirror: false,
    this.continuousFocusModeEnabled: true,
    this.cameraPrvSizeLevel: QiniucloudPushPreviewSizeLevelEnum.MEDIUM,
  });

  CameraStreamingSettingEntity.fromJson(Map<String, dynamic> json) {
    builtInFaceBeautyEnabled = json['builtInFaceBeautyEnabled'];
    cameraFacingId = json['cameraFacingId'];
    frontCameraPreviewMirror = json['frontCameraPreviewMirror'];
    faceBeauty = json['faceBeautySetting'];
    frontCameraMirror = json['frontCameraMirror'];
    continuousFocusModeEnabled = json['continuousFocusModeEnabled'];
    cameraPrvSizeLevel = json['cameraPrvSizeLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['builtInFaceBeautyEnabled'] = this.builtInFaceBeautyEnabled;
    data['cameraFacingId'] = this.cameraFacingId != null
        ? this
            .cameraFacingId
            .toString()
            .replaceAll("QiniucloudCameraTypeEnum.", "")
        : null;
    data['frontCameraPreviewMirror'] = this.frontCameraPreviewMirror;
    data['faceBeauty'] =
        this.faceBeauty != null ? this.faceBeauty.toJson() : null;
    data['frontCameraMirror'] = this.frontCameraMirror;
    data['continuousFocusModeEnabled'] = this.continuousFocusModeEnabled;
    data['cameraPrvSizeLevel'] = this.cameraPrvSizeLevel != null
        ? this
        .cameraPrvSizeLevel
        .toString()
        .replaceAll("QiniucloudPushPreviewSizeLevelEnum.", "")
        : null;
    return data;
  }
}
