library shirne_dialog;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'controller.dart';

/// a [SnickBar] like Widget
class SnackWidget extends StatefulWidget {
  final String message;
  final int duration;
  final Alignment alignment;
  final Widget? action;
  final ValueNotifier? notifier;
  final DialogController? controller;
  final double maxWidth;

  const SnackWidget(
    this.message, {
    Key? key,
    this.duration = 4,
    this.alignment = const Alignment(0, 0.8),
    this.action,
    this.notifier,
    this.controller,
    this.maxWidth = 0.7,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SnackWidgetState();
}

class _SnackWidgetState extends State<SnackWidget>
    with SingleTickerProviderStateMixin {
  late Alignment alignment;
  double alignY = 1.2;
  double opacity = 1;
  late AnimationController _aniController;

  @override
  void initState() {
    super.initState();

    if (widget.alignment.y <= 0) {
      alignY = -1.2;
    }
    alignment = Alignment(0, alignY);
    _aniController = AnimationController.unbounded(
        vsync: this, duration: const Duration(milliseconds: 300));
    _aniController.value = 0;
    _aniController.addListener(_onAnimation);

    widget.notifier!.addListener(_onStateChange);

    _aniController.animateTo(100);
  }

  @override
  void dispose() {
    _aniController.removeListener(_onAnimation);
    _aniController.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (widget.notifier!.value >= 100) {
      _aniController.animateTo(0).whenComplete(() {
        widget.controller!.remove();
      });
    }
  }

  void _onAnimation() {
    setState(() {
      alignment = Alignment(0,
          alignY + (widget.alignment.y - alignY) * _aniController.value / 100);
      opacity = _aniController.value / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Align(
      alignment: alignment,
      child: FittedBox(
        child: Opacity(
          opacity: opacity,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.8),
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(54, 54, 54, 1),
                  Color.fromRGBO(16, 16, 16, 1),
                  Colors.black
                ],
                stops: [0, 0.6, 1],
                transform: GradientRotation(math.pi * 0.47),
              ),
              shape: BoxShape.rectangle,
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 3, spreadRadius: 2)
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
            height: 45,
            width: width * widget.maxWidth,
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  widget.action ?? const Text('')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
