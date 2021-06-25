library shirne_dialog;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'popup.dart';
import 'progress.dart';
import 'snack.dart';
import 'toast.dart';

/// static class to call alert, confirm, toast etc.
class MyDialog {
  BuildContext context;

  /// construct with a [BuildContext]
  MyDialog.of(this.context);

  /// detault top position for [toast]
  static const alignTop = const Alignment(0.0, -0.7);

  /// default bottom position for [toast]
  static const alignBottom = const Alignment(0.0, 0.7);

  /// transform string to [Alignment] that use for [toast]
  static Alignment getAlignment(String align) {
    switch (align.toLowerCase()) {
      case "top":
      case "topcenter":
        return alignTop;
      case "center":
        return Alignment.center;
      default:
        return alignBottom;
    }
  }

  /// success icon for [toast]
  static const iconSuccess = const Icon(
    CupertinoIcons.checkmark_circle_fill,
    color: Colors.green,
  );

  /// error icon for [toast]
  static const iconError =
      const Icon(CupertinoIcons.multiply_circle_fill, color: Colors.red);

  /// warning icon for [toast]
  static const iconWarning = const Icon(
      CupertinoIcons.exclamationmark_triangle_fill,
      color: Colors.deepOrangeAccent);

  /// info icon for [toast]
  static const iconInfo = const Icon(CupertinoIcons.exclamationmark_circle_fill,
      color: Colors.blue);

  /// show a confirm Modal box.
  /// the [message] may be a [Widget] or [String]
  Future<bool?>? confirm(dynamic message,
      {String buttonText = 'OK',
      String title = '',
      String cancelText = 'Cancel'}) {
    late ModalController controller;
    Completer completer = Completer<bool>();
    controller = modal(
      message is Widget
          ? message
          : ListBody(
              children: message
                  .toString()
                  .split('\n')
                  .map<Widget>((item) => Text(item))
                  .toList()),
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
    ) as ModalController;
    controller.result = completer.future;

    return controller.result as Future<bool?>?;
  }

  /// show a small modal with one button which text is `buttonText`.
  /// the `message` may be a [Widget] or [String]
  Future<void> alert(message, {String buttonText = 'OK', String title = ''}) {
    late ModalController controller;
    Completer completer = Completer<bool>();
    controller = modal(
      message is Widget
          ? message
          : ListBody(
              children: message
                  .toString()
                  .split('\n')
                  .map<Widget>((item) => Text(item))
                  .toList()),
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
    ) as ModalController;

    return completer.future;
  }

  /// show a modal witch content is `body`,with any `buttons`.
  /// The modal title will be hidden if `title` isEmpty
  DialogController modal(Widget body, List<Widget> buttons,
      {String title = '', barrierDismissible = false}) {
    ModalController controller = ModalController(context);
    controller.result = showDialog<dynamic>(
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

  /// show a modal popup with `body` witch width will fill the screen
  DialogController popup(Widget body,
      {barrierDismissible = false,
      double height = 0,
      double borderRound = 10,
      EdgeInsetsGeometry padding = const EdgeInsets.all(10),
      Color barrierColor: const Color.fromRGBO(0, 0, 0, .6),
      Color backgroundColor: Colors.white,
      bool isDismissible: true,
      bool isScrollControlled: false,
      double? elevation,
      bool showClose = true,
      Widget closeButton = const Icon(
        Icons.cancel,
        color: Colors.black38,
      )}) {
    ModalController controller = ModalController(context);
    controller.result = showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      context: context,
      elevation: elevation,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return PopupWidget(
          child: body,
          height: height,
          borderRound: borderRound,
          backgroundColor: backgroundColor,
          padding: padding,
          controller: controller,
          showClose: showClose,
          closeButton: closeButton,
        );
      },
    );

    return controller;
  }

  /// show a loading progress within an [OverlayEntry].
  /// keep in `time` seconds or manual control it's status by pass 0 to `time`
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

  /// show a light weight tip with in `message`, an `icon` is optional.
  void toast(String message,
      {int duration = 2, Alignment align = alignTop, Icon? icon}) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return ToastWidget(
        message,
        icon: icon,
        alignment: align,
        duration: duration,
      );
    });

    Overlay.of(context)!.insert(entry);
    Future.delayed(Duration(seconds: duration)).then((value) {
      // 移除层可以通过调用OverlayEntry的remove方法。
      entry.remove();
    });
  }

  /// show a [SnackBar] like Widget but use a diy Widget with [OverlayEntry]
  EntryController snack(String message,
      {Widget? action,
      int duration = 3,
      Alignment align = alignBottom,
      double width = 0.7}) {
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
    Future.delayed(Duration(seconds: duration)).then((value) {
      controller.close();
    });

    return controller;
  }
}
