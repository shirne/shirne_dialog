import 'dart:math' as math;
import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.origRect,
    required this.actions,
    this.elevation = 3.0,
  });

  final double elevation;
  final Rect origRect;
  final List<Widget> actions;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        color: Colors.transparent,
        borderOnForeground: false,
        elevation: widget.elevation,
        shape: DropdownBorder(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(8),
          constraints: BoxConstraints(minWidth: widget.origRect.width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.actions,
          ),
        ),
      ),
    );
  }
}

class IsosTriangle {
  final double side;
  final double bottom;
  final Radius radius;
  const IsosTriangle({
    required this.side,
    required this.bottom,
    this.radius = const Radius.circular(4.0),
  });

  double get height =>
      math.pow(math.pow(side, 2) + math.pow(bottom / 2, 2), 0.5).toDouble();

  IsosTriangle operator *(double t) {
    return IsosTriangle(
      side: side * t,
      bottom: bottom * t,
      radius: Radius.elliptical(radius.x * t, radius.y * t),
    );
  }
}

class DropdownBorder extends ShapeBorder {
  final Color color;
  final BorderRadius borderRadius;
  final IsosTriangle corner;
  const DropdownBorder({
    this.color = const Color(0xFFffffff),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.corner = const IsosTriangle(side: 10, bottom: 10),
  });
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(dimensions.resolve(textDirection).deflateRect(rect));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()..color = color;
    final height = corner.height;
    final path = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          rect.left,
          rect.top + height,
          rect.right,
          rect.bottom,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      )
      ..addPath(
        Path()
          ..moveTo(-corner.bottom, height)
          ..conicTo(
            -corner.bottom / 2,
            corner.height,
            -corner.bottom / 4,
            height / 2,
            1,
          )
          ..conicTo(0, 0, corner.bottom / 4, height / 2, 1)
          ..conicTo(
            corner.bottom / 2,
            height,
            corner.bottom,
            height,
            1,
          )
          ..close(),
        Offset(rect.width / 2, 0),
      );

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return DropdownBorder(
      color: color,
      corner: corner * t,
      borderRadius: BorderRadius.only(
        topLeft: borderRadius.topLeft * t,
        topRight: borderRadius.topRight * t,
        bottomLeft: borderRadius.bottomLeft * t,
        bottomRight: borderRadius.bottomRight * t,
      ),
    );
  }
}
