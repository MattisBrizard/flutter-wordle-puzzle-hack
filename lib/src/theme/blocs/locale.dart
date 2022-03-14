import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleBloc extends Cubit<Locale> {
  LocaleBloc({
    required Locale initialLocale,
  }) : super(initialLocale);

  void changeLocale(Locale locale) {
    emit(locale);
  }
}
