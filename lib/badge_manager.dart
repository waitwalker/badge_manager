import 'dart:async';
import 'package:flutter/services.dart';

class BadgeManager {
  static const MethodChannel _channel = MethodChannel('badge_manager');

  /// methodName isSupportedBadge
  /// description 查看机型是否支持设置角标
  /// date 2022/4/15 18:01
  /// author waitwalker
  static Future<bool> isSupportedBadge() async{
    final bool supported = await _channel.invokeMethod("isSupported");
    return supported;
  }

  /// methodName getBrand
  /// description 获取手机品牌
  /// date 2022/4/15 18:01
  /// author waitwalker
  static Future<String> getBrand() async {
    final String brand = await _channel.invokeMethod("getBrand");
    return brand;
  }

  /// methodName setBadge
  /// description 设置角标 count是必传参数, 其他参数是Android必传
  /// date 2022/4/15 18:01
  /// author waitwalker
  static Future<void> setBadge({required int count, String? title, String? content,}) async{
    Map map = {
      "count":count,
      "title":title??"",
      "content":content??""
    };
    await _channel.invokeMethod("setBadge", map);
  }

  /// methodName removeBadge
  /// description 移除角标
  /// date 2022/4/15 18:02
  /// author waitwalker
  static Future<void> removeBadge() async{
    await _channel.invokeMethod("removeBadge");
  }
}
