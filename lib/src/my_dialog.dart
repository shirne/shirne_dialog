library shirne_dialog;

import 'dart:async';

import 'package:combined_animation/combined_animation.dart';
import 'package:flutter/material.dart';

import 'widgets/dropdown.dart';
import 'localizations.dart';
import 'controller.dart';
import 'widgets/image_preview.dart';
import 'widgets/progress.dart';
import 'widgets/popup.dart';
import 'widgets/snack.dart';
import 'theme.dart';
import 'widgets/toast.dart';

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

  /// Default ShirneDialogTheme
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
  static ShirneDialog of([BuildContext? context, bool useRoot = true]) {
    if (context != null) {
      return ShirneDialog._(context, useRoot);
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
    FutureOr<bool> Function(String)? onConfirm,
    String title = '',
    String? buttonText,
    Widget? titleWidget,
    String? cancelText,
    ModalStyle? style,
    bool? barrierDismissible,
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
      style: style,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.confirm]
  static Future<bool?> confirm(
    dynamic message, {
    String? buttonText,
    TextStyle? buttonStyle,
    FutureOr<bool> Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    String? cancelText,
    TextStyle? cancelStyle,
    ModalStyle? style,
    bool withClose = false,
    Widget? closeIcon,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    _checkInstance();
    return _instance!.confirm(
      message,
      buttonText: buttonText,
      buttonStyle: buttonStyle,
      onConfirm: onConfirm,
      title: title,
      titleWidget: titleWidget,
      cancelText: cancelText,
      cancelStyle: cancelStyle,
      style: style,
      withClose: withClose,
      closeIcon: closeIcon,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.alert]
  static Future<bool?> alert(
    dynamic message, {
    String? buttonText,
    TextStyle? buttonStyle,
    bool Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    ModalStyle? style,
    bool withClose = false,
    Widget? closeIcon,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    _checkInstance();
    return _instance!.alert(
      message,
      buttonText: buttonText,
      buttonStyle: buttonStyle,
      onConfirm: onConfirm,
      title: title,
      titleWidget: titleWidget,
      style: style,
      withClose: withClose,
      closeIcon: closeIcon,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.alertModal]
  static Future<T?> alertModal<T>(
    Widget body,
    List<Widget> actions, {
    String title = '',
    Widget? titleWidget,
    bool withClose = false,
    Widget? closeIcon,
    bool? barrierDismissible,
    Color? barrierColor,
    ModalStyle? style,
  }) {
    _checkInstance();
    return _instance!.alertModal<T>(
      body,
      actions,
      title: title,
      titleWidget: titleWidget,
      style: style,
      withClose: withClose,
      closeIcon: closeIcon,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.modal]
  static Future<T?> modal<T>(
    Widget modal, {
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    _checkInstance();
    return _instance!.modal<T>(
      modal,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// A wrapper of [ShirneDialog.imagePreview]
  static Future<T?> imagePreview<T>(
    List<String> images, {
    String? currentImage,
    bool? barrierDismissible,
    Color? barrierColor,
    Rect? startRect,
  }) {
    _checkInstance();
    return _instance!.imagePreview<T>(
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
    double? height,
    double? maxHeight,
    BoxDecoration? decoration,
    double? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? barrierColor,
    Color? backgroundColor,
    bool? isDismissible,
    bool? isScrollControlled,
    double? elevation,

    /// Build a Widget at top of the popup that
    /// seems to responeding drag to close the popup
    WidgetBuilder? dragHandlerBuilder,
    bool? showClose,
    Widget? closeButton,
    String? closeSemanticsLabel,
  }) {
    _checkInstance();
    return _instance!.popup<T>(
      body,
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
      dragHandlerBuilder: dragHandlerBuilder,
      showClose: showClose,
      closeButton: closeButton,
      closeSemanticsLabel: closeSemanticsLabel,
    );
  }

  /// A wrapper of [ShirneDialog.loading]
  static ProgressController loading(
    String? message, {
    bool? showProgress,
    Duration? duration,

    /// Custom builder to cover style.builder
    Widget Function(BuildContext, double)? builder,
    LoadingStyle? style,
  }) {
    _checkInstance();
    return _instance!.loading(
      message,
      showProgress: showProgress,
      duration: duration,
      builder: builder,
      style: style,
    );
  }

  static EntryController overlayModal(
    Widget child, {
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  }) {
    _checkInstance();
    return _instance!.overlayModal(
      child,
      animate: animate,
      leaveAnimate: leaveAnimate,
    );
  }

  static EntryController dropdown(
    List<Widget> actions, {
    Rect? origRect,
    BoxConstraints? constraints,
    BuildContext? context,
    CrossAxisAlignment? actionAlignment,
    HitTestBehavior? backdropBehavior,
    Color? backdropColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Set<DropDownLayoutPosition>? position,
    IsosTriangle? triangle,
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  }) {
    _checkInstance();
    return _instance!.dropdown(
      actions,
      origRect: origRect,
      constraints: constraints,
      context: context,
      actionAlignment: actionAlignment,
      backdropBehavior: backdropBehavior,
      backdropColor: backdropColor,
      padding: padding,
      position: position,
      triangle: triangle,
      animate: animate,
      leaveAnimate: leaveAnimate,
    );
  }

  /// A wrapper of [ShirneDialog.toast]
  static void toast(
    String message, {
    Duration? duration,
    Widget? icon,
    IconType? iconType,
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
    dynamic message, {
    VoidCallback? onTap,
    Widget? action,
    Duration? duration,
    Alignment? align,
    double? width,
    SnackStyle? style,
  }) {
    _checkInstance();
    return _instance!.snack(
      message,
      onTap: onTap,
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
  final bool useRootNavigator;

  ShirneDialogTheme get theme =>
      Theme.of(context).extension<ShirneDialogTheme>() ??
      const ShirneDialogTheme();

  ShirneDialogLocalizations get local => ShirneDialogLocalizations.of(context);

  OverlayState get overlay =>
      MyDialog.navigatorKey.currentState?.overlay ?? Overlay.of(context);

  ShirneDialog._(this.context, [this.useRootNavigator = true]);

  /// Popup a dialog with input to collect user input
  Future<String?> prompt({
    String? defaultValue,
    Widget? label,

    /// A custom input builder for content.
    /// Must use controller for your TextField.
    Widget Function(BuildContext, TextEditingController)? builder,

    /// called when confirm button tapped.
    /// if not validate pass the input ,return false pls.
    FutureOr<bool> Function(String)? onConfirm,
    String title = '',
    ActionButtonBuilder? button,
    String? buttonText,
    TextStyle? buttonStyle,
    Widget? titleWidget,
    ActionButtonBuilder? cancelButton,
    String? cancelText,
    TextStyle? cancelStyle,
    ModalStyle? style,
    bool? barrierDismissible,
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
      button: button,
      buttonText: buttonText,
      buttonStyle: buttonStyle,
      title: title,
      titleWidget: titleWidget,
      cancelButton: cancelButton,
      cancelText: cancelText,
      cancelStyle: cancelStyle,
      style: style,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
    return result == true ? controller.text : null;
  }

  List<String> _splitMessage(dynamic message) {
    if (message is List) {
      return message.map<String>((e) => '$e').toList();
    }
    return '$message'.split('\n');
  }

  /// show a confirm Modal box.
  /// the [message] may be a [Widget] or [String]
  Future<bool?> confirm(
    dynamic message, {
    CrossAxisAlignment? textBodyAlignment,
    ActionButtonBuilder? button,
    String? buttonText,
    TextStyle? buttonStyle,

    /// A confirm button callback.
    /// Modal will hold on only when return false.
    FutureOr<bool> Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    ActionButtonBuilder? cancelButton,
    String? cancelText,
    TextStyle? cancelStyle,
    ModalStyle? style,
    bool withClose = false,
    Widget? closeIcon,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    final localStyle = style ?? theme.modalStyle;
    return alertModal<bool>(
      message is Widget
          ? message
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: textBodyAlignment ??
                  localStyle?.textBodyAlignment ??
                  CrossAxisAlignment.center,
              children: _splitMessage(message).map<Widget>(Text.new).toList(),
            ),
      [
        (cancelButton ?? localStyle?.defaultBuilder ?? defaultButtonBuilder)
            .call(
          () {
            Navigator.of(context, rootNavigator: useRootNavigator).pop(false);
          },
          localStyle?.defaultButtonStyle ??
              theme.defaultButtonStyle ??
              MyDialog.theme.defaultButtonStyle,
          Padding(
            padding: style?.buttonPadding ?? EdgeInsets.zero,
            child: Text(
              cancelText ?? local.buttonCancel,
              style: cancelStyle,
            ),
          ),
        ),
        (button ?? localStyle?.primaryBuilder ?? primaryButtonBuilder).call(
          () async {
            final navigator =
                Navigator.of(context, rootNavigator: useRootNavigator);
            final result = await onConfirm?.call();
            if (result == false) return;
            navigator.pop(true);
          },
          localStyle?.primaryButtonStyle ??
              theme.primaryButtonStyle ??
              MyDialog.theme.primaryButtonStyle,
          Padding(
            padding: localStyle?.buttonPadding ?? EdgeInsets.zero,
            child: Text(
              buttonText ?? local.buttonConfirm,
              style: buttonStyle,
            ),
          ),
        ),
      ],
      title: title,
      titleWidget: titleWidget,
      style: style,
      withClose: withClose,
      closeIcon: closeIcon,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// show a small modal with one button which text is `buttonText`.
  /// the `message` may be a [Widget] or [String]
  Future<bool?> alert(
    dynamic message, {
    CrossAxisAlignment? textBodyAlignment,
    ActionButtonBuilder? button,
    String? buttonText,
    TextStyle? buttonStyle,
    bool Function()? onConfirm,
    String title = '',
    Widget? titleWidget,
    ModalStyle? style,
    bool withClose = false,
    Widget? closeIcon,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    final localStyle = style ?? theme.alertStyle ?? theme.modalStyle;
    return alertModal<bool>(
      message is Widget
          ? message
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: textBodyAlignment ??
                  localStyle?.textBodyAlignment ??
                  CrossAxisAlignment.center,
              children: _splitMessage(message).map<Widget>(Text.new).toList(),
            ),
      [
        (button ?? localStyle?.primaryBuilder ?? primaryButtonBuilder).call(
          () async {
            final result = onConfirm?.call();
            if (result == false) return;
            Navigator.of(context, rootNavigator: useRootNavigator).pop(true);
          },
          localStyle?.primaryButtonStyle ??
              theme.primaryButtonStyle ??
              MyDialog.theme.primaryButtonStyle,
          Padding(
            padding: localStyle?.buttonPadding ?? EdgeInsets.zero,
            child: Text(
              buttonText ?? ShirneDialogLocalizations.of(context).buttonConfirm,
              style: buttonStyle,
            ),
          ),
        ),
      ],
      title: title,
      titleWidget: titleWidget,
      style: style ?? theme.alertStyle ?? MyDialog.theme.alertStyle,
      withClose: withClose,
      closeIcon: closeIcon,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// show an [AlertDialog] witch content is `body`,with any `buttons`.
  /// The modal title will be hidden if `title` isEmpty
  Future<T?> alertModal<T>(
    Widget body,
    List<Widget> actions, {
    String title = '',
    Widget? titleWidget,
    ModalStyle? style,
    bool withClose = false,
    Widget? closeIcon,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    final mStyle = style ?? theme.modalStyle ?? MyDialog.theme.modalStyle;
    if (mStyle?.scrollable ?? false) {
      body = SingleChildScrollView(
        padding: mStyle?.contentPadding,
        child: body,
      );
    } else if (mStyle?.contentPadding != null) {
      body = Padding(
        padding: mStyle!.contentPadding,
        child: body,
      );
    }
    if (withClose) {
      body = Stack(
        children: [
          body,
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(null);
              },
              // TODO 匹配窗口圆角
              // borderRadius: const BorderRadius.only(
              //   topRight: Radius.circular(28),
              // ),
              child: closeIcon ??
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close),
                  ),
            ),
          ),
        ],
      );
    }
    body = DefaultTextStyle(
      style: mStyle?.contentTextStyle ??
          Theme.of(context).textTheme.titleMedium ??
          const TextStyle(),
      child: body,
    );

    return modal<T>(
      SimpleDialog(
        title: titleWidget ?? (title.isEmpty ? null : Text(title)),
        titlePadding: mStyle?.titlePadding ??
            const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
        titleTextStyle: mStyle?.titleTextStyle,
        contentPadding: EdgeInsets.zero,
        backgroundColor: mStyle?.backgroundColor,
        elevation: mStyle?.elevation,
        semanticLabel: mStyle?.semanticLabel,
        insetPadding: mStyle?.insetPadding ?? defaultInsetPadding,
        clipBehavior: mStyle?.clipBehavior ?? Clip.none,
        shape: mStyle?.shape,
        children: [
          body,
          if (actions.isNotEmpty)
            Padding(
              padding: mStyle?.actionsPadding ?? EdgeInsets.zero,
              child: IntrinsicHeight(
                child: CustomPaint(
                  foregroundPainter: ButtonSeparatorPainter(
                    mStyle?.actionsSeparator,
                    actions.length,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment:
                        mStyle?.actionsAlignment ?? MainAxisAlignment.end,
                    children: (mStyle?.expandedAction ?? false)
                        ? [
                            for (final e in actions) Expanded(child: e),
                          ]
                        : actions,
                  ),
                ),
              ),
            ),
        ],
      ),
      barrierDismissible: barrierDismissible ?? false,
      barrierColor: barrierColor ?? Colors.black54,
    );
  }

  /// show a custom modal.
  Future<T?> modal<T>(
    Widget modal, {
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      barrierColor: barrierColor ?? Colors.black54,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return modal;
      },
    );
  }

  Future<T?> imagePreview<T>(
    List<String> images, {
    String? currentImage,
    bool? barrierDismissible,
    Color? barrierColor,
    Rect? startRect,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
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
    double? height,
    double? maxHeight,
    BoxDecoration? decoration,
    double? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? barrierColor,
    Color? backgroundColor,
    bool? isDismissible,
    bool? isScrollControlled,
    double? elevation,

    /// Build a Widget at top of the popup that
    /// seems to responeding drag to close the popup
    WidgetBuilder? dragHandlerBuilder,
    bool? showClose,
    PopupStyle? style,
    Widget? closeButton,
    String? closeSemanticsLabel,
  }) {
    final popupStyle = style ??
        theme.popupStyle ??
        MyDialog.theme.popupStyle ??
        const PopupStyle();
    return showModalBottomSheet<T>(
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? popupStyle.barrierColor,
      elevation: elevation ?? popupStyle.elevation,
      isDismissible: isDismissible ?? popupStyle.isDismissible ?? true,
      isScrollControlled: isScrollControlled ?? false,
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          height: height,
          maxHeight: maxHeight,
          style: popupStyle.copyWith(
            decoration: decoration,
            borderRadius: borderRadius,
            margin: margin,
            padding: padding,
            backgroundColor: backgroundColor,
            showClose: showClose,
          ),
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
    String? message, {
    bool? showProgress,
    Duration? duration,

    /// Custom builder to cover style.builder
    Widget Function(BuildContext, double)? builder,
    LoadingStyle? style,
  }) {
    final loadingStyle = (style ?? theme.loadingStyle)?.centerIfNoAlign();
    final sp = showProgress ?? false;
    late final ProgressController controller;
    controller = ProgressController(
      ProgressWidget(
        showProgress: showProgress ?? false,
        message: message,
        builder: builder,
        style: loadingStyle,
        // ignore: unnecessary_lambdas
        onListen: (ac) {
          controller.bind(ac);
        },
        // ignore: unnecessary_lambdas
        onDispose: () {
          controller.unbind();
        },
      ),
      overlay: overlay,
      showOverlay: loadingStyle?.showOverlay,
      overlayColor: loadingStyle?.overlayColor,
      animate: loadingStyle?.enterAnimation,
      leaveAnimate: loadingStyle?.leaveAnimation,
    )..open();

    final closeDuration = duration ?? (sp ? null : const Duration(seconds: 3));
    if (closeDuration != null && closeDuration.inMilliseconds > 0) {
      Future.delayed(closeDuration).then((v) {
        if (!controller.isClose) {
          controller.complete();
        }
      });
    }
    return controller;
  }

  /// Popup a Widget in Overlay.
  /// You can handle the EnterAnimation in initialize and postFrameCallback
  /// and handle the ExitAnimation with listening controller
  /// when controller.value==1, and call controller.remove after animation
  EntryController overlayModal(
    Widget child, {
    WrapperBuilder? wrapperBuilder,
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  }) {
    final controller = EntryController(
      child,
      overlay: overlay,
      wrapperBuilder: wrapperBuilder,
      animate: animate,
      leaveAnimate: leaveAnimate,
    )..open();

    return controller;
  }

  EntryController dropdown(
    List<Widget> actions, {
    Rect? origRect,
    BoxConstraints? constraints,
    BuildContext? context,
    CrossAxisAlignment? actionAlignment,
    double? elevation,
    HitTestBehavior? backdropBehavior,
    Color? backdropColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Set<DropDownLayoutPosition>? position,
    IsosTriangle? triangle,
    AnimationConfig? animate,
    AnimationConfig? leaveAnimate,
  }) {
    assert(
      origRect != null || context != null,
      "MyDialog.dropdown Must provide an origRect Or a Context",
    );
    if (origRect == null) {
      final renderObj = context?.findRenderObject() as RenderBox?;

      if (renderObj == null) {
        throw Exception("context must have a RenderBox");
      }

      origRect =
          renderObj.localToGlobal(Offset.zero) & renderObj.paintBounds.size;
    }
    final globalOffset = this.context.findRenderObject() as RenderBox?;
    if (globalOffset != null) {
      final offset = globalOffset.localToGlobal(Offset.zero);
      if (offset != Offset.zero) {
        origRect = origRect.translate(-offset.dx, -offset.dy);
      }
    }
    late final EntryController controller;
    controller = overlayModal(
      DropdownWidget(
        actions: actions,
        origRect: origRect,
        constraints: constraints,
        padding: padding ?? const EdgeInsets.all(8),
        margin: margin ?? const EdgeInsets.all(8),
        position: position,
        triangle: triangle ?? const IsosTriangle(side: 10, bottom: 10),
        actionAlignment: actionAlignment,
        elevation: elevation ?? 4.0,
        animate: AnimationConfig.fadeIn,
        leaveAnimate: AnimationConfig.fadeOut,
      ),
      wrapperBuilder: (context, child) => GestureDetector(
        onTap: controller.close,
        behavior: backdropBehavior ?? HitTestBehavior.translucent,
        child: Container(
          color: backdropColor,
          child: child,
        ),
      ),
      animate: AnimationConfig.fadeIn,
      leaveAnimate: AnimationConfig.fadeOut,
    );
    return controller;
  }

  /// show a light weight tip with in `message`, an `icon` is optional.
  void toast(
    String message, {
    Duration? duration,
    Widget? icon,
    IconType? iconType,
    ToastStyle? style,
  }) {
    final toastStyle = (style ?? theme.toastStyle)?.bottomIfNoAlign();
    final controller = overlayModal(
      ToastWidget(
        message,
        icon: icon ?? MyDialog.getIcon(iconType ?? IconType.none),
        style: toastStyle,
      ),
      animate: toastStyle?.enterAnimation,
      leaveAnimate: toastStyle?.leaveAnimation,
    );

    Future.delayed(duration ?? const Duration(seconds: 2)).then((value) {
      controller.close();
    });
  }

  /// show a [SnackBar] like Widget but use a diy Widget with [OverlayEntry]
  EntryController snack(
    /// [SnackWidget] Or [String]
    dynamic message, {
    VoidCallback? onTap,
    Widget? action,
    Duration? duration,
    Alignment? align,
    double? width,
    SnackStyle? style,
  }) {
    assert(message is Widget || message is String);
    final snackStyle = (style ?? theme.snackStyle)?.bottomIfNoAlign(
      isAnimate: true,
    );
    final child = message is Widget
        ? message
        : SnackWidget(
            message,
            action: action,
            maxWidth: width,
            style: snackStyle,
          );
    EntryController? controller;
    controller = overlayModal(
      onTap == null
          ? child
          : GestureDetector(
              onTap: () {
                onTap.call();
                if (!controller!.isClosed) {
                  controller.close();
                }
              },
              child: child,
            ),
      animate: snackStyle?.enterAnimation ??
          AnimationConfig.fadeIn.copyWith(
            startAlign: const Alignment(0, -1.2),
            endAlign: const Alignment(0, -0.75),
          ),
      leaveAnimate: snackStyle?.leaveAnimation,
    );

    Future.delayed(duration ?? const Duration(seconds: 3)).then((value) {
      if (!controller!.isClosed) {
        controller.close();
      }
    });

    return controller;
  }
}
