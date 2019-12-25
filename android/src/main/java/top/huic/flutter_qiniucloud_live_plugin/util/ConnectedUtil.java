package top.huic.flutter_qiniucloud_live_plugin.util;

import java.util.HashMap;
import java.util.Map;

import top.huic.flutter_qiniucloud_live_plugin.view.QiniucloudConnectedPlayerPlatformView;

/**
 * 连麦工具类
 */
public class ConnectedUtil {
    private static Map<Integer, QiniucloudConnectedPlayerPlatformView> data = new HashMap<>();

    /**
     * 添加视图对象
     *
     * @param key 视图Id
     * @param v   视图
     */
    public static void add(Integer key, QiniucloudConnectedPlayerPlatformView v) {
        data.put(key, v);
    }

    /**
     * 删除视图对象
     *
     * @param key 视图Key
     */
    public static void remove(Integer key) {
        data.remove(key);
    }

    /**
     * 根据视图ID获得视图对象
     *
     * @param key 视图ID
     * @return 视图对象
     */
    public static QiniucloudConnectedPlayerPlatformView get(Integer key) {
        return data.get(key);
    }
}