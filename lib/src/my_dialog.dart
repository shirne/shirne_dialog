library shirne_dialog;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shirne_dialog/src/localizations.dart';

import 'controller.dart';
import 'image_preview.dart';
import 'popup.dart';
import 'progress.dart';
import 'snack.dart';
import 'theme.dart';
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
/// ** Must use navigatorKey Or call initialize with a context in Navigator **
class MyDialog {
  static GlobalKey<NavigatorState>? _navigatorKey;
  static set navigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  /// return a globalKey use for Navigator
  static GlobalKey<NavigatorState> get navigatorKey {
    _navigatorKey ??= GlobalKey<NavigatorState>();
    return _navigatorKey!;
  }

  /// 默认主题
  static const defaultTheme = ShirneDialogTheme();

  /// get [ShirneDialogTheme] from context or return default
  static ShirneDialogTheme get theme {
    return _instance?.theme ?? defaultTheme;
  }

  static ShirneDialog? _instance;

  /// initialize a MyDialog instance
  static void initialize([BuildContext? context]) {
    if (context == null) {
      assert(_navigatorKey != null, "");
      assert(_navigatorKey!.currentContext != null, "");
    }
    _instance = ShirneDialog._(context ?? _navigatorKey!.currentContext!);
  }

  /// return a [ShirneDialog] instance or construct new instance with [BuildContext]
  static ShirneDialog of([BuildContext? context]) {
    if (context != null) {
      return ShirneDialog._(context);
    } else if (_instance == null) {
      if (_navigatorKey != null && _navigatorKey!.currentContext != null) {
        initialize();
      } else {
        throw ArgumentError.notNull('context');
      }
    }

    return _instance!;
  }

  /// transform a [String] to [Alignment] that use for [toast]
  static Alignment getAlignment(String align) {
    switch (align.toLowerCase()) {
      case "top":
      case "topcenter":
        return theme.alignTop;
      case "center":
        return Alignment.center;
      default:
        return theme.alignBottom;
    }
  }

  /// transform [IconType] to [Icon]
  static Widget? getIcon(IconType iconType) {
    switch (iconType) {
      case IconType.error:
        return theme.iconError;
      case IconType.success:
        return theme.iconSuccess;
      case IconType.warning:
        return theme.iconWarning;
      case IconType.info:
        return theme.iconInfo;
      case IconType.help:
        return theme.iconHelp;
      default:
        return null;
    }
  }

  static void _checkInstance() {
    _instance ??= of();
  }

