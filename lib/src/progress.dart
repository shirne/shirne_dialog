library shirne_dialog;

import 'dart:async';

import 'package:flutter/material.dart';

import 'controller.dart';

/// a progress Widget
class ProgressWidget extends StatefulWidget {
  final ValueNotifier<double>? notifier;
  final bool showProgress;
  final bool showOverlay;
  final String? message;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry padding;
  final double strokeWidth;
  final DialogController? controller;
  final Animation<Color?>? valueColor;
  final Color? color;
  final Color? backgroundColor;

  const ProgressWidget({
    Key? key,
    this.notifier,
    this.showProgress = false,
    this.message,
    this.controller,
    this.showOverlay = true,
    this.decoration,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.strokeWidth = 4,
    this.valueColor,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with SingleTickerProviderStateMixin {
  double progress = 0;
  AnimationController? _aniController;

  @override
  void initState() {
    super.initState();

    if (widget.notifier != null) {
      widget.notifier!.addListener(_onValueChange);

      if (widget.showProgress) {
        _aniController = AnimationController.unbounded(
            vsync: this, duration: const Duration(milliseconds: 400));
        _aniController!.value = progress;
        _aniController!.addListener(_onAnimation);
      }
    }
  }

  @override
  void dispose() {
    if (widget.notifier != null) {
      widget.notifier!.removeListener(_onValueChange);
      if (_aniController != null) {
        _aniController!.removeListener(_onAnimation);
        _aniController!.dispose();
      }
    }
    super.dispose();
  }

  void _onAnimation() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, widget.showOverlay ? 0.4 : 0),
      child: Center(
        child: Container(
          padding: widget.padding,
          decoration: widget.decoration ??
              const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator.adaptive(
                value: widget.showProgress ? _aniController!.value : null,
                backgroundColor: widget.backgroundColor,
                valueColor: widget.valueColor ??
                    AlwaysStoppedAnimation<Color>(
                      widget.color ?? Theme.of(context).primaryColor,
                    ),
                strokeWidth: widget.strokeWidth,
              ),
              const SizedBox(height: 10),
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
        ),
      ),
    );
  }

  void _onValueChange() {
    if (!mounted) return;
    setState(() {
      progress = widget.notifier!.value;
    });
    if (_aniController != null) {
      _aniController!
          .animateTo(progress, curve: Curves.easeOutQuart)
          .whenComplete(() {
        if (progress >= 1) {
          widget.controller!.remove();
        }
      });
    } else {
      if (progress >= 1) {
        Future.delayed(const Duration(milliseconds: 200)).then((v) {
          widget.controller!.remove();
        });
      }
    }
  }
}
