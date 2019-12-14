package top.huic.flutter_qiniucloud_live_plugin;

import android.content.Context;
import android.util.Log;

import com.qiniu.pili.droid.streaming.StreamingEnv;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewRegistry;
import top.huic.flutter_qiniucloud_live_plugin.view.QiniucloudPushPlatformView;

/**
 * FlutterQiniucloudLivePlugin
 */
public class FlutterQiniucloudLivePlugin implements FlutterPlugin, MethodCallHandler {

    private final static String TAG = FlutterQiniucloudLivePlugin.class.getName();

    /**
     * 全局上下文
     */
    private Context context;

    public FlutterQiniucloudLivePlugin() {
    }

    private FlutterQiniucloudLivePlugin(BinaryMessenger messenger, Context context, MethodChannel channel, PlatformViewRegistry registry) {
        this.context = context;

        // 初始化七牛云
        StreamingEnv.init(context);

        // 注册View
        registry.registerViewFactory(QiniucloudPushPlatformView.SIGN, new QiniucloudPushPlatformView(context, messenger));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_qiniucloud_live_plugin");
        channel.setMethodCallHandler(new FlutterQiniucloudLivePlugin(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext(), channel, flutterPluginBinding.getPlatformViewRegistry()));
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_qiniucloud_live_plugin");
        channel.setMethodCallHandler(new FlutterQiniucloudLivePlugin(registrar.messenger(), registrar.context(), channel, registrar.platformViewRegistry()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.d(TAG, "onMethodCall: 调用方法:" + call.method + ",参数:" + call.arguments);
//        if (call.method.equals("init")) {
//            result.success("Android " + android.os.Build.VERSION.RELEASE);
//        } else {
//            result.notImplemented();
//        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
