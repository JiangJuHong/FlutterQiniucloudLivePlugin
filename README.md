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
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
	<key>NSCameraUsageDescription</key>
	<string>App需要您的同意,才能访问相机</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>App需要您的同意,才能访问麦克风</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>App需要您的同意,才能访问相册</string>
	<key>UIBackgroundModes</key>
	<array>
		<string>audio</string>
	</array>
```

## 注意事项
由于Android、IOS底层兼容不一致，导致以下内容会受影响：
* QiniucloudPlayerView 监听器
    0. Error 回调参数:`Android:int 错误码` or `IOS:String 错误描述`
    0. Info 状态码: `IOS` or `Android` 不一致
        0. Android:Int 状态码，参考:`https://developer.qiniu.com/pili/sdk/1210/the-android-client-sdk`
        0. IOS:Int 状态码，对应下标:
            ```
               /**
                PLPlayer 未知状态，只会作为 init 后的初始状态，开始播放之后任何情况下都不会再回到此状态。
                @since v1.0.0
                */
               PLPlayerStatusUnknow = 0,
               
               /**
                PLPlayer 正在准备播放所需组件，在调用 -play 方法时出现。
                
                @since v1.0.0
                */
               PLPlayerStatusPreparing,
               
               /**
                PLPlayer 播放组件准备完成，准备开始播放，在调用 -play 方法时出现。
                
                @since v1.0.0
                */
               PLPlayerStatusReady,
               
               /**
                PLPlayer 播放组件准备完成，准备开始连接
                
                @warning 请勿在此状态时，调用 playWithURL 切换 URL 操作
                
                @since v3.2.1
                */
               PLPlayerStatusOpen,
               
               /**
                @abstract PLPlayer 缓存数据为空状态。
                
                @discussion 特别需要注意的是当推流端停止推流之后，PLPlayer 将出现 caching 状态直到 timeout 后抛出 timeout 的 error 而不是出现 PLPlayerStatusStopped 状态，因此在直播场景中，当流停止之后一般做法是使用 IM 服务告知播放器停止播放，以达到即时响应主播断流的目的。
                
                @since v1.0.0
                */
               PLPlayerStatusCaching,
               
               /**
                PLPlayer 正在播放状态。
                
                @since v1.0.0
                */
               PLPlayerStatusPlaying,
               
               /**
                PLPlayer 暂停状态。
                
                @since v1.0.0
                */
               PLPlayerStatusPaused,
               
               /**
                @abstract PLPlayer 停止状态
                @discussion 该状态仅会在回放时播放结束出现，RTMP 直播结束并不会出现此状态
                
                @since v1.0.0
                */
               PLPlayerStatusStopped,
               
               /**
                PLPlayer 错误状态，播放出现错误时会出现此状态。
                
                @since v1.0.0
                */
               PLPlayerStatusError,
               
               /**
                *  PLPlayer 自动重连的状态
                */
               PLPlayerStateAutoReconnecting,
               
               /**
                *  PLPlayer 播放完成（该状态只针对点播有效）
                */
               PLPlayerStatusCompleted,
           ```
    0. VideoSizeChanged 回调：`仅支持Android`
* QiniucloudPlayerDisplayAspectRatioEnum
    0. IOS不支持 `ASPECT_RATIO_FIT_PARENT` 属性

## 使用
使用Demo时请主动更改推流地址和播放地址  
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
  url: "rtmp://pili-live-rtmp.tianshitaiyuan.com/zuqulive/test",
  onViewCreated: (QiniucloudPlayerViewController controller){
    controller.setVideoPath(url:"rtmp://pili-live-rtmp.tianshitaiyuan.com/zuqulive/1576400046230A")
  },
),
```
#### 相关接口:(QiniucloudPlayerViewController调用方法)  
|  接口   | 说明  | 参数  | Android | IOS |
|  ----  | ----  | ----  | ----  | ----  |
| setDisplayAspectRatio  | 设置画面预览模式 | {mode:'模式，枚举'} | √ | √
| start  | 开始播放 | {url:"播放的URL，通过该参数可以做到切换视频",sameSource:"是否是同种格式播放，同格式切换打开更快 @waring 当sameSource 为 YES 时，视频格式与切换前视频格式不同时，会导致视频打开失败【该属性仅IOS有效】"} | √ | √
| pause  | 暂停播放 | - | √ | √
| stopPlayback  | 停止播放 | - | √ | √
| getRtmpVideoTimestamp  | 在RTMP消息中获取视频时间戳 | - | √ | √
| getRtmpAudioTimestamp  | 在RTMP消息中获取音频时间戳 | - | √ | √
| setBufferingEnabled  | 启用/关闭 播放器的预缓冲 | {enabled:'是否启用'} | √ | 
| getHttpBufferSize  | 获取已经缓冲的长度 | - | √ | √

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