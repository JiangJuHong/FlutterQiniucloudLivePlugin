import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_encoding_orientation_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_encoding_size_level_enum.dart';
import 'package:flutter_qiniucloud_live_plugin/enums/qiniucloud_preview_size_ratio_enum.dart';

/// 连麦参数实体
class ConferenceOptionsEntity {
  QiniucloudPreviewSizeRatioEnum videoEncodingSizeRatio;
  QiniucloudEncodingSizeLevelEnum videoEncodingSizeLevel;
  QiniucloudEncodingOrientationEnum videoEncodingOrientation;

  ConferenceOptionsEntity({
    this.videoEncodingSizeRatio,
    this.videoEncodingSizeLevel,
    this.videoEncodingOrientation,
  });

  ConferenceOptionsEntity.fromJson(Map<String, dynamic> json) {
    videoEncodingSizeRatio = json['videoEncodingSizeRatio'];
    videoEncodingSizeLevel = json['videoEncodingSizeLevel'];
    videoEncodingOrientation = json['videoEncodingOrientation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beautyLevel'] = this.videoEncodingSizeRatio == null
        ? null
        : this
            .videoEncodingSizeRatio
            .toString()
            .replaceAll("QiniucloudPreviewSizeRatioEnum.", "");
    data['videoEncodingSizeLevel'] =
        QiniucloudEncodingSizeLevelEnumTool.toInt(this.videoEncodingSizeLevel);
    data['videoEncodingOrientation'] = this.videoEncodingOrientation == null
        ? null
        : this
            .videoEncodingOrientation
            .toString()
            .replaceAll("QiniucloudEncodingOrientationEnum.", "");
    return data;
  }
}
