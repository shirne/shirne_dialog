import 'package:flutter/material.dart';

import 'controller.dart';

class PopupWidget extends StatefulWidget {
  final Widget? child;
  final double? height;
  final double alpha;
  final DialogController? controller;

  const PopupWidget(
      {Key? key, this.child, this.height, this.controller, this.alpha = 0.6})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _aniController;
  double? height = 0;
  double curAlpha = 0;
  Matrix4 transform = Matrix4.translationValues(0, 0, 0);

  bool isShown = false;
  DragStartDetails? dragStart;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController.unbounded(
        vsync: this, duration: Duration(milliseconds: 400));
    _aniController.value = 0;
    _aniController.addListener(_onAnimation);
    if (widget.height != null) height = widget.height;

    widget.controller!.notifier!.addListener(_onController);
    if (height! > 0) {
      startShow();
    }
  }

  @override
  dispose() {
    _aniController.removeListener(_onAnimation);
    _aniController.dispose();

    super.dispose();
  }

  startShow() async {
    if (isShown) return;
    isShown = true;
    setState(() {
      _aniController.value = height!;
      transform = Matrix4.translationValues(0, height!, 0);
    });

    _aniController.animateTo(0, curve: Curves.easeOutQuart);
  }

  void _onController() {
    if (widget.controller!.notifier!.value == 101) {
      print('will close');
      _close();
    }
  }

  void _close() {
    _aniController.animateTo(height!, curve: Curves.easeOutQuart)
      ..whenComplete(() {
        widget.controller!.notifier!.removeListener(_onController);
        widget.controller!.remove();
      });
  }

  void _onAnimation() {
    setState(() {
      curAlpha = (1 - _aniController.value / height!) * widget.alpha;
      transform = Matrix4.translationValues(0, _aniController.value, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (height == null || height! <= 0) {
      height = size.height * 0.8;
      startShow();
    }
    return GestureDetector(
      onTap: () {
        //print('a');
        _close();
      },
      child: Container(
        color: Color.fromRGBO(0, 0, 0, curAlpha),
        height: size.height,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              print('b');
            },
            onHorizontalDragUpdate: (detail) {
              //print(detail);
              if (dragStart == null) return;
              var offset =
                  detail.globalPosition.dy - dragStart!.globalPosition.dy;
              if (offset < 0) offset = 0;
              _aniController.value = offset > height! ? height! : offset;
              _onAnimation();
            },
            onHorizontalDragStart: (detail) {
              //print(detail);
              dragStart = detail;
            },
            onHorizontalDragEnd: (detail) {
              //print([detail.velocity,detail.primaryVelocity]);
              if (_aniController.value > 50) {
                _close();
              } else {
                _aniController.animateTo(0, curve: Curves.easeOutQuart);
              }
              dragStart = null;
            },
            child: Container(
              transform: transform,
              width: size.width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Material(child: widget.child),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        _close();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.cancel),
                      ),
                    ),
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
