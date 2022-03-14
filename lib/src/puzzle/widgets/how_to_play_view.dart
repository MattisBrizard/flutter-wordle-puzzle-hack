import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:puzzle_hack/src/l10n/l10n.dart';
import 'package:puzzle_hack/src/theme/blocs/tile_theme/bloc.dart';

class HowToPlayView extends StatelessWidget {
  const HowToPlayView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.how_to_play,
                style: textTheme.headline5,
              ),
              const Gap(30),
              const _GameplayDescription(),
              const Gap(15),
              const _AllWordsScrabbleValidDescription(),
              const Gap(15),
              const Divider(),
              const Gap(15),
              Text(
                l10n.examples,
                style: textTheme.headline5,
              ),
              const Gap(30),
              const _LetterInCorrectDescription(),
              const Gap(30),
              const _LetterInWordDescription(),
              const Gap(30),
              const _LetterNotInWordDescription(),
              const Gap(30),
              const _LetterUnauthorizedPositionDescription(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameplayDescription extends StatelessWidget {
  const _GameplayDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Text(l10n.gameplay_description);
  }
}

class _AllWordsScrabbleValidDescription extends StatelessWidget {
  const _AllWordsScrabbleValidDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Text(l10n.scrabble_valid_description);
  }
}

class _LetterInWordDescription extends StatelessWidget {
  const _LetterInWordDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileTheme = context.watch<TileThemeBloc>().state;
    final l10n = context.l10n;
    final word = l10n.word_example;
    final splittedWord = word.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < splittedWord.length; i++) ...[
              _LetterTile(
                letter: splittedWord[i],
                color:
                    i == 0 ? tileTheme.letterInWord : tileTheme.letterNotInWord,
              ),
              const Gap(8),
            ]
          ],
        ),
        const Gap(10),
        Text(l10n.letter_in_word_description(splittedWord.first.toUpperCase())),
      ],
    );
  }
}

class _LetterInCorrectDescription extends StatelessWidget {
  const _LetterInCorrectDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileTheme = context.watch<TileThemeBloc>().state;
    final l10n = context.l10n;
    final word = l10n.word_example;
    final splittedWord = word.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < splittedWord.length; i++) ...[
              _LetterTile(
                letter: splittedWord[i],
                color: i == 0
                    ? tileTheme.letterCorrectPosition
                    : tileTheme.letterNotInWord,
              ),
              const Gap(8),
            ]
          ],
        ),
        const Gap(10),
        Text(
          l10n.letter_correct_position_description(
            splittedWord.first.toUpperCase(),
          ),
        ),
      ],
    );
  }
}

class _LetterNotInWordDescription extends StatelessWidget {
  const _LetterNotInWordDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileTheme = context.watch<TileThemeBloc>().state;
    final l10n = context.l10n;
    final word = l10n.word_example;
    final splittedWord = word.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < splittedWord.length; i++) ...[
              _LetterTile(
                  letter: splittedWord[i], color: tileTheme.letterNotInWord),
              const Gap(8),
            ]
          ],
        ),
        const Gap(10),
        Text(l10n.letters_not_in_word_description),
      ],
    );
  }
}

class _LetterUnauthorizedPositionDescription extends StatelessWidget {
  const _LetterUnauthorizedPositionDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileTheme = context.watch<TileThemeBloc>().state;
    final l10n = context.l10n;
    final word = l10n.word_example;
    final splittedWord = word.split('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < splittedWord.length; i++) ...[
              _LetterTile(
                letter: splittedWord[i],
                color: tileTheme.letterNotInWord,
                borderColor: () {
                  switch (i) {
                    case 0:
                      return tileTheme.letterCorrectPosition;
                    case 2:
                      return tileTheme.letterInWord;
                    default:
                      return null;
                  }
                }(),
              ),
              const Gap(8),
            ]
          ],
        ),
        const Gap(10),
        Text(l10n.letters_unauthorized_position_description(
          splittedWord[0].toUpperCase(),
          splittedWord[2].toUpperCase(),
        )),
      ],
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({
    Key? key,
    required this.letter,
    required this.color,
    this.borderColor,
  }) : super(key: key);

  final String letter;
  final Color? borderColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: textTheme.titleLarge,
        ),
      ),
    );
  }
}
