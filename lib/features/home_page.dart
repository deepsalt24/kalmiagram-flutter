import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MethodChannel _methodChannel =
      const MethodChannel('kalmiagram_method_channel');
  final EventChannel _eventChannel =
      const EventChannel('kalmiagram_event_channel');

  final List _data = [];

  @override
  void initState() {
    super.initState();

    // 接收 java 传递的消息
    _eventChannel.receiveBroadcastStream().listen((event) {
      print(event.toString());
      _data.add(event);
      setState(() {});
    });
  }

  _sendDataToJava(String method, String data) async {
    try {
      String result = await _methodChannel.invokeMethod(method, {'data': data});
      Fluttertoast.showToast(
          msg: "调用 Java 返回: $result",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print('Error sending data to Java: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 120),
            GestureDetector(
              onTap: () =>
                  _sendDataToJava('sendDataToJava', 'Hello from Flutter!'),
              child: Container(
                width: 140,
                height: 35,
                color: Colors.blueGrey,
                child: const Text('Futter 调用 Java 方法'),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _sendDataToJava('sendDataToFlutter', ''),
              child: Container(
                width: 140,
                height: 35,
                color: Colors.blueGrey,
                child: const Text('Java 调用 Futter 方法'),
              ),
            ),
            const SizedBox(height: 40),
            const Text('来自 Java 的数据:'),
            Container(
              color: Colors.black12,
              width: double.infinity,
              margin: const EdgeInsets.all(40),
              child: SingleChildScrollView(
                child: Column(
                  children: _data
                      .map((e) => Container(
                            margin: const EdgeInsets.all(4),
                            child: Text(e),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
