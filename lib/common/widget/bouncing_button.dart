import 'package:flutter/material.dart';
import 'package:guardian_project/theme/theme.dart';

/// creates a bouncing button
class BouncingStateButton extends StatefulWidget {
  final Icon stateOnIcon;
  final Icon stateOffIcon;

  final Gradient? stateOnbuttonGradiantColor;
  final Gradient? stateOffbuttonGradiantColor;
  final String? stateOnButtonLabel;
  final String? stateOffButtonLabel;

  final Size? buttonSize;
  final bool isCircularButton;

  final void Function() onPressed;
  final bool Function() getState;

  const BouncingStateButton({
    super.key,
    required this.stateOnIcon,
    required this.stateOffIcon,
    required this.onPressed,
    required this.getState,
    this.isCircularButton = false,
    this.stateOnButtonLabel,
    this.stateOffButtonLabel,
    this.stateOnbuttonGradiantColor,
    this.stateOffbuttonGradiantColor,
    this.buttonSize,
  });

  @override
  State<BouncingStateButton> createState() => _BouncingStateButtonState();
}

class _BouncingStateButtonState extends State<BouncingStateButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late bool _isButtonPressed;

  BouncingButtonThemeExtension? theme;

  @override
  void initState() {
    _isButtonPressed = widget.getState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.15,
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme ??= Theme.of(context).extension<BouncingButtonThemeExtension>();

    return Center(
      child: GestureDetector(
        onTap: _tap,
        child: AnimatedButton(
          _controller,
          isButtonPressed: _isButtonPressed,
          isCircularButton: widget.isCircularButton,
          gradiant: (_isButtonPressed ? widget.stateOnbuttonGradiantColor : widget.stateOffbuttonGradiantColor) ??
              theme?.colorGradient,
          stateOnIcon: widget.stateOnIcon,
          stateOffIcon: widget.stateOffIcon,
          buttonSize: widget.buttonSize,
        ),
      ),
    );
  }

  /// [onTapDown] callback for the [GestureDetector]
  void _tap() {
    widget.onPressed();

    _controller.animateTo(_controller.upperBound, curve: Curves.fastOutSlowIn).then((value) {
      _controller.reverse();
    });
    _isButtonPressed = widget.getState();
  }
}

/// Scale animated button widget
class AnimatedButton extends AnimatedWidget {
  static const defaultSize = Size(200, 70);

  final Icon stateOnIcon;
  final Icon stateOffIcon;

  final String? label;
  final Gradient? gradiant;

  final Size? buttonSize;
  final bool isCircularButton;
  final bool isButtonPressed;

  final AnimationController _controller;
  const AnimatedButton(
    AnimationController controller, {
    super.key,
    this.isButtonPressed = false,
    this.stateOnIcon = const Icon(Icons.check),
    this.label,
    this.buttonSize,
    this.isCircularButton = false,
    this.gradiant,
    this.stateOffIcon = const Icon(Icons.close),
  })  : _controller = controller,
        super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // waving animation
        Align(
          alignment: Alignment.center,
          child: BoucingAnimation(
            isActivated: isButtonPressed,
            child: _getCircle(),
          ),
        ),
        // actual button
        Align(
            alignment: Alignment.center,
            child: Transform.scale(
              scale: 1 - _controller.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: buttonSize?.height ?? defaultSize.height,
                width: buttonSize?.width ?? defaultSize.width,
                decoration: BoxDecoration(
                    borderRadius: isCircularButton
                        ? BorderRadius.circular((buttonSize?.width ?? defaultSize.width) / 2)
                        : BorderRadius.circular(20.0),
                    border:
                        Border.all(color: gradiant?.colors.first ?? Theme.of(context).colorScheme.primary, width: 6),
                    boxShadow: [
                      BoxShadow(
                        color: (Colors.black).withOpacity(0.8),
                        blurRadius: 20.0,
                        spreadRadius: 10,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                    gradient: gradiant),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (label != null)
                        Text(label!,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: isButtonPressed ? stateOnIcon : stateOffIcon,
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  /// create a [CustomPaint] circle
  Widget _getCircle() => Align(
        alignment: Alignment.center,
        child: CustomPaint(
          size: Size(
            buttonSize?.height ?? defaultSize.height,
            buttonSize?.width ?? defaultSize.width,
          ),
          painter:
              CirclePainter(strokeColor: (gradiant?.colors.first ?? Colors.blue).withOpacity(0.2), strokeWidth: 10),
        ),
      );
}

/// create a bouncing [Container] animation
class BoucingAnimation extends StatefulWidget {
  const BoucingAnimation({super.key, required this.child, this.isActivated = true});

  final bool isActivated;

  final Widget child;

  @override
  State<BoucingAnimation> createState() => _StateBoucingAnimation();
}

class _StateBoucingAnimation extends State<BoucingAnimation> with SingleTickerProviderStateMixin {
  /// max scale = 1 + bouncingRatio
  static const double bouncingRatio = 40 / 100;

  late final AnimationController bouncingAnimationControler;

  @override
  void initState() {
    super.initState();
    bouncingAnimationControler =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 100), upperBound: bouncingRatio);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActivated) {
      bouncingAnimationControler.reset();
      bouncingAnimationControler.stop();
    } else {
      bouncingAnimationControler.repeat(reverse: true, period: const Duration(seconds: 1));
    }
    return AnimatedBuilder(
        animation: bouncingAnimationControler.drive(CurveTween(curve: Curves.fastOutSlowIn)),
        builder: ((context, child) =>
            Transform.scale(scale: 1 + bouncingAnimationControler.value, child: widget.child)));
  }

  @override
  void dispose() {
    bouncingAnimationControler.stop();
    bouncingAnimationControler.dispose();
    super.dispose();
  }
}

/// Draws a circle, placed into a square widget.
class CirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;

  CirclePainter({required this.strokeColor, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = strokeColor
      ..colorFilter = ColorFilter.mode(strokeColor, BlendMode.modulate)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      painter,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
