import 'package:flutter/material.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class CustomPage extends StatefulWidget {
  final String title;
  const CustomPage({Key? key, this.title = ''}) : super(key: key);

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ShirneDialogTheme(
            toastStyle: const ToastStyle(
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
            defaultButtonStyle: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: Colors.black87,
            ),
            alertStyle: const ModalStyle(
              actionsPadding: EdgeInsets.all(8),
              expandedAction: true,
              buttonPadding: EdgeInsets.symmetric(vertical: 4),
            ),
            modalStyle: ModalStyle.separated(
              buttonPadding: const EdgeInsets.symmetric(vertical: 4),
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
    final dialog = MyDialog.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 8),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 如果样式是挂载在MaterialApp的theme上的话
                    // 可以直接使用MyDialog.toast
                    dialog.toast(
                      '提示信息',
                      icon: const Icon(Icons.mobile_friendly),
                    );
                  },
                  child: const Text('Toast with custom icon'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    dialog.toast(
                      '提示信息',
                      iconType: IconType.warning,
                    );
                  },
                  child: const Text('Toast warning'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    dialog.toast(
                      '操作成功',
                      iconType: IconType.success,
                    );
                  },
                  child: const Text('Toast success'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    dialog.alert(const Text('提示信息'));
                  },
                  child: const Text('Alert'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    dialog.confirm(const Text('是否确认')).then((v) {
                      if (v ?? false) {
                        dialog.toast('好的');
                      } else {
                        dialog.toast(
                          'em...',
                          style: dialog.theme.toastStyle?.bottom(),
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
