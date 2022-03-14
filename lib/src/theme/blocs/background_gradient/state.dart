import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class BackgroundGradientState extends Equatable {
  const BackgroundGradientState({
    required this.startAngle,
    required this.endAngle,
    required this.center,
    required this.colors,
    required this.stops,
  });

  factory BackgroundGradientState.random() {
    final rand = math.Random();
    final startAngle = rand.nextDoubleInRange(0, math.pi / 4);
    final endAngle = rand.nextDoubleInRange(math.pi, 2 * math.pi);
    final center = Alignment(
      rand.nextDoubleInRange(-0.75, 0.75),
      rand.nextDoubleInRange(-0.75, 0.75),
    );
    final colorsNumber = rand.nextInt(5) + 2;
    final colors = <Color>[];
    final stops = <double>[];
    for (int i = 0; i < colorsNumber; i++) {
      colors.add(
        Color(
          (rand.nextDouble() * 0xFFFFFF).toInt(),
        ).withOpacity(1),
      );
      stops.add(rand.nextDouble());
    }
    colors.add(colors.first);
    stops
      ..add(1)
      ..sort();

    return BackgroundGradientState(
      startAngle: startAngle,
      endAngle: endAngle,
      center: center,
      colors: colors,
      stops: stops,
    );
  }

  final double startAngle;
  final double endAngle;
  final Alignment center;
  final List<Color> colors;
  final List<double> stops;

  @override
  List<Object?> get props => [
        startAngle,
        endAngle,
        center,
        colors,
        stops,
      ];
}

extension _RandomExtensions on math.Random {
  double nextDoubleInRange([
    double start = 0,
    double end = 1,
  ]) {
    return nextDouble() * (end - start) + start;
  }
}
