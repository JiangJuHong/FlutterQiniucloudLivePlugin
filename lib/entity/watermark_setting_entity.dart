/// 水印设置实体
class WatermarkSettingEntity {
  // 水印大小
  WatermarkSizeEnum size;

  // 水印资源路径
  String resourcePath;

  //
  int alpha;

  // 水印位置
  WatermarkLocation location;

  WatermarkSettingEntity(
      {this.size, this.resourcePath, this.alpha, this.location});

  WatermarkSettingEntity.fromJson(Map<String, dynamic> json) {
    if (json['size'] != null) {
      for (var item in WatermarkSizeEnum.values) {
        if (item.toString().replaceAll("WatermarkSizeEnum.", "") ==
            json['size']) {
          size = item;
          break;
        }
      }
    }
    resourcePath = json['resourcePath'];
    alpha = json['alpha'];
    if (json['location'] != null) {
      for (var item in WatermarkLocation.values) {
        if (item.toString().replaceAll("WatermarkLocation.", "") ==
            json['location']) {
          location = item;
          break;
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size == null
        ? null
        : this.size.toString().replaceAll("WatermarkSizeEnum.", "");
    data['resourcePath'] = this.resourcePath;
    data['alpha'] = this.alpha;
    data['location'] = this.location == null
        ? null
        : this.location.toString().replaceAll("WatermarkLocation.", "");
    return data;
  }
}

/// 水印大小枚举
enum WatermarkSizeEnum {
  LARGE,
  MEDIUM,
  SMALL,
}

/// 水印位置枚举
enum WatermarkLocation {
  NORTH_WEST,
  NORTH_EAST,
  SOUTH_WEST,
  SOUTH_EAST,
}
