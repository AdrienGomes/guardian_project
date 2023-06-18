import 'package:flutter/material.dart';
import 'package:guardian_project/common/widget/theme/theme.dart';
import 'dart:math' as math show sin, pi, sqrt;

/// creates a bouncing button
class BouncingStateButton extends StatefulWidget {
  final Icon stateOnIcon;
  final Icon stateOffIcon;

  final Gradient? stateOnbuttonGradiantColor;
  final Gradient? stateOffbuttonGradiantColor;
  final String? stateOnButtonLabel;
  final String? stateOffButtonLabel;

  final Size? buttonSize;

  final void Function() onPressed;
  final bool Function() getState;

  const BouncingStateButton({
    super.key,
    required this.stateOnIcon,
    required this.stateOffIcon,
    required this.onPressed,
    required this.getState,
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

  StateButtonThemeExtension? theme;

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
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme ??= Theme.of(context).extension<StateButtonThemeExtension>();

    _isButtonPressed = widget.getState();

    return Center(
      child: GestureDetector(
        onTap: _tap,
        child: AnimatedButton(
          _controller,
          isButtonPressed: _isButtonPressed,
          label: _isButtonPressed ? widget.stateOnButtonLabel : widget.stateOffButtonLabel,
          gradient: (_isButtonPressed ? widget.stateOnbuttonGradiantColor : widget.stateOffbuttonGradiantColor) ??
              theme?.colorGradient,
          stateOnIcon: widget.stateOnIcon,
          stateOnIconColor: theme?.stateOnColor,
          stateOffIconColor: theme?.stateOffColor,
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
  static const _bouncingAnimationDuration = Duration(milliseconds: 300);

  final Icon stateOnIcon;
  final Icon stateOffIcon;

  final Color? stateOnIconColor;
  final Color? stateOffIconColor;

  final String? label;
  final Gradient? gradient;

  final Size? buttonSize;
  final bool isButtonPressed;

  final AnimationController _controller;
  const AnimatedButton(AnimationController controller,
      {super.key,
      this.isButtonPressed = false,
      this.stateOnIcon = const Icon(Icons.check),
      this.stateOnIconColor,
      this.label,
      this.buttonSize,
      this.gradient,
      this.stateOffIcon = const Icon(Icons.close),
      this.stateOffIconColor})
      : _controller = controller,
        super(listenable: controller);

  @override
  Widget build(BuildContext context) => RipplesAnimation(
        animationIsOff: !isButtonPressed,
        size: buttonSize?.width ?? defaultSize.width,
        colorGradient: RadialGradient(colors: gradient?.colors ?? [Theme.of(context).colorScheme.primary]),
        child: Transform.scale(
          scale: 1 - _controller.value,
          child: AnimatedContainer(
            duration: _bouncingAnimationDuration,
            height: buttonSize?.height ?? defaultSize.height,
            width: buttonSize?.width ?? defaultSize.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((buttonSize?.width ?? defaultSize.width) / 2),
                border: Border.all(color: gradient?.colors.first ?? Theme.of(context).colorScheme.primary, width: 8),
                boxShadow: [
                  BoxShadow(
                      color: gradient?.colors.first ?? Theme.of(context).colorScheme.primary,
                      spreadRadius: 4,
                      blurRadius: 3)
                ],
                gradient: gradient),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (label != null)
                    Text(label!,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: gradient?.colors.last,
                        )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: isButtonPressed ? _buildStateOnIcon() : _buildStateOffIcon(),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Icon _buildStateOnIcon() {
    if (stateOnIcon.color == null && stateOnIconColor != null) {
      return Icon(
        stateOnIcon.icon,
        size: stateOnIcon.size,
        color: stateOnIconColor,
        shadows: [
          Shadow(
            color: stateOnIconColor!.withOpacity(0.5),
            blurRadius: 20,
          )
        ],
      );
    }

    return stateOnIcon;
  }

  Icon _buildStateOffIcon() {
    if (stateOffIcon.color == null && stateOffIconColor != null) {
      return Icon(
        stateOffIcon.icon,
        size: stateOffIcon.size,
        color: stateOffIconColor,
        shadows: [
          Shadow(
            color: stateOffIconColor!.withOpacity(0.5),
            blurRadius: 20,
          )
        ],
      );
    }

    return stateOffIcon;
  }
}

/// Creates a circle ripple animation around a widget
class RipplesAnimation extends StatefulWidget {
  final double size;
  final RadialGradient colorGradient;
  final bool animationIsOff;
  final Widget child;

  const RipplesAnimation({
    Key? key,
    required this.size,
    required this.colorGradient,
    required this.child,
    required this.animationIsOff,
  }) : super(key: key);

  @override
  State<RipplesAnimation> createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;

  /// ripples animation duration
  static const _ripplesAnimationDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _ripplesAnimationDuration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedButton() => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: widget.colorGradient,
            ),
            child: ScaleTransition(
                scale: Tween(begin: 0.97, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: CurveWave(),
                  ),
                ),
                child: widget.child),
          ),
        ),
      );
  Widget _staticButton() => Center(
        child: widget.child,
      );

  @override
  Widget build(BuildContext context) => Center(
        child: widget.animationIsOff
            ? _staticButton()
            : CustomPaint(
                painter: CirclePainter(
                  _controller,
                  color: widget.colorGradient.colors.first,
                ),
                child: _animatedButton(),
              ),
      );
}

/// Draws a circle, placed into a square widget.
class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color canvasColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 2.5);
    final Paint paint = Paint()..color = canvasColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
