import 'package:flutter_riverpod/flutter_riverpod.dart';

final showFavoritesOnlyProvider = NotifierProvider<ShowFavoritesNotifier, bool>(
  ShowFavoritesNotifier.new,
);

class ShowFavoritesNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void showFavorites() {
    state = true;
  }

  void showAll() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}
