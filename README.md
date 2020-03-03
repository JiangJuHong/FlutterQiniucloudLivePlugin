# flutter_qiniucloud_live_plugin

Flutter 七牛云直播云插件

## Getting Started

集成七牛云直播云推流、观看等功能

## 功能清单
### 推流端
[x]推流  
[x]推流时初始化自定义系统参数、预览参数等内容  
[x]美颜设置  
[x]自动对焦  
[ ]手动对焦  
[x]回调监听器  
[x]动态水印  
[ ]背景音乐  

### 播放端
[x]播放  
[x]监听器  

### 连麦SDK
[x]连麦  
[x]远端画面播放  

## 集成

### Flutter
目前暂不支持通过 flutter packages 仓库集成，仅能通过如下方式:
```
 flutter_qiniucloud_live_plugin:
    git:
      url: https://github.com/JiangJuHong/FlutterQiniucloudLivePlugin.git
      ref: master
```
### Android
不需要额外集成，已内部打入混淆

### IOS
配置权限信息，在Info.plist中增加
```
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>App需要您的同意,才能访问相册</string>
    <key>NSCameraUsageDescription</key>
    <string>App需要您的同意,才能访问相机</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>App需要您的同意,才能访问麦克风</string>
```

## 使用
使用Demo时请是主动更改推流地址和播放地址  
<img src="https://raw.githubusercontent.com/JiangJuHong/access-images/master/FlutterQiniucloudLivePlugin/start.png" height="300em" style="max-width:100%;">
<img src="https://raw.githubusercontent.com/JiangJuHong/access-images/master/FlutterQiniucloudLivePlugin/push.png" height="300em" style="max-width:100%;">
<img src="https://raw.githubusercontent.com/JiangJuHong/access-images/master/FlutterQiniucloudLivePlugin/push_2.png" height="300em" style="max-width:100%;">
<img src="https://raw.githubusercontent.com/JiangJuHong/access-images/master/FlutterQiniucloudLivePlugin/player.png" height="300em" style="max-width:100%;">

### 组件列表
QiniucloudPushView: 推流组件，通过该窗口Controller实现推流以及回显功能  
QiniucloudPlayerView: 播放器组件，通过Controller控制播放等内容  
QiniucloudConnectPlayerView：连麦推流预览组件

## 功能清单
### 连麦推流视图组件(QiniucloudPushView)
#### 例子
```dart
QiniucloudPushView(
  cameraStreamingSetting: CameraStreamingSettingEntity(
    faceBeauty: faceBeautySettingEntity,
  ),
  streamingProfile: StreamingProfileEntity(
    publishUrl: "rtmp://pili-publish.tianshitaiyuan.com/zuqulive/1576400046230A?e=1581756846&token=v740N_w0pHblR7KZMSPHhfdqjxrHEv5e_yBaiq0e:nlza8l7AsBDNkp47AD09ItfZSKA=",
  ),
  onViewCreated: (QiniucloudPushViewController controller) {
    controller.resume();
  },
)
```
#### 相关接口:(QiniucloudPushViewController调用方法)  
|  接口   | 说明  | 参数  | Android | IOS |
|  ----  | ----  | ----  | ----  | ----  |
| resume  | 打开摄像头和麦克风采集 | - | √ | 
| pause  | 关闭摄像头和麦克风采集 | - | √ | 
| stopConference  | 停止连麦 | - | √ | 
| startStreaming  | 开始推流 | - | √ | 
| stopStreaming  | 停止推流 | - | √ | 
| destroy  | 销毁 | - | √ | 
| isZoomSupported  | 查询是否支持缩放 | - | √ | 
| setZoomValue  | 设置缩放比例 | - | √ | 
| getMaxZoom  | 获得最大缩放比例 | - | √ | 
| getZoom  | 获得缩放比例 | - | √ | 
| turnLightOn  | 开启闪光灯 | - | √ | 
| turnLightOff  | 关闭闪光灯 | - | √ | 
| switchCamera  | 切换摄像头 | - | √ | 
| mute  | 切换静音 | - | √ | 
| kickoutUser  | 根据用户ID踢人 | - | √ | 
| setConferenceOptions  | 设置连麦参数 | - | √ | 
| setStreamingProfile  | 更新推流参数 | - | √ | 
| getParticipantsCount  | 获取参与连麦的人数，不包括自己 | - | √ | 
| getParticipants  | 获取参与连麦的用户ID列表，不包括自己 | - | √ | 
| setPreviewMirror  | 设置预览镜像 | - | √ | 
| setEncodingMirror  | 设置推流镜像 | - | √ | 
| startPlayback  | 开启耳返 | - | √ | 
| stopPlayback  | 关闭耳返 | - | √ | 
| updateWatermarkSetting  | 更新动态水印 | - | √ | 
| updateFaceBeautySetting  | 更新美颜设置 | - | √ | 
| addRemoteWindow  | 添加远程视图 | - | √ | 
| getVideoEncodingSize  | 获取编码器输出的画面的高宽 | - | √ | 
| setLocalWindowPosition  | 自定义视频窗口位置(连麦推流模式下有效) | - | √ | 

***

### 播放视图组件(QiniucloudPlayerView)
#### 例子
```dart
QiniucloudPlayerView(
  onViewCreated: (QiniucloudPlayerViewController controller){
    controller.setVideoPath(url:"rtmp://pili-live-rtmp.tianshitaiyuan.com/zuqulive/1576400046230A")
  },
),
```
#### 相关接口:(QiniucloudPlayerViewController调用方法)  
|  接口   | 说明  | 参数  | Android | IOS |
|  ----  | ----  | ----  | ----  | ----  |
| setVideoPath  | 设置视频路径 | - | √ | 
| setDisplayAspectRatio  | 设置画面预览模式 | - | √ | 
| start  | 开始播放 | - | √ | 
| pause  | 暂停播放 | - | √ | 
| stopPlayback  | 停止播放 | - | √ | 
| getRtmpVideoTimestamp  | 在RTMP消息中获取视频时间戳 | - | √ | 
| getRtmpAudioTimestamp  | 在RTMP消息中获取音频时间戳 | - | √ | 
| setBufferingEnabled  | 暂停/恢复播放器的预缓冲 | - | √ | 
| getHttpBufferSize  | 获取已经缓冲的长度 | - | √ | 

***

### 连麦推流预览组件(QiniucloudConnectPlayerView)
#### 例子
```dart
QiniucloudConnectPlayerView(
  onViewCreated: (viewId, playerController) {
    this.playerController = playerController;
    controller.addRemoteWindow(id: viewId);
  },
)
```
#### 相关接口:(QiniucloudPlayerViewController调用方法)  
|  接口   | 说明  | 参数  | Android | IOS |
|  ----  | ----  | ----  | ----  | ----  |
| setAbsoluteMixOverlayRect  | 配置连麦合流的参数（仅主播才配置，连麦观众不用）使用绝对值来配置该窗口在合流画面中的位置和大小 | - | √ | 
| setRelativeMixOverlayRect  | 配置连麦合流的参数（仅主播才配置，连麦观众不用）使用相对值来配置该窗口在合流画面中的位置和大小 | - | √ | 