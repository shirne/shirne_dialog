import 'dart:async';
import 'dart:ui';

import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'new_page.dart';
import 'sub_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeData theme =
      ThemeData.light().copyWith(extensions: [const ShirneDialogTheme()]);

  setTheme(ThemeData newTheme) {
    setState(() {
      theme = newTheme.copyWith(extensions: [const ShirneDialogTheme()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shirne Dialog Demo',
      localizationsDelegates: const [
        ShirneDialogLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: MyDialog.navigatorKey,
      theme: theme,
      scrollBehavior: MyCustomScrollBehavior(),
      home: const MyHomePage(title: 'Shirne Dialog Demo'),
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
        PointerDeviceKind.unknown,
      };
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, this.title = ''}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
                          return const SubPage(title: 'sub page');
                        },
                      ),
                    );
                  },
                  child: const Text('子页'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const NewPage(title: '动态调用示例');
                        },
                      ),
                    );
                  },
                  child: const Text('动态调用示例'),
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
                  child: const Text('Toast'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.toast(
                      '提示信息',
                      style: MyDialog.theme.toastStyle?.top(),
                    );
                  },
                  child: const Text('Toast Top'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.toast('操作成功', iconType: IconType.success);
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
                        MyDialog.toast(
                          'em...',
                          style: MyDialog.theme.toastStyle?.bottom(),
                        );
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
                  MyDialog.popup(Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                      Text('弹出窗内容'),
                    ],
                  ));
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
                    const Text('弹出窗内容'),
                    height: 100,
                    margin: const EdgeInsets.all(16.0),
                    showClose: false,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                  );
                },
                child: const Text('Popup DIY'),
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
                    final controller =
                        MyDialog.loading('加载中', showProgress: true, time: 0);
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
