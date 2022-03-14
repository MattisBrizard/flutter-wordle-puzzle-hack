import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:puzzle_hack/src/core/widgets/app_button.dart';
import 'package:puzzle_hack/src/l10n/l10n.dart';
import 'package:puzzle_hack/src/puzzle/bloc/puzzle_bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/background_gradient/bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/locale.dart';

class GameWonView extends StatefulWidget {
  const GameWonView({
    Key? key,
  }) : super(key: key);

  @override
  State<GameWonView> createState() => _GameWonViewState();
}

class _GameWonViewState extends State<GameWonView> {
  late final Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        context.read<BackgroundGradientBloc>().updateGradient();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final numberOfMoves = context.select(
      (PuzzleBloc bloc) => bloc.state.numberOfMoves,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.congrats,
            style: textTheme.headline3,
          ),
          const Gap(15),
          Text(
            l10n.you_won(numberOfMoves),
            style: textTheme.titleLarge,
          ),
          const Gap(50),
          const _RestartButton(),
        ],
      )),
    );
  }
}

class _RestartButton extends StatelessWidget {
  const _RestartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        PuzzleReset(
          localeIdentifier: context.read<LocaleBloc>().state.languageCode,
        );
        Navigator.of(context).pop();
      },
      label: 'Restart',
    );
  }
}
