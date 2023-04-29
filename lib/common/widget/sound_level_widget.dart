import 'package:flutter/material.dart';
import 'package:guardian_project/service/sound_meter_service.dart';

/// sound level viewer as a [StreamBuilder]
class StreamSoundLevelViewer extends StatelessWidget {
  static const Duration _animationDuration = Duration(milliseconds: 500);

  final Stream<NoiseReading> noiseStream;
  final Stream<bool> noiseLevelDetectorStream;
  final int maxVolume;
  final double Function() getLevelDetectorMeanValue;

  StreamSoundLevelViewer(
      {super.key,
      required this.noiseStream,
      this.maxVolume = 100,
      required this.getLevelDetectorMeanValue,
      required this.noiseLevelDetectorStream});

  @override
  Widget build(BuildContext context) => StreamBuilder<NoiseReading>(
      stream: noiseStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 5,
                  )
                ]),
            width: 200,
            height: 400,
            child: Center(
                child: Text("${_computeRelativeVolume(snapshot.data?.maxDecibel ?? 0).ceil()} dB",
                    style: TextStyle(
                        color:
                            colorGradiantList.elementAt(_computeListIndexFromDbValue(snapshot.data?.maxDecibel ?? 0)),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        shadows: const [
                          Shadow(color: Color.fromARGB(255, 129, 129, 129), blurRadius: 5, offset: Offset(1, 2))
                        ],
                        fontSize: 50))),
          );
        }
        return StreamBuilder(
            stream: noiseLevelDetectorStream,
            builder: ((context, detectionSnapshot) => CustomPaint(
                  foregroundPainter: LevelIndicatorPainter(getLevelDetectorMeanValue(),
                      Theme.of(context).colorScheme.primary, maxVolume.toDouble(), detectionSnapshot.data ?? false),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 5,
                          )
                        ]),
                    width: 200,
                    height: 400,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: colorGradiantList.reversed
                              .map((e) => Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: colorGradiantList.indexOf(e) <=
                                                  _computeListIndexFromDbValue(snapshot.data?.maxDecibel ?? 0)
                                              ? e
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(5)),
                                      width: 200,
                                      height: 40,
                                    ),
                                  )))
                              .toList(),
                        ),
                        Center(
                            child: Text("${_computeRelativeVolume(snapshot.data?.maxDecibel ?? 0).ceil()} dB",
                                style: TextStyle(
                                    color: colorGradiantList
                                        .elementAt(_computeListIndexFromDbValue(snapshot.data?.maxDecibel ?? 0)),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                    shadows: const [
                                      Shadow(
                                          color: Color.fromARGB(255, 129, 129, 129),
                                          blurRadius: 5,
                                          offset: Offset(1, 2))
                                    ],
                                    fontSize: 50)))
                      ],
                    ),
                  ),
                )));
      });

  /// list of colors for the sound level viewer
  final List<Color> colorGradiantList = [
    Colors.green.shade900,
    Colors.green.shade400,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.yellow.shade600,
    Colors.orange.shade400,
    Colors.orange.shade800,
    Colors.red.shade400,
    Colors.red.shade900,
    Colors.redAccent.shade700,
  ];

  /// compute colume according to max decibel
  double _computeRelativeVolume(double value) => (value * 100) / maxVolume;

  /// compute an index between 1 and 10 to select a color among the [colorGradiantList]
  int _computeListIndexFromDbValue(double dBValue) {
    final relativeValue = _computeRelativeVolume(dBValue);
    return relativeValue > 1 ? ((relativeValue / 10) - 1).floor() : 0;
  }
}

/// show a level with a vertically moving bar
class LevelIndicatorPainter extends CustomPainter {
  static const Color goldColor = Color.fromARGB(255, 212, 158, 40);

  final double maximumHeight;
  final double height;
  final Color lineColor;

  final bool isDetecting;

  const LevelIndicatorPainter(this.height, this.lineColor, this.maximumHeight, this.isDetecting);

  @override
  void paint(Canvas canvas, Size size) {
    final fromBottomHeight = size.height - _getRelativeHeight(height, size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = isDetecting ? goldColor : lineColor
      ..strokeWidth = isDetecting ? 8 : 4
      ..strokeCap = StrokeCap.round;

    final textPainter = TextPainter()
      ..text = TextSpan(
          text: "${height.ceilToDouble()} dB",
          children: [
            if (isDetecting)
              const TextSpan(
                  text: " - gap detected",
                  style: TextStyle(color: goldColor, fontStyle: FontStyle.italic, fontSize: 10))
          ],
          style: TextStyle(
              color: isDetecting ? goldColor : lineColor,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 12))
      ..textDirection = TextDirection.ltr;

    Offset startingPoint = Offset(0, fromBottomHeight);
    Offset endingPoint = Offset(size.width, fromBottomHeight);

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    canvas.drawLine(startingPoint, endingPoint, paint);
    textPainter.paint(canvas, endingPoint + const Offset(10, -5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  /// turn the pixel height into the db relative height
  double _getRelativeHeight(double height, Size canvasSize) => (height * canvasSize.height) / maximumHeight;
}
