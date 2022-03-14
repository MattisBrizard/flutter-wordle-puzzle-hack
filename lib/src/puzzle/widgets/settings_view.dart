import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:puzzle_hack/src/core/widgets/app_button.dart';
import 'package:puzzle_hack/src/l10n/l10n.dart';
import 'package:puzzle_hack/src/theme/blocs/background_gradient/bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/locale.dart';
import 'package:puzzle_hack/src/theme/blocs/tile_theme/bloc.dart';
import 'package:tap_builder/tap_builder.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
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
                l10n.settings,
                style: textTheme.headline5,
              ),
              const Gap(20),
              const _TileThemeSetting(),
              const Gap(10),
              const _ChangeLocaleSetting(),
              const Gap(10),
              const _GradientBackgroundSetting(),
              const Gap(15),
              const Divider(),
              const Gap(15),
              Text(
                l10n.credits,
                style: textTheme.headline5,
              ),
              const Gap(15),
              const _CreditsDescription(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileThemeSetting extends StatelessWidget {
  const _TileThemeSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tileThemeBloc = context.watch<TileThemeBloc>();
    final isColorBlindMode = tileThemeBloc.isColorBlindMode;

    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(l10n.color_blind_mode),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: CupertinoSwitch(
            value: isColorBlindMode,
            onChanged: (value) {
              tileThemeBloc.toggle();
            },
          ),
        ),
      ],
    );
  }
}

class _ChangeLocaleSetting extends StatelessWidget {
  const _ChangeLocaleSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const locales = AppLocalizations.supportedLocales;

    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(l10n.change_locale),
        ),
        for (final locale in locales) ...[
          _LocaleRadioButton(locale: locale),
          const Gap(15),
        ]
      ],
    );
  }
}

class _LocaleRadioButton extends StatelessWidget {
  const _LocaleRadioButton({
    Key? key,
    required this.locale,
  }) : super(key: key);

  final Locale locale;

  static const double _buttonSize = kMinInteractiveDimension;

  @override
  Widget build(BuildContext context) {
    final activeLocale = context.select((LocaleBloc bloc) => bloc.state);
    final bool isActiveLocale = locale == activeLocale;

    return TapBuilder(
      onTap: () {
        if (!isActiveLocale) {
          context.read<LocaleBloc>().changeLocale(locale);
        }
      },
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
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
                color: (isHover || isPressed || isActiveLocale)
                    ? Colors.white
                    : Colors.white12,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  style: textTheme.bodyLarge!.copyWith(
                    color: (isHover || isPressed || isActiveLocale)
                        ? Colors.black
                        : Colors.white,
                    fontSize: textTheme.bodyLarge!.fontSize! * scale,
                  ),
                  child: Text(locale.languageCode),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientBackgroundSetting extends StatelessWidget {
  const _GradientBackgroundSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppButton(
      label: l10n.update_gradient,
      onTap: () {
        context.read<BackgroundGradientBloc>().updateGradient();
      },
    );
  }
}

class _CreditsDescription extends StatelessWidget {
  const _CreditsDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.credits_developed_by,
        ),
        const Gap(10),
        Text(
          l10n.credits_inspired_by,
        ),
        const Gap(10),
        Text(
          l10n.credits_based_on,
        ),
      ],
    );
  }
}
