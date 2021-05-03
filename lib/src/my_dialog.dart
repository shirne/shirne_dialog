import 'dart:async';

import 'package:flutter/material.dart';

import 'controller.dart';
import 'popup.dart';
import 'progress.dart';
import 'snack.dart';
import 'toast.dart';

class MyDialog {
  BuildContext context;

  MyDialog.of(this.context);

  static const alignTop = const Alignment(0.0, -0.7);
  static const alignBottom = const Alignment(0.0, 0.7);

  Future<bool> confirm(message,
      {String buttonText = 'OK',
      String title = '',
      String cancelText = 'Cancel'}) {
    ModalController controller;
    Completer completer = Completer<bool>();
    controller = modal(
      message is Widget
          ? message
          : message
              .toString()
              .split('\n')
              .map<Widget>((item) => Text(item))
              .toList(),
      [
        TextButton(
            onPressed: () {
              controller.close();
              completer.complete(false);
            },
            child: Text(cancelText)),
        ElevatedButton(
            onPressed: () {
              controller.close();
              completer.complete(true);
            },
            child: Text(buttonText)),
      ],
      title: title,
    );
    controller.result = completer.future;

    return controller.result;
  }

  Future<void> alert(message,
      {String buttonText = 'OK', String title = ''}) {
    ModalController controller;
    Completer completer = Completer<bool>();
    controller = modal(
      message is Widget
          ? message
          : message
              .toString()
              .split('\n')
              .map<Widget>((item) => Text(item))
              .toList(),
      [
        ElevatedButton(
          onPressed: () {
            controller.close();
            completer.complete();
          },
          child: Text(buttonText),
        ),
      ],
      title: title,
    );

    return completer.future;
  }

  DialogController modal(Widget body, List<Widget> buttons,
      {String title = '', barrierDismissible = false}) {
    ModalController controller = ModalController(context);
    controller.result = showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isEmpty ? null : Text(title),
          content: SingleChildScrollView(
            child: body,
          ),
          actions: buttons,
        );
      },
    );
    return controller;
  }

  DialogController popup(Widget child, [bool isOpen = true]) {
    ValueNotifier<int> notifier = ValueNotifier<int>(0);
    EntryController controller = EntryController(context, notifier);
    controller.entry = OverlayEntry(builder: (context) {
      return PopupWidget(
        child: child,
        controller: controller,
      );
    });

    if (isOpen) {
      controller.open();
    }

    return controller;
  }

  DialogController loading(String message,
      {showProgress = false, showOverlay = true, double time = 3}) {
    ValueNotifier<int> progressNotify = ValueNotifier<int>(0);
    ProgressController controller = ProgressController(context, progressNotify);
    controller.entry = OverlayEntry(builder: (context) {
      return ProgressWidget(
        notifier: progressNotify,
        showProgress: showProgress,
        showOverlay: showOverlay,
        message: message,
        controller: controller,
      );
    });

    controller.open();

    if (time > 0) {
      Future.delayed(Duration(milliseconds: (time * 1000).toInt())).then((v) {
        controller.close();
      });
    }
    return controller;
  }

  void toast(String message,
      {int duration = 2, AlignmentGeometry align = alignTop}) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return ToastWidget(
        message,
        alignment: align,
        duration: duration,
      );
    });

    Overlay.of(context).insert(entry);
    Future.delayed(Duration(seconds: duration ?? 2)).then((value) {
      // 移除层可以通过调用OverlayEntry的remove方法。
      entry.remove();
    });
  }

  EntryController snack(String message,
      {Widget action,
      int duration = 3,
      AlignmentGeometry align = alignBottom,
      double width = 0.6}) {
    ValueNotifier<int> progressNotify = ValueNotifier<int>(0);
    EntryController controller = EntryController(context, progressNotify);
    controller.entry = OverlayEntry(builder: (context) {
      return SnackWidget(
        message,
        alignment: align,
        action: action,
        duration: duration,
        notifier: progressNotify,
        controller: controller,
        maxWidth: width,
      );
    });

    controller.open();
    Future.delayed(Duration(seconds: duration ?? 3)).then((value) {
      controller.close();
    });

    return controller;
  }
}
