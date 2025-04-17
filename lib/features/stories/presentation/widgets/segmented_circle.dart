import 'dart:math';
import 'package:chatapp/core/theme/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SegmentedCircle extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (segmentCount == 1) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: strokeWidth,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          width: 58,
          height: 58,
          padding: EdgeInsets.all(strokeWidth),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ClipOval(child: child),
          ),
        ),
      );
    }

    return CustomPaint(
      painter: _SegmentedCirclePainter(
        segmentCount: segmentCount,
        strokeWidth: strokeWidth,
        color: color,
      ),
      child: Container(
        width: 58,
        height: 58,
        padding: EdgeInsets.all(strokeWidth),
        decoration: segmentCount > 0
            //  only show border if there are no stories
            ? null
            : BoxDecoration(
                border: Border.all(
                  color: isDarkMode(ref, context)
                      ? Color(0xFF4B9289)
                      : Color(0xFF363F3B),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
        child: Padding(
          padding: const EdgeInsets.all(6),
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
