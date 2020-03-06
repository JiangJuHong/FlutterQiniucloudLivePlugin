/// 美颜设置实体
class FaceBeautySettingEntity {
  // 美颜等级
  double beautyLevel;
  // 红润
  double redden;
  // 美白
  double whiten;

  FaceBeautySettingEntity({this.beautyLevel : 0, this.redden : 0, this.whiten : 0});

  FaceBeautySettingEntity.fromJson(Map<String, dynamic> json) {
    beautyLevel = json['beautyLevel'];
    redden = json['redden'];
    whiten = json['whiten'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beautyLevel'] = this.beautyLevel;
    data['redden'] = this.redden;
    data['whiten'] = this.whiten;
    return data;
  }
}
