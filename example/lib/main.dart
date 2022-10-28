import 'dart:async';
import 'dart:ui';
import 'dart:math' show max;

import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'images.dart';
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
  ThemeData theme = ThemeData.light().copyWith(
    visualDensity: VisualDensity.standard,
    extensions: [const ShirneDialogTheme()],
  );

  setTheme(ThemeData newTheme) {
    setState(() {
      theme = newTheme.copyWith(
        visualDensity: VisualDensity.standard,
        extensions: [const ShirneDialogTheme()],
      );
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
                setState(() {});
                final appState = context.findAncestorStateOfType<MyAppState>();
                if (appState != null) {
                  appState
                      .setTheme(isDark ? ThemeData.dark() : ThemeData.light());
                }
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      MyDialog.prompt(
                        title: '请输入数字',
                        onConfirm: (v) {
                          final s = int.tryParse(v);
                          if (s == null) {
                            MyDialog.toast(
                              '请输入数字',
                              style: MyDialog.theme.toastStyle?.top(),
                            );
                            return false;
                          }
                          return true;
                        },
                      ).then((v) {
                        if (v == null) {
                          MyDialog.toast('取消了输入');
                        } else {
                          MyDialog.toast('输入内容 $v');
                        }
                      });
                    },
                    child: const Text('Prompt'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      MyDialog.prompt(
                        title: '请输入数字',
                        onConfirm: (v) async {
                          final s = int.tryParse(v);
                          final c = MyDialog.loading('checking...');
                          await Future.delayed(const Duration(seconds: 3));
                          c.close();
                          if (s == null) {
                            MyDialog.toast(
                              '请输入数字',
                              style: MyDialog.theme.toastStyle?.top(),
                            );
                            return false;
                          }
                          return true;
                        },
                      ).then((v) {
                        if (v == null) {
                          MyDialog.toast('取消了输入');
                        } else {
                          MyDialog.toast('输入内容 $v');
                        }
                      });
                    },
                    child: const Text('Prompt Future Verify'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          color: Theme.of(context).colorScheme.surface,
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
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                      final controller = MyDialog.loading(
                        '加载中',
                        showProgress: true,
                        duration: Duration.zero,
                      );
                      Timer.periodic(const Duration(milliseconds: 500),
                          (timer) {
                        controller.value += 0.2;

                        if (controller.value >= 1) {
                          timer.cancel();
                        }
                      });
                    },
                    child: const Text('Loading with progress'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final controller = MyDialog.loading(
                        '加载中',
                        showProgress: true,
                        duration: Duration.zero,
                        builder: (context, value) {
                          final progress = (value * 100).round();
                          return Material(
                            elevation: progress % 10,
                            shape: const CircleBorder(),
                            child: Container(
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: const [
                                    Colors.white,
                                    Colors.white,
                                    Colors.blue,
                                    Colors.blue,
                                  ],
                                  stops: [
                                    0,
                                    max(0, (100 - progress) / 100 - 0.1),
                                    (100 - progress) / 100,
                                    1
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Text(
                                '$progress%',
                                style: TextStyle(
                                  color: Color.lerp(
                                    Colors.black,
                                    Colors.white,
                                    value < 0.4
                                        ? 0
                                        : (value > 0.5
                                            ? 1
                                            : (value - 0.4) * 10),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      Timer.periodic(const Duration(milliseconds: 500),
                          (timer) {
                        controller.value += 0.2;
                        if (controller.value >= 1) {
                          timer.cancel();
                        }
                      });
                    },
                    child: const Text('Loading with Customer'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
                  FocusNode focusNode = FocusNode();
                  return ElevatedButton(
                    onPressed: () {
                      final renderObject =
                          focusNode.context!.findRenderObject()!;
                      late final EntryController controller;
                      final offset = (renderObject as RenderBox)
                          .localToGlobal(Offset.zero);
                      controller = MyDialog.dropdown(
                        [
                          GestureDetector(
                            onTap: () {
                              controller.close();
                            },
                            child: const Text('Menu 1'),
                          ),
                          const Text('Text'),
                        ],
                        origRect: renderObject.paintBounds
                            .translate(offset.dx, offset.dy),
                      );
                    },
                    focusNode: focusNode,
                    child: const Text('Dropdown'),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
