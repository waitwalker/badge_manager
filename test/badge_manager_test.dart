import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:badge_manager/badge_manager.dart';

void main() {
  const MethodChannel channel = MethodChannel('badge_manager');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });


}
