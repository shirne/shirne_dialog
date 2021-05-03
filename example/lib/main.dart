import 'dart:async';

import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Dialog Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Easy Dialog Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    EasyDialog.of(context).toast('提示信息');
                  },
                  child: Text('Toast'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    EasyDialog.of(context)
                        .toast('提示信息', align: EasyDialog.alignBottom);
                  },
                  child: Text('Toast Bottom'),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                EasyDialog.of(context).alert(Text('提示信息'));
              },
              child: Text('Alert'),
            ),
            ElevatedButton(
              onPressed: () {
                var controller = EasyDialog.of(context).confirm(Text('是否确认'));
                controller.result.then((v) {
                  if (v) {
                    EasyDialog.of(context).toast('好的');
                    controller.close();
                  } else {
                    EasyDialog.of(context)
                        .toast('em...', align: EasyDialog.alignBottom);
                  }
                });
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                EasyDialog.of(context).popup(Text('提示信息'));
              },
              child: Text('Popup'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  EasyDialog.of(context).snack('提示信息');
                },
                child: Text('Snack'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  var controller;
                  controller = EasyDialog.of(context).snack(
                    '提示信息',
                    action: TextButton(
                      onPressed: () {
                        controller.close();
                      },
                      child: Text('确认', style: TextStyle(color: Colors.white),),
                    ),
                  );
                },
                child: Text('Snack with Action'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  var controller;
                  controller = EasyDialog.of(context).snack(
                    '多个操作',
                    action:
                        ListBody(
                          mainAxis: Axis.horizontal,
                          children: [
                          TextButton(
                            onPressed: () {
                              controller.close();
                            },
                            child: Text('取消', style: TextStyle(color: Colors.white),
                            ),
                          ),
                            ElevatedButton(
                              onPressed: () {
                                EasyDialog.of(context).toast('好的好的');
                              },
                              child: Text('确认', style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],)

                  );
                },
                child: Text('Snack with Actions'),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    EasyDialog.of(context).loading('加载中');
                  },
                  child: Text('Loading'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    var controller = EasyDialog.of(context)
                        .loading('加载中', showProgress: true, time: 0);
                    Timer(Duration(milliseconds: 500), () {
                      controller.update(20);
                      Timer(Duration(milliseconds: 1000), () {
                        controller.update(40);
                        Timer(Duration(milliseconds: 300), () {
                          controller.update(60);
                          Timer(Duration(milliseconds: 500), () {
                            controller.update(80);
                            Timer(Duration(milliseconds: 1000), () {
                              controller.update(100);
                            });
                          });
                        });
                      });
                    });
                  },
                  child: Text('Loading with progress'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
