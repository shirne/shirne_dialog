library shirne_dialog;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'image_preview.dart';
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
  Future<bool?> confirm(
    dynamic message, {
    String buttonText = 'OK',
    String title = '',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    return modal<bool>(
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
              Navigator.pop(context, false);
            },
            child: Text(cancelText)),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(buttonText)),
      ],
      title: title,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// show a small modal with one button which text is `buttonText`.
  /// the `message` may be a [Widget] or [String]
  Future<bool?> alert(
    message, {
    String buttonText = 'OK',
    String title = '',
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    return modal<bool>(
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
            Navigator.pop(context, true);
          },
          child: Text(buttonText),
        ),
      ],
      title: title,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// show a modal witch content is `body`,with any `buttons`.
  /// The modal title will be hidden if `title` isEmpty
  Future<T?> modal<T>(
    Widget body,
    List<Widget> buttons, {
    String title = '',
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
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
  }

  Future<dynamic> imagePreview(
    List<String> images, {
    String? currentImage,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return ImagePreviewWidget(
          imageUrls: images,
          currentImage: currentImage,
        );
      },
    );
  }

  /// show a modal popup with `body` witch width will fill the screen
  Future<T?> popup<T>(
    Widget body, {
    barrierDismissible = false,
    double height = 0,
    double borderRound = 10,
    EdgeInsetsGeometry padding = const EdgeInsets.all(10),
    Color barrierColor: Colors.black54,
    Color? backgroundColor,
    bool isDismissible: true,
    bool isScrollControlled: false,
    double? elevation,
    bool showClose = true,
    Widget closeButton = const Icon(
      Icons.cancel,
      color: Colors.black38,
    ),
  }) {
    return showModalBottomSheet<T>(
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
          showClose: showClose,
          closeButton: closeButton,
        );
      },
    );
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
