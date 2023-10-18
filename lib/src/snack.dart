library shirne_dialog;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// a [SnickBar] like Widget
class SnackWidget extends StatefulWidget {
  final String message;

  /// dismiss time, in millionseconds
  final Widget? action;
  final double? maxWidth;

  final SnackStyle? style;

  const SnackWidget(
    this.message, {
    Key? key,
    this.action,
    this.maxWidth,
    this.style,
  }) : super(key: key);

  @override
  State<SnackWidget> createState() => _SnackWidgetState();
}

class _SnackWidgetState extends State<SnackWidget>
    with SingleTickerProviderStateMixin {
  late Alignment alignment;
  double alignY = 1.2;
  double opacity = 1;

  double maxWidth(BuildContext context) {
    final width = widget.maxWidth ??
        math.min(700.0, MediaQuery.of(context).size.width * 0.7);
    if (width > 1) {
      return width;
    }
    return width * MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.style?.decoration ??
          BoxDecoration(
            color: widget.style?.backgroundColor ??
                const Color.fromRGBO(0, 0, 0, 0.8),
            gradient: widget.style?.gradient ??
                const LinearGradient(
                  colors: [
                    Color.fromRGBO(54, 54, 54, 1),
                    Color.fromRGBO(16, 16, 16, 1),
                    Colors.black,
                  ],
                  stops: [0, 0.6, 1],
                  transform: GradientRotation(math.pi * 0.47),
                ),
            shape: BoxShape.rectangle,
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 3, spreadRadius: 2),
            ],
            borderRadius:
                widget.style?.borderRadius ?? BorderRadius.circular(5),
          ),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
      height: widget.style?.height ?? 45,
      width: maxWidth(context),
      child: Material(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.message,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.style?.foregroundColor ?? Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (widget.action != null) widget.action!,
          ],
        ),
      ),
    );
  }
}
