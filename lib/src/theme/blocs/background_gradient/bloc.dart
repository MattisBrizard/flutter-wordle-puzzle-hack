import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_hack/src/theme/blocs/background_gradient/state.dart';

class BackgroundGradientBloc extends Cubit<BackgroundGradientState> {
  BackgroundGradientBloc() : super(BackgroundGradientState.random());

  void updateGradient() {
    emit(BackgroundGradientState.random());
  }
}
