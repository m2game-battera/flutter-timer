import 'dart:async';

import 'package:flutter/material.dart';

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
  int lastSecond = 0;
  String strElapsedTime = "00:00:00";
  bool isStarted = false;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        int hour = 23;
        int minute = 59;
        int second = 59;
        print("Here");
        strElapsedTime =
            '${hour.toString().padLeft(2)}:${minute.toString().padLeft(2)}:${second.toString().padLeft(2)}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  strElapsedTime,
                  style: TextStyle(
                    fontSize: 30,
                    letterSpacing: 10,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
//                      style: ElevatedButton.styleFrom(fixedSize: Size(100, 50)),
                      child: Text(
                        'キャンセル',
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      child: Text(isStarted
                          ? (lastSecond > 0)
                              ? '再開'
                              : '一時停止'
                          : '開始'),
                      onPressed: () {
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isStarted ? Colors.red : Theme.of(context).primaryColor,
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
}
