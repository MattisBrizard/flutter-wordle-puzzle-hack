import 'package:flutter/material.dart';
import 'package:tap_builder/tap_builder.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.label,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;

  static const double _buttonWidth = 170;
  static const double _buttonHeight = 50;

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: onTap,
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        const animationDuration = Duration(milliseconds: 250);
        final isHover = state == TapState.hover;
        final isPressed = state == TapState.pressed;

        final scale = isPressed ? 0.95 : 1;

        return SizedBox(
          width: _buttonWidth,
          height: _buttonHeight,
          child: Center(
            child: AnimatedContainer(
              duration: animationDuration,
              width: scale * _buttonWidth,
              height: scale * _buttonHeight,
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: isHover || isPressed ? Colors.white : Colors.white12,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  style: textTheme.bodyLarge!.copyWith(
                    color: isHover || isPressed ? Colors.black : Colors.white,
                    fontSize: textTheme.bodyLarge!.fontSize! * scale,
                  ),
                  child: Text(label),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
