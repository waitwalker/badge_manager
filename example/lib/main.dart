import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badge_manager/badge_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  late TextEditingController controller;

  String brandStr = "";
  String supported = "";

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        print("App进入后台了");
        setBadge();
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    controller = TextEditingController();
    super.initState();
  }


  void isSupported() async {
    final bool value = await BadgeManager.isSupportedBadge();
    setState(() {
      supported = value ? "true" : "false";
    });
  }

  void getBrand() async{
    final String brand = await BadgeManager.getBrand();
    setState(() {
      brandStr = brand;
    });
  }

  void setBadge() async{
    await BadgeManager.setBadge(count: int.parse(controller.text), title: "通知", content: "this is content");
  }

  void removeBadge() async{
    await BadgeManager.removeBadge();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            Text("是否支持：" + supported),
            const Padding(padding: EdgeInsets.only(top: 30)),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1.5,
                      spreadRadius: 2.5,),
                  ],
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                height: 50,
                width: 300,
                child: const Text("点击查看是否支持",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              onTap: (){
                isSupported();
              },
            ),

            const Padding(padding: EdgeInsets.only(top: 30)),
            SizedBox(
              height: 50,
              child: CupertinoTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                placeholder: "请输入badge的数字",
              ),
            ),

            const Padding(padding: EdgeInsets.only(top: 30)),
            Text("手机品牌：" + brandStr),
            const Padding(padding: EdgeInsets.only(top: 30)),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1.5,
                      spreadRadius: 2.5,),
                  ],
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                height: 50,
                width: 300,
                child: const Text("点击获取手机品牌",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              onTap: (){
                getBrand();
              },
            ),

            const Padding(padding: EdgeInsets.only(top: 30)),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1.5,
                      spreadRadius: 2.5,),
                  ],
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                height: 50,
                width: 300,
                child: const Text("点击设置角标",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              onTap: (){
                setBadge();
              },
            ),

            const Padding(padding: EdgeInsets.only(top: 30)),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1.5,
                      spreadRadius: 2.5,),
                  ],
                  color: Colors.lime,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                height: 50,
                width: 300,
                child: const Text("点击移除角标",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              onTap: (){
                removeBadge();
              },
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }
}
