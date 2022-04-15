
# BadgeManager
BadgeManager is a corner marker setting tool. Currently supports iOS and Android (Samsung, Huawei, Xiaomi, etc.). If you need other functions, you can expand on this basis.

## Add dependency

```yaml
dependencies:
  badge_manager: lastest version  
```

## Simple to use

```
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


  /// methodName isSupported
  /// description 是否支持设置角标 
  /// date 2022/4/15 18:42
  /// author waitwalker
  void isSupported() async {
    final bool value = await BadgeManager.isSupportedBadge();
    setState(() {
      supported = value ? "true" : "false";
    });
  }

  /// methodName getBrand
  /// description 获取手机品牌 
  /// date 2022/4/15 18:42
  /// author waitwalker
  void getBrand() async{
    final String brand = await BadgeManager.getBrand();
    setState(() {
      brandStr = brand;
    });
  }

  /// methodName setBadge
  /// description 设置角标
  /// date 2022/4/15 18:42
  /// author waitwalker
  void setBadge() async{
    await BadgeManager.setBadge(count: int.parse(controller.text), title: "通知", content: "this is content");
  }

  /// methodName setBadge
  /// description 移除角标
  /// date 2022/4/15 18:42
  /// author waitwalker
  void removeBadge() async{
    await BadgeManager.removeBadge();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('BadgeManager'),
        ),
        resizeToAvoidBottomInset: false,
        body: InkWell(
          child: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          FocusScope.of(context).requestFocus(FocusNode());
                          isSupported();
                        },
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
                          FocusScope.of(context).requestFocus(FocusNode());
                          getBrand();
                        },
                      ),

                      const Padding(padding: EdgeInsets.only(top: 30)),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: CupertinoTextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          placeholder: "请输入badge的数字",
                        ),
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
                          if (controller.text.isNotEmpty) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setBadge();
                          } else {
                            Fluttertoast.showToast(msg: "请先输入badge count");
                          }
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
                          FocusScope.of(context).requestFocus(FocusNode());
                          removeBadge();
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 330)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
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
```


## Copyright & License

This project is completely open source and the license is MIT. If you like, welcome star.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/waitwalker/badge_manager/issues

## Flutter Technology and Other Communication Groups

Scan QR code👇:

<img src="https://github.com/waitwalker/Resources/blob/master/Flutter/group/flutter_development_0923.JPG?raw=true" width="350" height="500" align=center />
