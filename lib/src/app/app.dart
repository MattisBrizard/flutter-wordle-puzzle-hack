import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_hack/src/l10n/l10n.dart';
import 'package:puzzle_hack/src/puzzle/bloc/puzzle_bloc.dart';
import 'package:puzzle_hack/src/puzzle/view.dart';
import 'package:puzzle_hack/src/theme/blocs/background_gradient/bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/locale.dart';
import 'package:puzzle_hack/src/theme/blocs/tile_theme/bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleBloc(
            initialLocale: AppLocalizations.supportedLocales.first,
          ),
        ),
        BlocProvider(create: (context) => BackgroundGradientBloc()),
        BlocProvider(create: (context) => TileThemeBloc()),
        BlocProvider(
          create: (context) => PuzzleBloc(5)
            ..add(
              PuzzleReset(
                localeIdentifier: context.read<LocaleBloc>().state.languageCode,
              ),
            ),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<LocaleBloc, Locale>(
          listener: (context, state) {
            context.read<BackgroundGradientBloc>().updateGradient();
            context.read<PuzzleBloc>().add(
                  PuzzleReset(
                    localeIdentifier: state.languageCode,
                  ),
                );
          },
          child: MaterialApp(
            locale: context.select((LocaleBloc bloc) => bloc.state),
            theme: ThemeData.dark().copyWith(
              textTheme:
                  ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const PuzzleView(),
          ),
        );
      }),
    );
  }
}
