import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class ToastPage extends StatefulWidget {
  final String title;
  const ToastPage({Key? key, this.title = ''}) : super(key: key);

  @override
  State<ToastPage> createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          const ShirneDialogTheme(
            toastStyle: ToastStyle(
              direction: Axis.vertical,
              iconTheme: IconThemeData(size: 80),
              textStyle: TextStyle(fontSize: 16),
              enterAnimation: AnimationConfig(
                startAlign: Alignment(0, -0.1),
                endAlign: Alignment.center,
                startOpacity: 0,
                endOpacity: 1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
            ),
            alertStyle: ModalStyle(
              actionsPadding: EdgeInsets.all(8),
              expandedAction: true,
            ),
            modalStyle: ModalStyle(
              expandedAction: true,
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      child: ToastInnerPage(title: widget.title),
    );
  }
}

class ToastInnerPage extends StatelessWidget {
  const ToastInnerPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                    // 如果样式是挂载在MaterialApp的theme上的话
                    // 可以直接使用MyDialog.toast
                    MyDialog.of(context).toast(
                      '提示信息',
                      icon: const Icon(Icons.mobile_friendly),
                    );
                  },
                  child: const Text('Toast'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).toast(
                      '提示信息',
                      iconType: IconType.warning,
                    );
                  },
                  child: const Text('Toast Top'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).toast(
                      '操作成功',
                      iconType: IconType.success,
                    );
                  },
                  child: const Text('Toast with Icon'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).alert(const Text('提示信息'));
                  },
                  child: const Text('Alert'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    MyDialog.of(context).confirm(const Text('是否确认')).then((v) {
                      if (v ?? false) {
                        MyDialog.toast('好的');
                      } else {
                        MyDialog.of(context).toast(
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
