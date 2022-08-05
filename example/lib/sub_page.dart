import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class SubPage extends StatefulWidget {
  final String title;
  const SubPage({Key? key, this.title = ''}) : super(key: key);

  @override
  State<SubPage> createState() => _SubPageState();
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
                  child: const Text('Toast'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('提示信息', align: MyDialog.theme.alignBottom);
                  },
                  child: const Text('Toast Bottom'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context)
                        .toast('操作成功', iconType: IconType.success);
                  },
                  child: const Text('Toast with Icon'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.alert(const Text('提示信息'));
                  },
                  child: const Text('Alert'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.confirm(const Text('是否确认')).then((v) {
                      if (v ?? false) {
                        MyDialog.toast('好的');
                      } else {
                        MyDialog.of(context)
                            .toast('em...', align: MyDialog.theme.alignBottom);
                      }
                    });
                  },
                  child: const Text('Confirm'),
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
                      constraints: const BoxConstraints(
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
                  MyDialog.popup(const Text('弹出窗内容'));
                },
                child: const Text('Popup'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  MyDialog.popup(const Text('弹出窗内容'), height: 100);
                },
                child: const Text('Popup height 100'),
              ),
              const SizedBox(width: 10),
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
                child: const Text('Popup with scroll'),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.snack('提示信息');
                  },
                  child: const Text('Snack'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    EntryController? controller;
                    controller = MyDialog.snack(
                      '提示信息',
                      action: TextButton(
                        onPressed: () {
                          controller?.close();
                        },
                        child: const Text(
                          '确认',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  child: const Text('Snack with Action'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    EntryController? controller;
                    controller = MyDialog.snack('多个操作',
                        action: ListBody(
                          mainAxis: Axis.horizontal,
                          children: [
                            TextButton(
                              onPressed: () {
                                controller?.close();
                              },
                              child: const Text(
                                '取消',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                MyDialog.toast('好的好的');
                              },
                              child: const Text(
                                '确认',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ));
                  },
                  child: const Text('Snack with Actions'),
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
                  child: const Text('Loading'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    var controller = MyDialog.of(context)
                        .loading('加载中', showProgress: true, time: 0);
                    Timer(const Duration(milliseconds: 500), () {
                      controller.update(0.2);
                      Timer(const Duration(milliseconds: 1000), () {
                        controller.update(0.4);
                        Timer(const Duration(milliseconds: 300), () {
                          controller.update(0.6);
                          Timer(const Duration(milliseconds: 500), () {
                            controller.update(0.8);
                            Timer(const Duration(milliseconds: 1000), () {
                              controller.update(1);
                            });
                          });
                        });
                      });
                    });
                  },
                  child: const Text('Loading with progress'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
