import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_hack/src/core/widgets/responsive_layout_builder.dart';
import 'package:puzzle_hack/src/entities/tile.dart';
import 'package:puzzle_hack/src/puzzle/bloc/puzzle_bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/tile_theme/bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/tile_theme/state.dart';
import 'package:tap_builder/tap_builder.dart';

class PuzzleTile extends StatelessWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  static const Map<ResponsiveLayoutSize, double> _responsiveTileSizeMap = {
    ResponsiveLayoutSize.small: 70,
    ResponsiveLayoutSize.medium: 90,
    ResponsiveLayoutSize.large: 112,
  };
  static const Map<ResponsiveLayoutSize, double>
      _responsiveTileBorderRadiusMap = {
    ResponsiveLayoutSize.small: 20,
    ResponsiveLayoutSize.medium: 25,
    ResponsiveLayoutSize.large: 30,
  };

  Color tileColorFromTheme(TileThemeState state) {
    switch (tile.positionState.status) {
      case TilePositionStatus.correct:
        return state.letterCorrectPosition;
      case TilePositionStatus.inWord:
        return state.letterInWord;
      case TilePositionStatus.notInWord:
        return state.letterNotInWord;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tile.isWhitespace) {
      return const SizedBox();
    }

    final state = context.select(
      (PuzzleBloc bloc) => bloc.state,
    );

    final puzzleDimension = state.puzzle.getDimension();
    final status = state.puzzleStatus;

    final canPress = status == PuzzleStatus.incomplete;

    return Center(
      child: AnimatedAlign(
        alignment: FractionalOffset(
          (tile.currentPosition.x - 1) / (puzzleDimension - 1),
          (tile.currentPosition.y - 1) / (puzzleDimension - 1),
        ),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        child: ResponsiveLayoutBuilder(
            small: (context, child) => child!,
            medium: (context, child) => child!,
            large: (context, child) => child!,
            child: (layoutSize) {
              final tileSize = _responsiveTileSizeMap[layoutSize]!;
              final tileBorderRadius =
                  _responsiveTileBorderRadiusMap[layoutSize]!;

              return SizedBox.square(
                dimension: tileSize,
                child: TapBuilder(
                  onTap: canPress
                      ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
                      : null,
                  builder: (context, state) {
                    final isHover = state == TapState.hover;
                    final double size = tileSize * (isHover ? 0.95 : 1);
                    final tileTheme = context.watch<TileThemeBloc>().state;
                    final tileColor = tileColorFromTheme(tileTheme);

                    return Center(
                      child: ClipRRect(
                        child: AnimatedContainer(
                          width: size,
                          height: size,
                          clipBehavior: Clip.antiAlias,
                          key: ValueKey(tile.value),
                          duration: const Duration(milliseconds: 350),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              tileBorderRadius,
                            ),
                            border: tile.positionState.isPositionUnauthorized
                                ? Border.all(
                                    color: tileColor,
                                    width: 4,
                                  )
                                : null,
                            color: tile.positionState.isPositionUnauthorized
                                ? tileTheme.letterNotInWord
                                : tileColor,
                          ),
                          child: Center(
                            child: Text(
                              tile.letter.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
