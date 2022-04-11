library shirne_dialog;

import 'dart:async';

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
  help,
}

/// static class to call alert, confirm, toast etc.
class MyDialog {
  static GlobalKey<NavigatorState>? _navigatorKey;
  static GlobalKey<NavigatorState> get navigatorKey {
    _navigatorKey ??= GlobalKey<NavigatorState>();
    return _navigatorKey!;
  }

  static MyDialogSetting setting = const MyDialogSetting(
    modalSetting: ModalSetting(),
  );

  static ShirneDialog? _instance;

  /// initialize a MyDialog instance
  static void initialize([BuildContext? context, MyDialogSetting? setting]) {
    if (context == null) {
      assert(_navigatorKey != null, "");
      assert(_navigatorKey!.currentContext != null, "");
    }
    _instance =
        ShirneDialog._(context ?? _navigatorKey!.currentContext!, setting);
  }

  /// return a MyDialog instance or construct new instance with [BuildContext]
  static ShirneDialog of([BuildContext? context, MyDialogSetting? setting]) {
    if (context != null) {
      return ShirneDialog._(context, setting);
    } else if (_instance == null) {
      if (_navigatorKey != null && _navigatorKey!.currentContext != null) {
        initialize();
      } else {
        throw ArgumentError.notNull('context');
      }
    }

    return _instance!;
  }

  /// transform string to [Alignment] that use for [toast]
  static Alignment getAlignment(String align) {
    switch (align.toLowerCase()) {
      case "top":
      case "topcenter":
        return setting.alignTop;
      case "center":
        return Alignment.center;
      default:
        return setting.alignBottom;
    }
  }

  static Widget? getIcon(IconType iconType, [MyDialogSetting? instSetting]) {
    switch (iconType) {
      case IconType.error:
        return instSetting?.iconError ?? setting.iconError;
      case IconType.success:
        return instSetting?.iconSuccess ?? setting.iconSuccess;
      case IconType.warning:
        return instSetting?.iconWarning ?? setting.iconWarning;
      case IconType.info:
        return instSetting?.iconInfo ?? setting.iconInfo;
      case IconType.help:
        return instSetting?.iconHelp ?? setting.iconHelp;
      default:
        return null;
    }
  }

  static void _checkInstance() {
    _instance ??= of();
  }

