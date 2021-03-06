import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_hack/src/entities/tile.dart';
import 'package:puzzle_hack/src/puzzle/bloc/puzzle_bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/background_gradient/bloc.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BackgroundGradientBloc>().state;

    return BlocListener<PuzzleBloc, PuzzleState>(
      listenWhen: (previous, current) {
        List<List<Tile>> words(List<Tile> tiles) {
          if (tiles.isEmpty) return [];
          final dimension = current.puzzle.getDimension();
          return [
            for (int i = 0; i < dimension; i++)
              if (i != dimension - 1)
                tiles.sublist(i * dimension, (i + 1) * dimension)
              else
                tiles.sublist(i * dimension, (i + 1) * dimension - 1),
          ];
        }

        final previousWords = words(previous.puzzle.tiles.toList());
        final currentWords = words(current.puzzle.tiles.toList());

        final previousCorrectWordsNumber = previousWords
            .where(
              (element) => element.every(
                (element) =>
                    element.isInCorrectPosition && !element.isWhitespace,
              ),
            )
            .length;

        final currentCorrectWordsNumber = currentWords
            .where(
              (element) => element.every(
                (element) =>
                    element.isInCorrectPosition && !element.isWhitespace,
              ),
            )
            .length;
        return previousCorrectWordsNumber < currentCorrectWordsNumber;
      },
      listener: (context, state) {
        // Update gradient when a new Word is correct.
        context.read<BackgroundGradientBloc>().updateGradient();
      },
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 80,
          sigmaY: 80,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            gradient: SweepGradient(
              startAngle: state.startAngle,
              endAngle: state.endAngle,
              center: state.center,
              colors: state.colors,
              stops: state.stops,
            ),
          ),
        ),
      ),
    );
  }
}
