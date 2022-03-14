import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class TileThemeState extends Equatable {
  const TileThemeState({
    required this.letterCorrectPosition,
    required this.letterInWord,
    required this.letterNotInWord,
  });

  final Color letterInWord;
  final Color letterNotInWord;
  final Color letterCorrectPosition;

  @override
  List<Object?> get props => [
        letterInWord,
        letterNotInWord,
        letterCorrectPosition,
      ];
}

class ClassicThemeState extends TileThemeState {
  const ClassicThemeState()
      : super(
          letterCorrectPosition: const Color(0xFF548D4E),
          letterInWord: const Color(0xFFB49F3B),
          letterNotInWord: const Color(0x66000000),
        );
}

class ColorBlindThemeState extends TileThemeState {
  const ColorBlindThemeState()
      : super(
          letterCorrectPosition: const Color(0xFFF57839),
          letterInWord: const Color(0xFF85C0F9),
          letterNotInWord: const Color(0x66000000),
        );
}
