import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniucloud_live_plugin_example/page/player.dart';
import 'package:flutter_qiniucloud_live_plugin_example/page/push.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /// 播放界面
  onPlayer() {
    // TODO 摄像头和麦克风权限请求
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new PlayerPage()),
    );
  }

  /// 连麦推流界面
  onConnectedPush() {
    // 摄像头和麦克风权限请求
    PermissionHandler().requestPermissions(
        [PermissionGroup.camera, PermissionGroup.microphone]).then((res) {
      if (res[PermissionGroup.camera] == PermissionStatus.granted &&
          res[PermissionGroup.microphone] == PermissionStatus.granted) {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => PushPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: onConnectedPush,
              child: Text("开始推流"),
            ),
            RaisedButton(
              onPressed: onPlayer,
              child: Text("开始播放"),
            ),
          ],
        ),
      ),
    );
  }
}
