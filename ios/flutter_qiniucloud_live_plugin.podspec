#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_qiniucloud_live_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_qiniucloud_live_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Flutter 七牛云直播云插件'
  s.description      = <<-DESC
Flutter 七牛云直播云插件
                       DESC
  s.homepage         = 'https://github.com/JiangJuHong/FlutterQiniucloudLivePlugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JiangJuHong' => '690717394@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'

  # 资源导入
  s.vendored_frameworks = '**/*.framework'

  # 七牛云直播云播放端依赖(https://developer.qiniu.com/pili/sdk/1211/ios-playback-end-the-sdk)
  s.dependency 'PLPlayerKit', '3.4.3'
  # 七牛云直播云连麦端依赖(https://developer.qiniu.com/pili/sdk/4311/PLRTCStreamingKit)
  s.dependency 'PLMediaStreamingKit', '3.0.7'

end
