import 'dart:ui';

import 'package:flutter/material.dart';

class BlurFadeTransitionPageRoute<T> extends PageRouteBuilder<T> {
  BlurFadeTransitionPageRoute({
    required this.builder,
  }) : super(
          opaque: false,
          fullscreenDialog: true,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: animation.value * 15,
                sigmaY: animation.value * 15,
              ),
              child: FadeTransition(
                opacity: animation,
                child: ColoredBox(
                  color: Colors.black54,
                  child: child,
                ),
              ),
            );
          },
        );

  final WidgetBuilder builder;
}
