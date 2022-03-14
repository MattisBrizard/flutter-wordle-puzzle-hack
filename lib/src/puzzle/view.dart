import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:puzzle_hack/src/core/blur_fade_route_transitions.dart';
import 'package:puzzle_hack/src/core/widgets/app_icon_button.dart';
import 'package:puzzle_hack/src/core/widgets/responsive_layout_builder.dart';
import 'package:puzzle_hack/src/l10n/l10n.dart';
import 'package:puzzle_hack/src/puzzle/bloc/puzzle_bloc.dart';
import 'package:puzzle_hack/src/puzzle/tile.dart';
import 'package:puzzle_hack/src/puzzle/widgets/background_gradient.dart';
import 'package:puzzle_hack/src/puzzle/widgets/game_won_view.dart';
import 'package:puzzle_hack/src/puzzle/widgets/how_to_play_view.dart';
import 'package:puzzle_hack/src/puzzle/widgets/settings_view.dart';
import 'package:puzzle_hack/src/theme/blocs/background_gradient/bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/locale.dart';

class PuzzleView extends StatelessWidget {
  const PuzzleView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundGradient(),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: _PuzzleHeader.height,
                      ),
                      child: const _PuzzleBoard(),
                    ),
                  ),
                ),
              );
            },
          ),
          const _PuzzleHeader(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: _PuzzleScore(),
          ),
        ],
      ),
    );
  }
}

class _PuzzleBoard extends StatelessWidget {
  const _PuzzleBoard({
    Key? key,
  }) : super(key: key);

  static const Map<ResponsiveLayoutSize, double> _responsiveBoardSizeMap = {
    ResponsiveLayoutSize.small: 375,
    ResponsiveLayoutSize.medium: 475,
    ResponsiveLayoutSize.large: 600,
  };

  @override
  Widget build(BuildContext context) {
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (state.puzzleStatus == PuzzleStatus.complete) {
          Navigator.of(context).push(
            BlurFadeTransitionPageRoute<void>(
              builder: (context) => const GameWonView(),
            ),
          );
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (context, child) => child!,
        medium: (context, child) => child!,
        large: (context, child) => child!,
        child: (layoutSize) {
          return SizedBox.square(
            dimension: _responsiveBoardSizeMap[layoutSize],
            child: Stack(
              children: [
                ...puzzle.tiles.map(
                  (e) => PuzzleTile(
                    key: Key('tile_${e.value}'),
                    tile: e,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({
    Key? key,
  }) : super(key: key);

  static double height = 100;
  static const Map<ResponsiveLayoutSize, double>
      _horizontalPaddingResponsiveMap = {
    ResponsiveLayoutSize.small: 10,
    ResponsiveLayoutSize.medium: 50,
    ResponsiveLayoutSize.large: 75,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => child!,
        medium: (context, child) => child!,
        large: (context, child) => child!,
        child: (layoutSize) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _horizontalPaddingResponsiveMap[layoutSize]!,
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const ShapeDecoration(
                    color: Colors.black38,
                    shape: StadiumBorder(),
                  ),
                  child: const _FlutterWordleLogo(),
                ),
                const Spacer(),
                const _ResetPuzzleButton(),
                const Gap(10),
                const _HowToPlayButton(),
                const Gap(10),
                const _PuzzleSettingsButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FlutterWordleLogo extends StatelessWidget {
  const _FlutterWordleLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () =>
          context.read<BackgroundGradientBloc>().updateGradient(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcATop,
            ),
            child: FlutterLogo(size: 45),
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sliding',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                'Wordle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PuzzleSettingsButton extends StatelessWidget {
  const _PuzzleSettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppIconButton(
      tooltipMesage: l10n.show_settings,
      onTap: () {
        Navigator.of(context).push(
          BlurFadeTransitionPageRoute<void>(
            builder: (context) => const SettingsView(),
          ),
        );
      },
      icon: Icons.settings,
    );
  }
}

class _HowToPlayButton extends StatelessWidget {
  const _HowToPlayButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppIconButton(
      tooltipMesage: l10n.show_how_to_play,
      onTap: () {
        Navigator.of(context).push(
          BlurFadeTransitionPageRoute<void>(
            builder: (context) => const HowToPlayView(),
          ),
        );
      },
      icon: Icons.info_outline,
    );
  }
}

class _ResetPuzzleButton extends StatelessWidget {
  const _ResetPuzzleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppIconButton(
      tooltipMesage: l10n.reset_puzzle,
      onTap: () {
        context.read<BackgroundGradientBloc>().updateGradient();
        context.read<PuzzleBloc>().add(
              PuzzleReset(
                localeIdentifier: context.read<LocaleBloc>().state.languageCode,
              ),
            );
      },
      icon: Icons.shuffle,
    );
  }
}

class _PuzzleScore extends StatelessWidget {
  const _PuzzleScore({
    Key? key,
  }) : super(key: key);

  static double height = 75;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        decoration: const ShapeDecoration(
          color: Colors.black38,
          shape: StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _NumberOfMoves(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: VerticalDivider(
                color: Colors.white,
              ),
            ),
            _NumberOfCorrectTiles(),
          ],
        ),
      ),
    );
  }
}

class _NumberOfMoves extends StatelessWidget {
  const _NumberOfMoves({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final numberOfMoves = context.select(
      (PuzzleBloc bloc) => bloc.state.numberOfMoves,
    );

    return Text(
      l10n.number_of_moves(numberOfMoves),
      style: textTheme.titleLarge,
    );
  }
}

class _NumberOfCorrectTiles extends StatelessWidget {
  const _NumberOfCorrectTiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final numberOfCorrectTiles = context.select(
      (PuzzleBloc bloc) => bloc.state.numberOfCorrectTiles,
    );

    return Text(
      l10n.number_of_correct_tiles(numberOfCorrectTiles),
      style: textTheme.titleLarge,
    );
  }
}
