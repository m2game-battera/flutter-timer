import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'タイマー'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _initSecond = 0;
  int _lastSecond = 0;
  String _strElapsedTime = "00:00:00";
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_isStarted == false) return;

      _lastSecond -= 1;
      if (_lastSecond <= 0) {
        _lastSecond = 0;
        _isStarted = false;
      }
      updateTimeText(_lastSecond);
    });
  }

  void updateTimeText(int t) {
    setState(() {
      int hour = t ~/ 3600;
      int minute = (t % 3600) ~/ 60;
      int second = t % 60;

      _strElapsedTime =
          '${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}:${second.toString().padLeft(2, "0")}';
    });
  }

  @override
  Widget build(BuildContext context) {
    // 横幅の８割
    final circleWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularPercentIndicator(
              radius: circleWidth / 2,
              lineWidth: 10.0,
              percent: _initSecond == 0 ? 0 : _lastSecond / _initSecond,
              //center: new Text("100%"),
              progressColor: Colors.red,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text(
                    _strElapsedTime,
                    style: const TextStyle(
                      fontSize: 30,
                      letterSpacing: 10,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  onTap: () async {
                    final result = await showTimerPicker(context);
                    if (result != null) {
                      _initSecond = result;
                      _lastSecond = _initSecond;
                      updateTimeText(_lastSecond);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
//                      style: ElevatedButton.styleFrom(fixedSize: Size(100, 50)),
                      child: Text(
                        'キャンセル',
                      ),
                      onPressed: () {
                        _isStarted = false;
                      },
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      child: Text(
                        _isStarted
                            ? (_lastSecond > 0)
                                ? '再開'
                                : '一時停止'
                            : '開始',
                      ),
                      onPressed: () {
                        setState(() {
                          _isStarted = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _isStarted ? Colors.red : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> showTimerPicker(BuildContext context) async {
    final results = await Picker(
      adapter: NumberPickerAdapter(data: [
        const NumberPickerColumn(
          begin: 0,
          end: 23,
          columnFlex: 1,
          suffix: Text(
            '時間',
            style: TextStyle(height: 1.1),
          ),
        ),
        const NumberPickerColumn(
            begin: 0,
            end: 59,
            columnFlex: 1,
            suffix: Text(
              '分',
              style: TextStyle(height: 1.1),
            )),
        const NumberPickerColumn(
            begin: 0,
            end: 59,
            columnFlex: 1,
            suffix: Text(
              '秒',
              style: TextStyle(height: 1.1),
            )),
      ]),
      hideHeader: true,
      title: const Text("時間を設定してください"),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      cancelText: "キャンセル",
      confirmText: "決定",
    ).showDialog(context);

    // キャンセル時
    if (results == null) return null;

    return results[0] * 3600 + results[1] * 60 + results[2];
  }
}
