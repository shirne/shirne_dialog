import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class SubPage extends StatefulWidget {
  final String title;
  SubPage({Key? key, this.title = ''}) : super(key: key);

  @override
  _SubPageState createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
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
                    MyDialog.toast('提示信息');
                  },
                  child: Text('Toast'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('提示信息', align: MyDialog.theme.alignBottom);
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
                        MyDialog.of(context)
                            .toast('em...', align: MyDialog.theme.alignBottom);
                      }
                    });
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 10,
                children: List.generate(
                  images.length,
                  (index) => GestureDetector(
                    onTap: () {
                      MyDialog.imagePreview(
                        images,
                        currentImage: images[index],
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 100,
                      ),
                      child: Image.network(images[index]),
                    ),
                  ),
                ),
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
