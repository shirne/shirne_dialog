import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class NewPage extends StatefulWidget {
  NewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
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
  void initState() {
    super.initState();
    MyDialog.setting = MyDialogSetting(
      buttonTextOK: '确定',
      buttonTextCancel: '取消',
    );
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return NewPage(title: 'sub page');
                        },
                      ),
                    );
                  },
                  child: Text('子页'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).toast('提示信息');
                  },
                  child: Text('Toast'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('提示信息', align: MyDialog.setting.alignBottom);
                  },
                  child: Text('Toast Bottom'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('操作成功', iconType: IconType.success);
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
                    MyDialog.of(context).alert(Text('提示信息'));
                  },
                  child: Text('Alert'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).confirm(Text('是否确认')).then((v) {
                      if (v ?? false) {
                        MyDialog.of(context).toast('好的');
                      } else {
                        MyDialog.of(context).toast('em...',
                            align: MyDialog.setting.alignBottom);
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
                          MyDialog.of(context).imagePreview(
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
                  MyDialog.of(context).popup(Text('弹出窗内容'));
                },
                child: Text('Popup'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  MyDialog.of(context).popup(Text('弹出窗内容'), height: 100);
                },
                child: Text('Popup height 100'),
              ),
              SizedBox(width: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).snack('提示信息');
                  },
                  child: Text('Snack'),
                ),
                SizedBox(width: 10),
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
                SizedBox(width: 10),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).loading('加载中');
                  },
                  child: Text('Loading'),
                ),
                SizedBox(width: 10),
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