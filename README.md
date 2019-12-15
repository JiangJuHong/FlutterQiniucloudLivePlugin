# flutter_qiniucloud_live_plugin

Flutter 七牛云直播云插件

## Getting Started

集成七牛云直播云推流、观看等功能

## 功能清单
[x]推流
[x]推流时初始化自定义系统参数、预览参数等内容
[x]美颜设置
[x]自动对焦
[ ]手动对焦
[ ]播放
[x]回调监听器，部分事件

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
暂不支持

## 使用

### 组件列表
QiniucloudPushView: 推流预览窗口，通过该窗口Controller实现推流以及回显功能