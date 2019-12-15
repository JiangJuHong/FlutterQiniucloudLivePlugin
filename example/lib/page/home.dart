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

  /// 推流界面
  onPush() {
    // 摄像头和麦克风权限请求
    PermissionHandler().requestPermissions(
        [PermissionGroup.camera, PermissionGroup.microphone]).then((res) {
      if (res[PermissionGroup.camera] != PermissionStatus.disabled &&
          res[PermissionGroup.microphone] != PermissionStatus.disabled) {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new PushPage()),
        );
      }
    });
  }

  /// 播放界面
  onPlayer() {
    // 摄像头和麦克风权限请求
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new PlayerPage()),
    );
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
              onPressed: onPush,
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
