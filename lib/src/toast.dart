import 'dart:async';

import 'package:flutter/material.dart';

class ToastWidget extends StatefulWidget {
  final String message;
  final int duration;
  final Icon? icon;
  final Alignment alignment;

  const ToastWidget(this.message, {Key? key, this.alignment = Alignment.center, this.duration = 3, this.icon})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  static ValueNotifier<int> instanceCount = ValueNotifier(0);
  int instanceIndex = 0;

  late Alignment alignment;
  bool isMarginTop = true;
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    instanceCount.value++;
    instanceCount.addListener(onCreateInstance);

    //print(['init aligment',widget.alignment.y]);
    if (widget.alignment != null && widget.alignment.y > 0) {
      alignment = Alignment.bottomCenter;
      isMarginTop = false;
    } else {
      alignment = Alignment.topCenter;
    }
    Future.delayed(Duration(milliseconds: 10), () {
      if (!mounted) return;
      setState(() {
        alignment = widget.alignment;
      });
    });

    Future.delayed(Duration(milliseconds: widget.duration * 1000 - 300), () {
      if (!mounted) return;
      setState(() {
        opacity = 0;
      });
    });
  }

  @override
  void dispose() {
    instanceCount.removeListener(onCreateInstance);
    //instanceCount.value -- ;
    super.dispose();
  }

  onCreateInstance() {
    if (!mounted) return;
    //使用异步,防止触发时在initState中执行
    Future.delayed(Duration(milliseconds: 10), () {
      if (!mounted) return;
      setState(() {
        instanceIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const aDuration = Duration(milliseconds: 300);

    return AnimatedAlign(
      duration: aDuration,
      curve: Curves.easeOutQuart,
      alignment: alignment,
      child: FittedBox(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: aDuration,
          child: AnimatedContainer(
            duration: aDuration,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.only(
                top: isMarginTop ? instanceIndex * 60.0 : 0,
                bottom: isMarginTop ? 0 : instanceIndex * 60.0),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Material(
              color: Colors.transparent,
              child: widget.icon == null ? Text(
                widget.message,
                style: TextStyle(color: Colors.white),
              ) : Row(
                children: [
                  widget.icon!,
                  SizedBox(width: 15,),
                  Text(
                    widget.message,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
