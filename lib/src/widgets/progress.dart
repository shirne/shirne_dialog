library shirne_dialog;

import 'package:flutter/material.dart';

import '../theme.dart';

/// a progress Widget
class ProgressWidget extends StatefulWidget {
  final bool showProgress;

  final String? message;

  final LoadingStyle? style;

  final Widget Function(BuildContext, double)? builder;
  final void Function(AnimationController)? onListen;
  final VoidCallback? onDispose;

  const ProgressWidget({
    super.key,
    this.showProgress = false,
    this.message,
    this.onListen,
    this.onDispose,
    this.builder,
    this.style,
  }) : assert(
          !showProgress || (showProgress && onListen != null),
          'Must provide a Listener when showProgress',
        );

  @override
  State<StatefulWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with SingleTickerProviderStateMixin {
  double progress = 0;

  late final controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    widget.onListen?.call(controller);

    controller.addListener(_onAnimate);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onAnimate() {
    setState(() {
      progress = controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.builder ?? widget.style?.builder)?.call(context, progress) ??
        Container(
          padding: widget.style?.padding,
          decoration: widget.style?.decoration ??
              const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator.adaptive(
                value: widget.showProgress ? progress : null,
                backgroundColor: widget.style?.backgroundColor,
                valueColor: widget.style?.valueColor ??
                    AlwaysStoppedAnimation<Color>(
                      widget.style?.color ?? Theme.of(context).primaryColor,
                    ),
                strokeWidth: widget.style?.strokeWidth ?? 4,
              ),
              if (widget.message != null) const SizedBox(height: 10),
              if (widget.message != null)
                Text(
                  widget.message!,
                  style: const TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        );
  }
}