  static Future<bool?> confirm(
    dynamic message, {
    String? buttonText,
    String title = '',
    Widget? titleWidget,
    String? cancelText,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.confirm(
      message,
      buttonText: buttonText,
      title: title,
      titleWidget: titleWidget,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  static Future<bool?> alert(
    message, {
    String? buttonText,
    String title = '',
    Widget? titleWidget,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.alert(
      message,
      buttonText: buttonText,
      title: title,
      titleWidget: titleWidget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  static Future<T?> modal<T>(
    Widget body,
    List<Widget> buttons, {
    String title = '',
    Widget? titleWidget,
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.modal<T>(
      body,
      buttons,
      title: title,
      titleWidget: titleWidget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  static Future<dynamic> imagePreview(
    List<String> images, {
    String? currentImage,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.imagePreview(
      images,
      currentImage: currentImage,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  static Future<T?> popup<T>(
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
    _checkInstance();
    return _instance!.popup<T>(
      body,
      barrierDismissible: barrierDismissible,
      height: height,
      borderRound: borderRound,
      padding: padding,
      barrierColor: barrierColor,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      elevation: elevation,
      showClose: showClose,
      closeButton: closeButton,
    );
  }

  static DialogController loading(
    String message, {
    showProgress = false,
    showOverlay = true,
    double time = 3,
  }) {
    _checkInstance();
    return _instance!.loading(
      message,
      showProgress: showProgress,
      showOverlay: showOverlay,
      time: time,
    );
  }

  static void toast(
    String message, {
    int duration = 2,
    Alignment? align,
    @Deprecated('use iconType insted.') Widget? icon,
    IconType iconType = IconType.none,
  }) {
    _checkInstance();
    return _instance!.toast(
      message,
      duration: duration,
      align: align,
      // ignore: deprecated_member_use_from_same_package
      icon: icon,
      iconType: iconType,
    );
  }

  static EntryController snack(
    String message, {
    Widget? action,
    int duration = 3,
    Alignment? align,
    double width = 0.7,
  }) {
    _checkInstance();
    return _instance!.snack(
      message,
      action: action,
      duration: duration,
      align: align,
      width: width,
    );
  }
}

class ShirneDialog {
  final BuildContext context;
  final MyDialogSetting? setting;

  ShirneDialog._(this.context, this.setting);

  /// show a confirm Modal box.
  /// the [message] may be a [Widget] or [String]
  Future<bool?> confirm(
    dynamic message, {
    String? buttonText,
    String title = '',
    Widget? titleWidget,
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
                  .toList(),
            ),
      [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          style:
              setting?.cancelButtonStyle ?? MyDialog.setting.cancelButtonStyle,
          child: Text(
            cancelText ??
                setting?.buttonTextCancel ??
                MyDialog.setting.buttonTextCancel,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          style: setting?.primaryButtonStyle ??
              MyDialog.setting.primaryButtonStyle,
          child: Text(
            buttonText ??
                setting?.buttonTextOK ??
                MyDialog.setting.buttonTextOK,
          ),
        ),
      ],
      title: title,
      titleWidget: titleWidget,
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
    Widget? titleWidget,
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
          style: setting?.primaryButtonStyle ??
              MyDialog.setting.primaryButtonStyle,
          child: Text(buttonText ??
              setting?.buttonTextOK ??
              MyDialog.setting.buttonTextOK),
        ),
      ],
      title: title,
      titleWidget: titleWidget,
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
    Widget? titleWidget,
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    final modalSetting = setting?.modalSetting ?? MyDialog.setting.modalSetting;
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleWidget ?? (title.isEmpty ? null : Text(title)),
          titlePadding: modalSetting?.titlePadding,
          titleTextStyle: modalSetting?.titleTextStyle,
          content: SingleChildScrollView(
            child: body,
          ),
          contentPadding: modalSetting?.contentPadding ??
              const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          contentTextStyle: modalSetting?.contentTextStyle,
          actions: buttons,
          actionsPadding: modalSetting?.actionsPadding ?? EdgeInsets.zero,
          actionsAlignment: modalSetting?.actionsAlignment,
          actionsOverflowDirection: modalSetting?.actionsOverflowDirection,
          actionsOverflowButtonSpacing:
              modalSetting?.actionsOverflowButtonSpacing,
          buttonPadding: modalSetting?.buttonPadding,
          backgroundColor: modalSetting?.backgroundColor,
          elevation: modalSetting?.elevation,
          semanticLabel: modalSetting?.semanticLabel,
          insetPadding: modalSetting?.insetPadding ??
              const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 24.0,
              ),
          clipBehavior: modalSetting?.clipBehavior ?? Clip.none,
          shape: modalSetting?.shape,
          scrollable: modalSetting?.scrollable ?? false,
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
  DialogController loading(
    String message, {
    showProgress = false,
    showOverlay = true,
    double time = 3,
  }) {
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
  void toast(
    String message, {
    int duration = 2,
    Alignment? align,
    Widget? icon,
    IconType iconType = IconType.none,
  }) {
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return ToastWidget(
        message,
        icon: icon ?? MyDialog.getIcon(iconType, setting),
        alignment: align ?? setting?.alignTop ?? MyDialog.setting.alignTop,
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
  EntryController snack(
    String message, {
    Widget? action,
    int duration = 3,
    Alignment? align,
    double width = 0.7,
  }) {
    ValueNotifier<int> progressNotify = ValueNotifier<int>(0);
    EntryController controller = EntryController(context, progressNotify);
    controller.entry = OverlayEntry(builder: (context) {
      return SnackWidget(
        message,
        alignment:
            align ?? setting?.alignBottom ?? MyDialog.setting.alignBottom,
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
