import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/tile_theme/state.dart';

class TileThemeBloc extends Cubit<TileThemeState> {
  TileThemeBloc() : super(const ClassicThemeState());

  bool get isColorBlindMode => state is ColorBlindThemeState;

  void toggle() {
    emit(
      isColorBlindMode
          ? const ClassicThemeState()
          : const ColorBlindThemeState(),
    );
  }
}
