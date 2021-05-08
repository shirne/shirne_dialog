import 'dart:async';

import 'package:shirne_dialog/shirne_dialog.dart';
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
                    MyDialog.of(context).toast('提示信息');
                  },
                  child: Text('Toast'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('提示信息', align: MyDialog.alignBottom);
                  },
                  child: Text('Toast Bottom'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('操作成功', icon: MyDialog.iconSuccess);
                  },
                  child: Text('Toast with Icon'),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                MyDialog.of(context).alert(Text('提示信息'));
              },
              child: Text('Alert'),
            ),
            ElevatedButton(
              onPressed: () {
                MyDialog.of(context).confirm(Text('是否确认')).then((v) {
                  if (v) {
                    MyDialog.of(context).toast('好的');
                  } else {
                    MyDialog.of(context)
                        .toast('em...', align: MyDialog.alignBottom);
                  }
                });
              },
              child: Text('Confirm'),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  MyDialog.of(context).popup(Text('弹出窗内容'));
                },
                child: Text('Popup'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  MyDialog.of(context).popup(Text('弹出窗内容'), height: 100);
                },
                child: Text('Popup height 100'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  MyDialog.of(context).popup(
                      SingleChildScrollView(
                        child: ListBody(
                          children: List.generate(
                              50, (index) => Text('This is row $index')),
                        ),
                      ),
                      isScrollControlled: true);
                },
                child: Text('Popup with scroll'),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  MyDialog.of(context).snack('提示信息');
                },
                child: Text('Snack'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  var controller;
                  controller = MyDialog.of(context).snack(
                    '提示信息',
                    action: TextButton(
                      onPressed: () {
                        controller.close();
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(color: Colors.white),
                      ),
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
                  controller = MyDialog.of(context).snack('多个操作',
                      action: ListBody(
                        mainAxis: Axis.horizontal,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.close();
                            },
                            child: Text(
                              '取消',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              MyDialog.of(context).toast('好的好的');
                            },
                            child: Text(
                              '确认',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ));
                },
                child: Text('Snack with Actions'),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).loading('加载中');
                  },
                  child: Text('Loading'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    var controller = MyDialog.of(context)
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
