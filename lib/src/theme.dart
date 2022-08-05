import 'package:flutter/material.dart';

import 'dialog_icons.dart';

/// Provide unified parameter settings for various dialogs
class ShirneDialogTheme extends ThemeExtension<ShirneDialogTheme> {
  /// detault top position for [MyDialog.toast]
  final Alignment alignTop;

  /// default bottom position for [MyDialog.toast]
  final Alignment alignBottom;

  /// success icon for [MyDialog.toast]
  final Widget iconSuccess;

  /// error icon for [MyDialog.toast]
  final Widget iconError;

  /// warning icon for [MyDialog.toast]
  final Widget iconWarning;

  /// info icon for [MyDialog.toast]
  final Widget iconInfo;

  /// help icon for [MyDialog.toast]
  final Widget iconHelp;

  final ButtonStyle? primaryButtonStyle;
  final ButtonStyle? cancelButtonStyle;

  final ModalStyle? modalStyle;
  final ToastStyle? toastStyle;
  final SnackStyle? snackStyle;

  const ShirneDialogTheme({
    this.alignTop = const Alignment(0.0, -0.7),
    this.alignBottom = const Alignment(0.0, 0.7),
    this.iconSuccess = const Icon(
      DialogIcons.checkmarkFill,
      color: Colors.green,
    ),
    this.iconError = const Icon(
      DialogIcons.closeFill,
      color: Colors.red,
    ),
    this.iconWarning = const Icon(
      DialogIcons.warningFill,
      color: Colors.deepOrangeAccent,
    ),
    this.iconInfo = const Icon(
      DialogIcons.informationFill,
      color: Colors.blue,
    ),
    this.iconHelp = const Icon(
      DialogIcons.helpFill,
      color: Colors.blue,
    ),
    this.primaryButtonStyle,
    this.cancelButtonStyle,
    this.modalStyle,
    this.toastStyle,
    this.snackStyle,
  });

  @override
  ThemeExtension<ShirneDialogTheme> copyWith({
    Alignment? alignTop,
    Alignment? alignBottom,
    Icon? iconSuccess,
    Icon? iconError,
    Icon? iconWarning,
    Icon? iconInfo,
    Icon? iconHelp,
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? cancelButtonStyle,
    ModalStyle? modalStyle,
  }) {
    return ShirneDialogTheme(
      alignTop: alignTop ?? this.alignTop,
      alignBottom: alignBottom ?? this.alignBottom,
      iconSuccess: iconSuccess ?? this.iconSuccess,
      iconError: iconError ?? this.iconError,
      iconWarning: iconWarning ?? this.iconWarning,
      iconInfo: iconInfo ?? this.iconInfo,
      iconHelp: iconHelp ?? this.iconHelp,
      primaryButtonStyle: primaryButtonStyle ?? this.primaryButtonStyle,
      cancelButtonStyle: cancelButtonStyle ?? this.cancelButtonStyle,
      modalStyle: modalStyle ?? this.modalStyle,
    );
  }

  @override
  ThemeExtension<ShirneDialogTheme> lerp(
      ThemeExtension<ShirneDialogTheme>? other, double t) {
    return t < 0.5 ? this : other ?? this;
  }
}

class ModalStyle {
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final EdgeInsets contentPadding;
  final TextStyle? contentTextStyle;
  final EdgeInsetsGeometry actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final Color? backgroundColor;
  final double? elevation;
  final String? semanticLabel;
  final EdgeInsets insetPadding;
  final Clip clipBehavior;
  final ShapeBorder? shape;
  final bool scrollable;

  const ModalStyle({
    this.titlePadding,
    this.titleTextStyle,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    ),
    this.clipBehavior = Clip.none,
    this.shape,
    this.scrollable = false,
  });
}

class ToastStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  ToastStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });
}

class SnackStyle {}
