import 'dart:async';

import 'package:flutter/material.dart';

import 'controller.dart';

class ProgressWidget extends StatefulWidget {
  final ValueNotifier<int>? notifier;
  final bool showProgress;
  final bool showOverlay;
  final String? message;
  final DialogController? controller;

  const ProgressWidget(
      {Key? key, this.notifier, this.showProgress = false, this.message, this.controller, this.showOverlay = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> with SingleTickerProviderStateMixin {
  int progress = 0;
  AnimationController? _aniController;

  @override
  void initState() {
    super.initState();


    if (widget.notifier != null) {
      widget.notifier!.addListener(_onValueChange);

      if(widget.showProgress){
        _aniController = AnimationController.unbounded(
            vsync: this, duration: Duration(milliseconds: 400));
        _aniController!.value = progress/100.0;
        _aniController!.addListener(_onAnimation);
      }
    }
  }

  @override
  void dispose() {
    if (widget.notifier != null ) {
      widget.notifier!.removeListener(_onValueChange);
      if(_aniController != null){
        _aniController!.removeListener(_onAnimation);
        _aniController!.dispose();
      }
    }
    super.dispose();
  }

  void _onAnimation() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, widget.showOverlay ? 0.4 : 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              value: widget.showProgress ? _aniController!.value : null,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              widget.message!,
              style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  void _onValueChange() {
    if (!mounted) return;
    setState(() {
      progress = widget.notifier!.value;
    });
    if(_aniController != null) {
      _aniController!.animateTo(progress / 100.0, curve: Curves.easeOutQuart)
        ..whenComplete(() {
          if (progress >= 100) {
            widget.controller!.remove();
          }
        });
    }else{
      if (progress >= 100) {
      Future.delayed(Duration(milliseconds: 200)).then((v){
          widget.controller!.remove();
      });
      }
    }
  }
}
