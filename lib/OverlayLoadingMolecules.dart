import 'package:flutter/material.dart';

//
// 全面表示のローディング
//
class OverlayLoadingMolecules extends StatelessWidget {
  OverlayLoadingMolecules({required this.visible, required this.width});

  //表示状態
  bool visible = false;
  double width = 100;
  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            width: width,
            decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
              ],
            ),
          )
        : Container();
  }
}

class OverlayCorrect extends StatelessWidget {
  OverlayCorrect({required this.visible, required this.size});

  //表示状態
  bool visible = false;
  Size size;
  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            width: size.width,
            decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomPaint(
                  painter: CirclePainter(),
                )
              ],
            ),
          )
        : Container();
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 円（外線）
    Paint line = new Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 4, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
