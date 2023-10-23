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
        math.min(700.0, MediaQuery.of(context).size.width - 32);
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
    final fgColor =
        widget.style?.foregroundColor ?? colorScheme.onInverseSurface;
    final borderRadius = widget.style?.borderRadius ?? BorderRadius.circular(4);
    return Material(
      color: Colors.transparent,
      elevation: widget.style?.elevation ?? 4,
      borderRadius: borderRadius,
      child: Container(
        decoration: widget.style?.decoration ??
            BoxDecoration(
              color:
                  widget.style?.backgroundColor ?? colorScheme.inverseSurface,
              gradient: widget.style?.gradient,
              shape: BoxShape.rectangle,
              borderRadius: borderRadius,
            ),
        padding: widget.style?.contentPadding ?? const EdgeInsets.all(8),
        constraints: BoxConstraints.loose(
          Size(maxWidth(context), widget.style?.height ?? double.infinity),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: fgColor,
          ),
          child: IconTheme(
            data: IconThemeData(
              color: fgColor,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (widget.icon != null)
                    if (widget.icon is Icon)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: widget.icon!,
                          ),
                        ),
                      )
                    else
                      widget.icon!,
                  if (widget.description == null)
                    Expanded(
                      child: Text(
                        widget.message,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: fgColor,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: fgColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description!,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: fgColor.withAlpha(
                                (fgColor.alpha * 0.6).toInt(),
                              ),
                            ),
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
      ),
    );
  }
}
