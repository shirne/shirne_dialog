import 'dart:async';
import 'dart:ui';

import 'package:example/new_page.dart';
import 'package:example/sub_page.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeData theme = ThemeData.light();

  setTheme(ThemeData newTheme) {
    setState(() {
      theme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shirne Dialog Demo',
      theme: theme,
      scrollBehavior: MyCustomScrollBehavior(),
      home: MyHomePage(title: 'Shirne Dialog Demo'),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDark = false;
  final images = <String>[
    'https://img.shirne.com/website-mapp/1.png',
    'https://img.shirne.com/website-mapp/2.png',
    'https://img.shirne.com/website-mapp/3.png',
    'https://img.shirne.com/website-mapp/4.png',
    'https://img.shirne.com/website-mapp/5.png',
    'https://img.shirne.com/website-mapp/6.png',
  ];

  @override
  Widget build(BuildContext context) {
    MyDialog.initialize(
      context,
      MyDialogSetting(
        buttonTextOK: '确定',
        buttonTextCancel: '取消',
        primaryButtonStyle: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
        ),
        cancelButtonStyle: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
        ),
        modalSetting: ModalSetting(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Switch(
              value: isDark,
              onChanged: (bool newValue) {
                isDark = newValue;
                final appState = context.findAncestorStateOfType<MyAppState>();
                if (appState != null) {
                  appState
                      .setTheme(isDark ? ThemeData.dark() : ThemeData.light());
                }
              })
        ],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return SubPage(title: 'sub page');
                        },
                      ),
                    );
                  },
                  child: Text('子页'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return NewPage(title: '动态调用示例');
                        },
                      ),
                    );
                  },
                  child: Text('动态调用示例'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.toast('提示信息');
                  },
                  child: Text('Toast'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.toast('提示信息', align: MyDialog.alignBottom);
                  },
                  child: Text('Toast Bottom'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.toast('操作成功', iconType: IconType.success);
                  },
                  child: Text('Toast with Icon'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.alert(Text('提示信息'));
                  },
                  child: Text('Alert'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.confirm(Text('是否确认')).then((v) {
                      if (v ?? false) {
                        MyDialog.toast('好的');
                      } else {
                        MyDialog.toast('em...', align: MyDialog.alignBottom);
                      }
                    });
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length * 2 - 1,
                (index) => index % 2 == 0
                    ? GestureDetector(
                        onTap: () {
                          MyDialog.imagePreview(
                            images,
                            currentImage: images[index ~/ 2],
                          );
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: Image.network(images[index ~/ 2]),
                        ),
                      )
                    : SizedBox(width: 10),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  MyDialog.popup(Text('弹出窗内容'));
                },
                child: Text('Popup'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  MyDialog.popup(Text('弹出窗内容'), height: 100);
                },
                child: Text('Popup height 100'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  MyDialog.popup(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.snack('提示信息');
                  },
                  child: Text('Snack'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    var controller;
                    controller = MyDialog.snack(
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
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    var controller;
                    controller = MyDialog.snack('多个操作',
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
                                MyDialog.toast('好的好的');
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.loading('加载中');
                  },
                  child: Text('Loading'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    var controller =
                        MyDialog.loading('加载中', showProgress: true, time: 0);
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