  /// A wrapper of [ShirneDialog.prompt]
  static Future<String?> prompt({
    String? defaultValue,
    Widget? label,
    Widget Function(BuildContext, TextEditingController)? builder,
    bool Function(String)? onConfirm,
    String title = '',
    String? buttonText,
    Widget? titleWidget,
    String? cancelText,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    _checkInstance();
    return _instance!.prompt(
      defaultValue: defaultValue,
      label: label,
      builder: builder,
      onConfirm: onConfirm,
      buttonText: buttonText,
      title: title,
      titleWidget: titleWidget,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.confirm]
  static Future<bool?> confirm(
    dynamic message, {
    String? buttonText,
    bool Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    String? cancelText,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    _checkInstance();
    return _instance!.confirm(
      message,
      buttonText: buttonText,
      onConfirm: onConfirm,
      title: title,
      titleWidget: titleWidget,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.alert]
  static Future<bool?> alert(
    message, {
    String? buttonText,
    bool Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.alert(
      message,
      buttonText: buttonText,
      onConfirm: onConfirm,
      title: title,
      titleWidget: titleWidget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.alertModal]
  static Future<T?> alertModal<T>(
    Widget body,
    List<Widget> buttons, {
    String title = '',
    Widget? titleWidget,
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.alertModal<T>(
      body,
      buttons,
      title: title,
      titleWidget: titleWidget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.modal]
  static Future<T?> modal<T>(
    Widget modal, {
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    _checkInstance();
    return _instance!.modal<T>(
      modal,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.imagePreview]
  static Future<dynamic> imagePreview(
    List<String> images, {
    String? currentImage,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    Rect? startRect,
  }) {
    _checkInstance();
    return _instance!.imagePreview(
      images,
      currentImage: currentImage,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      startRect: startRect,
    );
  }

  /// A wrapper of [ShirneDialog.popup]
  static Future<T?> popup<T>(
    Widget body, {
    barrierDismissible = false,
    double? height,
    double? maxHeight,
    BoxDecoration? decoration,
    double? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? barrierColor,
    Color? backgroundColor,
    bool isDismissible = true,
    bool isScrollControlled = false,
    double? elevation,
    bool showClose = true,
    Widget? closeButton,
  }) {
    _checkInstance();
    return _instance!.popup<T>(
      body,
      barrierDismissible: barrierDismissible,
      height: height,
      maxHeight: maxHeight,
      decoration: decoration,
      borderRadius: borderRadius,
      margin: margin,
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

  /// A wrapper of [ShirneDialog.loading]
  static DialogController loading(
    String message, {
    showProgress = false,
    showOverlay = true,
    int time = 3000,
  }) {
    _checkInstance();
    return _instance!.loading(
      message,
      showProgress: showProgress,
      showOverlay: showOverlay,
      time: time,
    );
  }

  /// A wrapper of [ShirneDialog.toast]
  static void toast(
    String message, {
    int? duration,
    Widget? icon,
    IconType iconType = IconType.none,
    ToastStyle? style,
  }) {
    _checkInstance();
    return _instance!.toast(
      message,
      duration: duration,
      icon: icon,
      iconType: iconType,
      style: style,
    );
  }

  /// A wrapper of [ShirneDialog.snack]
  static EntryController snack(
    String message, {
    Widget? action,
    int? duration,
    Alignment? align,
    double? width,
    SnackStyle? style,
  }) {
    _checkInstance();
    return _instance!.snack(
      message,
      action: action,
      duration: duration,
      align: align,
      width: width,
      style: style,
    );
  }
}

/// Dialog instance for all method
class ShirneDialog {
  final BuildContext context;

  ShirneDialogTheme? get theme =>
      Theme.of(context).extension<ShirneDialogTheme>();

  ShirneDialogLocalizations get local => ShirneDialogLocalizations.of(context);

  ShirneDialog._(this.context);

  /// Popup a dialog with input to collect user input
  Future<String?> prompt({
    String? defaultValue,
    Widget? label,

    /// A custom input builder for content.
    /// Must use controller for your TextField.
    Widget Function(BuildContext, TextEditingController)? builder,

    /// called when confirm button tapped.
    /// if not validate pass the input ,return false pls.
    bool Function(String)? onConfirm,
    String title = '',
    String? buttonText,
    Widget? titleWidget,
    String? cancelText,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) async {
    final controller = TextEditingController(text: defaultValue);
    final result = await confirm(
      builder?.call(context, controller) ??
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (label != null) Center(child: label),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ],
            ),
          ),
      onConfirm: () {
        return onConfirm?.call(controller.text) ?? true;
      },
      buttonText: buttonText,
      title: title,
      titleWidget: titleWidget,
      cancelText: cancelText,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
    return result == true ? controller.text : null;
  }

  /// show a confirm Modal box.
  /// the [message] may be a [Widget] or [String]
  Future<bool?> confirm(
    dynamic message, {
    String? buttonText,

    /// A confirm button callback.
    /// Modal will hold on only when return false.
    bool Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    String? cancelText,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return alertModal<bool>(
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
          style: theme?.cancelButtonStyle ?? MyDialog.theme.cancelButtonStyle,
          child: Text(
            cancelText ?? local.buttonCancel,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = onConfirm?.call();
            if (result == false) return;
            Navigator.pop(context, true);
          },
          style: theme?.primaryButtonStyle ?? MyDialog.theme.primaryButtonStyle,
          child: Text(
            buttonText ?? local.buttonConfirm,
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
    bool Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
  }) {
    return alertModal<bool>(
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
          onPressed: () async {
            final result = onConfirm?.call();
            if (result == false) return;
            Navigator.pop(context, true);
          },
          style: MyDialog.theme.primaryButtonStyle,
          child: Text(buttonText ??
              ShirneDialogLocalizations.of(context).buttonConfirm),
        ),
      ],
      title: title,
      titleWidget: titleWidget,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// show an [AlertDialog] witch content is `body`,with any `buttons`.
  /// The modal title will be hidden if `title` isEmpty
  Future<T?> alertModal<T>(
    Widget body,
    List<Widget> buttons, {
    String title = '',
    Widget? titleWidget,
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    final style = MyDialog.theme.modalStyle;
    return modal<T>(AlertDialog(
      title: titleWidget ?? (title.isEmpty ? null : Text(title)),
      titlePadding: style?.titlePadding,
      titleTextStyle: style?.titleTextStyle,
      content: SingleChildScrollView(
        child: body,
      ),
      contentPadding: style?.contentPadding ??
          const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      contentTextStyle: style?.contentTextStyle,
      actions: buttons,
      actionsPadding: style?.actionsPadding ?? EdgeInsets.zero,
      actionsAlignment: style?.actionsAlignment,
      actionsOverflowDirection: style?.actionsOverflowDirection,
      actionsOverflowButtonSpacing: style?.actionsOverflowButtonSpacing,
      buttonPadding: style?.buttonPadding,
      backgroundColor: style?.backgroundColor,
      elevation: style?.elevation,
      semanticLabel: style?.semanticLabel,
      insetPadding: style?.insetPadding ??
          const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 24.0,
          ),
      clipBehavior: style?.clipBehavior ?? Clip.none,
      shape: style?.shape,
      scrollable: style?.scrollable ?? false,
    ));
  }

  /// show a custom modal.
  Future<T?> modal<T>(
    Widget modal, {
    bool barrierDismissible = false,
    Color? barrierColor = Colors.black54,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return modal;
      },
    );
  }

  Future<T?> imagePreview<T>(
    List<String> images, {
    String? currentImage,
    bool barrierDismissible = true,
    Color? barrierColor,
    Rect? startRect,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return ImagePreviewWidget(
          imageUrls: images,
          startRect: startRect,
          backgroundColor: barrierColor,
          currentImage: currentImage,
        );
      },
    );
  }

  /// show a modal popup with `body` witch width will fill the screen
  Future<T?> popup<T>(
    Widget body, {
    barrierDismissible = false,
    double? height,
    double? maxHeight,
    BoxDecoration? decoration,
    double? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? barrierColor,
    Color? backgroundColor,
    bool isDismissible = true,
    bool isScrollControlled = false,
    double? elevation,
    bool showClose = true,
    Widget? closeButton,
    String? closeSemanticsLabel,
  }) {
    return showModalBottomSheet<T>(
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      elevation: elevation,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          height: height,
          maxHeight: maxHeight,
          decoration: decoration,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          margin: margin,
          padding: padding,
          showClose: showClose,
          closeButton: closeButton,
          closeSemanticsLabel: closeSemanticsLabel ?? local.closeSemantics,
          child: body,
        );
      },
    );
  }

  /// show a loading progress within an [OverlayEntry].
  /// keep in `time` seconds or manual control it's status by pass 0 to `time`
  ProgressController loading(
    String message, {
    showProgress = false,
    showOverlay = true,
    int? time,
  }) {
    ProgressController controller = ProgressController(
      context,
      ValueNotifier<double>(0),
    );
    controller.entry = OverlayEntry(builder: (context) {
      return ProgressWidget(
        showProgress: showProgress,
        showOverlay: showOverlay,
        message: message,
        controller: controller,
      );
    });

    controller.open();

    if (time != null && time > 0) {
      Future.delayed(Duration(milliseconds: time)).then((v) {
        controller.close();
      });
    }
    return controller;
  }

  /// show a light weight tip with in `message`, an `icon` is optional.
  void toast(
    String message, {
    int? duration,
    Widget? icon,
    IconType iconType = IconType.none,
    ToastStyle? style,
  }) {
    final overlay =
        Overlay.of(context) ?? MyDialog.navigatorKey.currentState?.overlay;
    assert(overlay != null, 'toast shuld call with a Scaffold context');
    final d = duration ?? 2000;
    OverlayEntry entry = OverlayEntry(builder: (context) {
      return ToastWidget(
        message,
        icon: icon ?? MyDialog.getIcon(iconType),
        duration: d,
        style: style ?? theme?.toastStyle,
      );
    });

    overlay!.insert(entry);
    Future.delayed(Duration(milliseconds: d)).then((value) {
      entry.remove();
    });
  }

  /// Popup a Widget in Overlay.
  /// When [isEnterControlled], [align] would be ignore.
  /// You can handle the EnterAnimation in initialize and postFrameCallback
  /// and handle the ExitAnimation with listening controller
  /// when controller.value==1, and call controller.remove after animation
  EntryController overlayModal(
    Widget child, {
    Alignment? align,
    bool isEnterControlled = false,
  }) {
    EntryController controller =
        EntryController(context, ValueNotifier<bool>(false));
    controller.entry = OverlayEntry(builder: (context) {
      return isEnterControlled
          ? child
          : Align(
              alignment: align ?? Alignment.center,
              child: child,
            );
    });

    controller.open();

    return controller;
  }

  /// show a [SnackBar] like Widget but use a diy Widget with [OverlayEntry]
  EntryController snack(
    String message, {
    Widget? action,
    int? duration,
    Alignment? align,
    double? width,
    SnackStyle? style,
  }) {
    final d = duration ?? 3000;
    EntryController controller =
        EntryController(context, ValueNotifier<bool>(false));
    controller.entry = OverlayEntry(builder: (context) {
      return SnackWidget(
        message,
        controller: controller,
        alignment: align ?? MyDialog.theme.alignBottom,
        action: action,
        duration: d,
        maxWidth: width,
        style: style ?? theme?.snackStyle,
      );
    });

    controller.open();
    Future.delayed(Duration(milliseconds: d)).then((value) {
      controller.close();
    });

    return controller;
  }
}
