import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniucloud_live_plugin/view/qiniucloud_push_view.dart';
import 'package:flutter_qiniucloud_live_plugin/controller/qiniucloud_push_view_controller.dart';

/// 推流界面
class PushPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PushPageState();
}

class PushPageState extends State<PushPage> {
  @override
  void initState() {
    super.initState();
  }

  /// 控制器初始化
  onViewCreated(QiniucloudPushViewController controller) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QiniucloudPushView(
            url:
                "rtmp://pili-publish.qnsdk.com/sdk-live/12312asda123assadas?e=1576307857&token=QxZugR8TAhI38AiJ_cptTl3RbzLyca3t-AAiH-Hh:6CZ2_T_MLhiLkp4VNj9vqsJRZ68=",
            onViewCreated: onViewCreated,
          )
        ],
      ),
    );
  }
}
