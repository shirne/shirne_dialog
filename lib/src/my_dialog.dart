library shirne_dialog;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'image_preview.dart';
import 'popup.dart';
import 'progress.dart';
import 'setting.dart';
import 'snack.dart';
import 'toast.dart';

enum IconType {
  none,
  success,
  error,
  warning,
  info,
}

/// static class to call alert, confirm, toast etc.
class MyDialog {
  BuildContext context;

  static Setting globalSetting = const Setting();
  final Setting? setting;

  /// construct with a [BuildContext]
  MyDialog.of(this.context, [this.setting]);

  /// detault top position for [toast]
  @Deprecated('use globalSetting/setting insted.')
  static Alignment get alignTop => globalSetting.alignTop;

  /// default bottom position for [toast]
  @Deprecated('use globalSetting/setting insted.')
  static Alignment get alignBottom => globalSetting.alignBottom;

  /// transform string to [Alignment] that use for [toast]
  static Alignment getAlignment(String align) {
    switch (align.toLowerCase()) {
      case "top":
      case "topcenter":
        return globalSetting.alignTop;
      case "center":
        return Alignment.center;
      default:
        return globalSetting.alignBottom;
    }
  }

  /// success icon for [toast]
  @Deprecated('use globalSetting/setting insted.')
  static Widget get iconSuccess => globalSetting.iconSuccess;

  /// error icon for [toast]
  @Deprecated('use globalSetting/setting insted.')
  static Widget get iconError => globalSetting.iconError;

  /// warning icon for [toast]
  @Deprecated('use globalSetting/setting insted.')
  static Widget get iconWarning => globalSetting.iconWarning;

  /// info icon for [toast]
  @Deprecated('use globalSetting/setting insted.')
  static Widget get iconInfo => globalSetting.iconInfo;

  static Widget? getIcon(IconType iconType, [Setting? setting]) {
    switch (iconType) {
      case IconType.error:
        return setting?.iconError ?? globalSetting.iconError;
      case IconType.success:
        return setting?.iconSuccess ?? globalSetting.iconSuccess;
      case IconType.warning:
        return setting?.iconWarning ?? globalSetting.iconWarning;
      case IconType.info:
        return setting?.iconInfo ?? globalSetting.iconInfo;
      default:
        return null;
    }
  }

  /// show a confirm Modal box.
  /// the [message] may be a [Widget] or [String]
  Future<bool?> confirm(
    dynamic message, {
    String? buttonText,
    String title = '',
    String? cancelText,
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
            child: Text(cancelText ??
                setting?.buttonTextCancel ??
                globalSetting.buttonTextCancel)),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(buttonText ??
                setting?.buttonTextOK ??
                globalSetting.buttonTextOK)),
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
    String? buttonText,
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
          child: Text(buttonText ??
              setting?.buttonTextOK ??
              globalSetting.buttonTextOK),
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
    Color barrierColor = Colors.black54,
    Color? backgroundColor,
    bool isDismissible = true,
    bool isScrollControlled = false,
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
      {int duration = 2,
      Alignment? align,
      Icon? icon,
      IconType iconType = IconType.none}) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return ToastWidget(
        message,
        icon: icon ?? getIcon(iconType, setting),
        alignment: align ?? setting?.alignTop ?? globalSetting.alignTop,
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
      Alignment? align,
      double width = 0.7}) {
    ValueNotifier<int> progressNotify = ValueNotifier<int>(0);
    EntryController controller = EntryController(context, progressNotify);
    controller.entry = OverlayEntry(builder: (context) {
      return SnackWidget(
        message,
        alignment: align ?? setting?.alignBottom ?? globalSetting.alignBottom,
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
