import 'package:flutter/material.dart';

class ChartExampleWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget chart;

  const ChartExampleWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151), // gray-700
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: chart,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280), // gray-500
              fontFamily: 'Roboto',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class BullishEngulfingChart extends StatelessWidget {
  const BullishEngulfingChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: BullishEngulfingPainter(),
    );
  }
}

class BullishEngulfingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF333333);

    // Draw grid lines
    canvas.drawLine(const Offset(0, 0), const Offset(0, 200), paint);
    canvas.drawLine(const Offset(0, 200), const Offset(400, 200), paint);
    
    paint.strokeWidth = 0.5;
    paint.color = const Color(0xFF333333);
    
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF333333);
    
    // Draw dashed horizontal lines
    drawDashedLine(canvas, const Offset(0, 50), const Offset(400, 50), dashPaint);
    drawDashedLine(canvas, const Offset(0, 100), const Offset(400, 100), dashPaint);
    drawDashedLine(canvas, const Offset(0, 150), const Offset(400, 150), dashPaint);

    // Price labels
    final textStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 10,
    );
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    
    textPainter.text = TextSpan(text: "\$150", style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 45));
    
    textPainter.text = TextSpan(text: "\$100", style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 95));
    
    textPainter.text = TextSpan(text: "\$50", style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 145));

    // Draw candles
    drawCandles(canvas);
    
    // Draw pattern indicator
    final pathPaint = Paint()
      ..color = const Color(0xFFFEB019)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    final path = Path();
    path.moveTo(150, 190);
    path.quadraticBezierTo(165, 170, 180, 190);
    canvas.drawPath(path, pathPaint);
    
    textPainter.text = TextSpan(
      text: "Bullish Engulfing",
      style: TextStyle(
        color: const Color(0xFFFEB019),
        fontSize: 10,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(145, 195));
  }
  
  void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 2;
    const dashSpace = 2;
    double distance = (end - start).distance;
    int dashCount = distance ~/ (dashWidth + dashSpace);
    
    for (int i = 0; i < dashCount; i++) {
      double startFraction = i * (dashWidth + dashSpace) / distance;
      double endFraction = (i * (dashWidth + dashSpace) + dashWidth) / distance;
      if (endFraction > 1.0) endFraction = 1.0;
      
      canvas.drawLine(
        Offset.lerp(start, end, startFraction)!,
        Offset.lerp(start, end, endFraction)!,
        paint
      );
    }
  }
  
  void drawCandles(Canvas canvas) {
    // Candles before pattern
    drawCandle(canvas, 30, 80, 15, 60, true); // Red candle
    drawWick(canvas, 38, 75, 38, 80, true);
    drawWick(canvas, 38, 140, 38, 145, true);
    
    drawCandle(canvas, 60, 90, 15, 40, true);
    drawWick(canvas, 68, 70, 68, 90, true);
    drawWick(canvas, 68, 130, 68, 150, true);
    
    drawCandle(canvas, 90, 110, 15, 30, true);
    drawWick(canvas, 98, 100, 98, 110, true);
    drawWick(canvas, 98, 140, 98, 145, true);
    
    drawCandle(canvas, 120, 120, 15, 40, true);
    drawWick(canvas, 128, 110, 128, 120, true);
    drawWick(canvas, 128, 160, 128, 170, true);
    
    // Engulfing pattern
    drawCandle(canvas, 150, 150, 15, 20, true); // Red candle
    drawWick(canvas, 158, 145, 158, 150, true);
    drawWick(canvas, 158, 170, 158, 180, true);
    
    drawCandle(canvas, 180, 120, 20, 60, false); // Green candle
    drawWick(canvas, 190, 110, 190, 120, false);
    drawWick(canvas, 190, 180, 190, 185, false);
    
    // Candles after pattern
    drawCandle(canvas, 215, 110, 15, 50, false);
    drawWick(canvas, 223, 100, 223, 110, false);
    drawWick(canvas, 223, 160, 223, 165, false);
    
    drawCandle(canvas, 245, 90, 15, 40, false);
    drawWick(canvas, 253, 80, 253, 90, false);
    drawWick(canvas, 253, 130, 253, 140, false);
    
    drawCandle(canvas, 275, 70, 15, 50, false);
    drawWick(canvas, 283, 60, 283, 70, false);
    drawWick(canvas, 283, 120, 283, 125, false);
    
    drawCandle(canvas, 305, 50, 15, 30, false);
    drawWick(canvas, 313, 40, 313, 50, false);
    drawWick(canvas, 313, 80, 313, 90, false);
  }
  
  void drawCandle(Canvas canvas, double x, double y, double width, double height, bool isRed) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isRed ? const Color(0xFFFF4560) : const Color(0xFF00E396);
      
    canvas.drawRect(Rect.fromLTWH(x, y, width, height), paint);
  }
  
  void drawWick(Canvas canvas, double x1, double y1, double x2, double y2, bool isRed) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = isRed ? const Color(0xFFFF4560) : const Color(0xFF00E396);
      
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HammerChart extends StatelessWidget {
  const HammerChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: HammerPatternPainter(),
    );
  }
}

class HammerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFF333333);

    // Draw grid lines
    canvas.drawLine(const Offset(0, 0), const Offset(0, 200), paint);
    canvas.drawLine(const Offset(0, 200), const Offset(400, 200), paint);
    
    paint.strokeWidth = 0.5;
    paint.color = const Color(0xFF333333);
    
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF333333);
    
    // Draw dashed horizontal lines
    drawDashedLine(canvas, const Offset(0, 50), const Offset(400, 50), dashPaint);
    drawDashedLine(canvas, const Offset(0, 100), const Offset(400, 100), dashPaint);
    drawDashedLine(canvas, const Offset(0, 150), const Offset(400, 150), dashPaint);

    // Price labels
    final textStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 10,
    );
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    
    textPainter.text = TextSpan(text: "\$150", style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 45));
    
    textPainter.text = TextSpan(text: "\$100", style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 95));
    
    textPainter.text = TextSpan(text: "\$50", style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5, 145));

    // Draw candles
    drawCandlesHammer(canvas);
    
    // Draw pattern indicator - circle around hammer
    final circlePaint = Paint()
      ..color = const Color(0xFFFEB019)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    canvas.drawCircle(const Offset(168, 140), 15, circlePaint);
    
    textPainter.text = TextSpan(
      text: "Hammer",
      style: TextStyle(
        color: const Color(0xFFFEB019),
        fontSize: 10,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(148, 165));
  }
  
  void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 2;
    const dashSpace = 2;
    double distance = (end - start).distance;
    int dashCount = distance ~/ (dashWidth + dashSpace);
    
    for (int i = 0; i < dashCount; i++) {
      double startFraction = i * (dashWidth + dashSpace) / distance;
      double endFraction = (i * (dashWidth + dashSpace) + dashWidth) / distance;
      if (endFraction > 1.0) endFraction = 1.0;
      
      canvas.drawLine(
        Offset.lerp(start, end, startFraction)!,
        Offset.lerp(start, end, endFraction)!,
        paint
      );
    }
  }
  
  void drawCandlesHammer(Canvas canvas) {
    // Candles before pattern
    drawCandle(canvas, 40, 70, 15, 40, false); // Green candle
    drawWick(canvas, 48, 65, 48, 70, false);
    drawWick(canvas, 48, 110, 48, 120, false);
    
    drawCandle(canvas, 70, 90, 15, 30, true);
    drawWick(canvas, 78, 80, 78, 90, true);
    drawWick(canvas, 78, 120, 78, 130, true);
    
    drawCandle(canvas, 100, 110, 15, 20, true);
    drawWick(canvas, 108, 100, 108, 110, true);
    drawWick(canvas, 108, 130, 108, 140, true);
    
    drawCandle(canvas, 130, 130, 15, 30, true);
    drawWick(canvas, 138, 120, 138, 130, true);
    drawWick(canvas, 138, 160, 138, 170, true);
    
    // Hammer pattern
    drawCandle(canvas, 160, 130, 15, 10, false); // Green hammer
    drawWick(canvas, 168, 140, 168, 180, false); // Long lower shadow
    drawWick(canvas, 168, 125, 168, 130, false); // Small upper shadow
    
    // Candles after pattern
    drawCandle(canvas, 190, 120, 15, 30, false);
    drawWick(canvas, 198, 110, 198, 120, false);
    drawWick(canvas, 198, 150, 198, 155, false);
    
    drawCandle(canvas, 220, 100, 15, 40, false);
    drawWick(canvas, 228, 90, 228, 100, false);
    drawWick(canvas, 228, 140, 228, 145, false);
    
    drawCandle(canvas, 250, 80, 15, 35, false);
    drawWick(canvas, 258, 70, 258, 80, false);
    drawWick(canvas, 258, 115, 258, 125, false);
  }
  
  void drawCandle(Canvas canvas, double x, double y, double width, double height, bool isRed) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isRed ? const Color(0xFFFF4560) : const Color(0xFF00E396);
      
    canvas.drawRect(Rect.fromLTWH(x, y, width, height), paint);
  }
  
  void drawWick(Canvas canvas, double x1, double y1, double x2, double y2, bool isRed) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = isRed ? const Color(0xFFFF4560) : const Color(0xFF00E396);
      
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}