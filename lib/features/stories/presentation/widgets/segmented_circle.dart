import 'dart:math';
import 'package:flutter/material.dart';

class SegmentedCircle extends StatelessWidget {
  final int segmentCount;
  final double radius;
  final double strokeWidth;
  final Color color;
  final Widget child;

  const SegmentedCircle({
    Key? key,
    required this.segmentCount,
    required this.child,
    this.radius = 45,
    this.strokeWidth = 3,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SegmentedCirclePainter(
        segmentCount: segmentCount,
        strokeWidth: strokeWidth,
        color: color,
      ),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        padding: EdgeInsets.all(strokeWidth),
        child: Padding(
          padding: segmentCount > 0
              ? const EdgeInsets.all(6)
              : const EdgeInsets.all(0),
          child: ClipOval(child: child),
        ),
      ),
    );
  }
}

class _SegmentedCirclePainter extends CustomPainter {
  final int segmentCount;
  final double strokeWidth;
  final Color color;

  _SegmentedCirclePainter({
    required this.segmentCount,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.width / 2) - strokeWidth / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double segmentAngle = 2 * pi / segmentCount;
    final double gapAngle = segmentAngle * 0.05; // Ajuste conforme necessário
    final double arcAngle = segmentAngle - gapAngle;

    for (int i = 0; i < segmentCount; i++) {
      final double startAngle = i * segmentAngle + gapAngle / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedCirclePainter oldDelegate) {
    return oldDelegate.segmentCount != segmentCount ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}
