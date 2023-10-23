library shirne_dialog;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// a [SnickBar] like Widget
class SnackWidget extends StatefulWidget {
  const SnackWidget(
    this.message, {
    Key? key,
    this.icon,
    this.description,
    this.action,
    this.maxWidth,
    this.style,
  }) : super(key: key);

  final String message;
  final Widget? icon;
  final String? description;

  /// dismiss time, in millionseconds
  final Widget? action;
  final double? maxWidth;

  final SnackStyle? style;

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
        widget.style?.maxWidth ??
        math.min(700.0, MediaQuery.of(context).size.width * 0.7);
    if (width > 1) {
      return width;
    }
    return width * MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Container(
      decoration: widget.style?.decoration ??
          BoxDecoration(
            color: widget.style?.backgroundColor ?? colorScheme.inverseSurface,
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
      padding: widget.style?.contentPadding ?? const EdgeInsets.all(8),
      constraints: BoxConstraints.loose(
        Size(maxWidth(context), widget.style?.height ?? double.infinity),
      ),
      child: Material(
        color: Colors.transparent,
        child: DefaultTextStyle(
          style: TextStyle(
            color:
                widget.style?.foregroundColor ?? colorScheme.onInverseSurface,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.icon!,
                  ),
                if (widget.description == null)
                  Expanded(
                    child: Text(
                      widget.message,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.message,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description!,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                if (widget.action != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: widget.action!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
