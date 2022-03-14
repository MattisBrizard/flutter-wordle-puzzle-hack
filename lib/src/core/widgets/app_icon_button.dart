import 'package:flutter/material.dart';
import 'package:tap_builder/tap_builder.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.tooltipMesage,
  }) : super(key: key);

  final VoidCallback? onTap;
  final IconData icon;
  final String? tooltipMesage;

  static const double _buttonSize = kMinInteractiveDimension;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMesage,
      child: TapBuilder(
        onTap: onTap,
        builder: (context, state) {
          const animationDuration = Duration(milliseconds: 250);
          final isHover = state == TapState.hover;
          final isPressed = state == TapState.pressed;
          final scale = isPressed ? 0.95 : 1;

          return SizedBox(
            width: _buttonSize,
            height: _buttonSize,
            child: Center(
              child: AnimatedContainer(
                duration: animationDuration,
                width: scale * _buttonSize,
                height: scale * _buttonSize,
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color:
                      (isHover || isPressed) ? Colors.black38 : Colors.black54,
                ),
                child: Center(
                  child: Icon(icon),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
