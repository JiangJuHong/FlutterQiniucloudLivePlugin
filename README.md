# flutter_qiniucloud_live_plugin

Flutter 七牛云直播云插件，支持IOS、Android客户端

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
### QiniucloudPlayerView 监听器  
0. Error 回调参数:`Android:int 错误码` or `IOS:String 错误描述`  
0. Info 状态码: `IOS` or `Android` 不一致  
    * Android
    
        |  状态码   | 描述 |
        |  ----  | ---- |
        | 1  | 未知消息
        | 3  | 第一帧视频已成功渲染
        | 200  | 连接成功
        | 340  | 读取到 metadata 信息
        | 701  | 开始缓冲
        | 702  | 停止缓冲
        | 802  | 硬解失败，自动切换软解
        | 901  | 预加载完成
        | 8088  | loop 中的一次播放完成
        | 10001	| 获取到视频的播放角度
        | 10002	| 第一帧音频已成功播放
        | 10003	| 获取视频的I帧间隔
        | 20001	| 视频的码率统计结果
        | 20002	| 视频的帧率统计结果
        | 20003	| 音频的帧率统计结果
        | 20004	| 音频的帧率统计结果
        | 10004	| 视频帧的时间戳
        | 10005	| 音频帧的时间戳
        | 1345	| 离线缓存的部分播放完成
        | 565	| 上一次 seekTo 操作尚未完成
        
    * IOS
    
        |  状态码   | 描述 |
        |  ----  | ---- |
        | 0  | 未知状态，只会作为 init 后的初始状态，开始播放之后任何情况下都不会再回到此状态。
        | 1  | 正在准备播放所需组件，在调用 -play 方法时出现。
        | 2  | 播放组件准备完成，准备开始播放，在调用 -play 方法时出现。
        | 3  | 播放组件准备完成，准备开始连接
        | 4  | 缓存数据为空状态。(特别需要注意的是当推流端停止推流之后，PLPlayer 将出现 caching 状态直到 timeout 后抛出 timeout 的 error 而不是出现 PLPlayerStatusStopped 状态，因此在直播场景中，当流停止之后一般做法是使用 IM 服务告知播放器停止播放，以达到即时响应主播断流的目的。)
        | 5  | 正在播放状态。
        | 6  | 暂停状态。
        | 7  | 停止状态 (该状态仅会在回放时播放结束出现，RTMP 直播结束并不会出现此状态)
        | 8  | 错误状态，播放出现错误时会出现此状态。
        | 9  | 自动重连的状态
        | 10 | 播放完成（该状态只针对点播有效）
        
0. VideoSizeChanged 回调：`仅支持Android`  

### QiniucloudPushView 监听器  
0. StateChanged 状态码: `IOS` or `Android` 不一致  
    
    |  状态码   | 描述 | Android | Ios
    |  ----  | ---- | ---- | ---- |
    | PREPARING  | - | √ | √
    | READY  | 相机准备就绪 | √ | √
    | CONNECTING  | 连接中 | √ | √
    | STREAMING  | 推流中 | √ | √
    | SHUTDOWN  | 直播中断 | √ | 
    | IOERROR  | 网络连接失败(连接rtmp推流失败) | √ | √
    | OPEN_CAMERA_FAIL  | 摄像头打开失败 | √ | 
    | AUDIO_RECORDING_FAIL  | 麦克风打开失败 | √ |
    | DISCONNECTED  | 已经断开连接(直播断开) | √ | √
    | TORCH_INFO  | 开启闪光灯 | √ |

0. StreamStatusChanged 状态  
    IOS 仅包含 `audioFps、videoFps、totalAVBitrate` 属性
    
0. ConferenceStateChanged IOS暂不支持(计划内)

0. UserJoinConference IOS暂不支持(计划内)

0. UserLeaveConference IOS暂不支持(计划内)

0. RecordAudioFailedHandled IOS暂不支持

0. RestartStreamingHandled IOS暂不支持

0. PreviewSizeSelected IOS暂不支持

0. PreviewFpsSelected IOS暂不支持

0. AudioSourceAvailable IOS暂不支持
        
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
| resume  | 打开摄像头和麦克风采集 | - | √ | √
| pause  | 关闭摄像头和麦克风采集 | - | √ | √
| startConference  | 开始连麦 | - | √ | 
| stopConference  | 停止连麦 | - | √ | √
| startStreaming  | 开始推流 | {publishUrl:'推流地址'} | √ | √
| stopStreaming  | 停止推流 | - | √ | √
| destroy  | 销毁 | - | √ | √
| isZoomSupported  | 查询是否支持缩放(IOS始终返回true) | - | √ | √
| setZoomValue  | 设置缩放比例 | {value:'比例值'} | √ | √
| getMaxZoom  | 获得最大缩放比例 | - | √ | √
| getZoom  | 获得缩放比例 | - | √ | √
| turnLightOn  | 开启闪光灯 | - | √ | √
| turnLightOff  | 关闭闪光灯 | - | √ | √
| switchCamera  | 切换摄像头 | - | √ | √
| mute  | 切换静音 | {mute:'是否静音',audioSource:'音频源'} | √ | √
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


## 其它插件
````
我同时维护的还有如下插件，如果您感兴趣与我一起进行维护，请通过Github联系我，欢迎 issues 和 PR。
````
| 平台 | 插件  |  描述  |  版本  |
| ---- | ----  | ---- |  ---- |
| Flutter | [FlutterTencentImPlugin](https://github.com/JiangJuHong/FlutterTencentImPlugin)  | 腾讯云IM插件 | [![pub package](https://img.shields.io/pub/v/tencent_im_plugin.svg)](https://pub.dartlang.org/packages/tencent_im_plugin) |
| Flutter | [FlutterTencentRtcPlugin](https://github.com/JiangJuHong/FlutterTencentRtcPlugin)  | 腾讯云Rtc插件 | [![pub package](https://img.shields.io/pub/v/tencent_rtc_plugin.svg)](https://pub.dartlang.org/packages/tencent_rtc_plugin) |
| Flutter | [FlutterXiaoMiPushPlugin](https://github.com/JiangJuHong/FlutterXiaoMiPushPlugin)  | 小米推送SDK插件 | [![pub package](https://img.shields.io/pub/v/xiao_mi_push_plugin.svg)](https://pub.dartlang.org/packages/xiao_mi_push_plugin) |
| Flutter | [FlutterTextSpanField](https://github.com/JiangJuHong/FlutterTextSpanField)  | 自定义文本样式输入框 | [![pub package](https://img.shields.io/pub/v/text_span_field.svg)](https://pub.dartlang.org/packages/text_span_field) |
| Flutter | [FlutterQiniucloudLivePlugin](https://github.com/JiangJuHong/FlutterQiniucloudLivePlugin)  | Flutter 七牛云直播云插件 | 暂未发布，通过 git 集成 |
