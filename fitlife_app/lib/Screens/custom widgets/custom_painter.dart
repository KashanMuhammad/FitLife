import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArcProgressPainter extends CustomPainter {
  final double progress;

  ArcProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final radius = min(size.width, size.height) / 2 - strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    final backgroundPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final foregroundPaint = Paint()
      ..color = Color(0xFF00B712)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}