import 'package:flutter_riverpod/flutter_riverpod.dart';

final privacyProvider = StateNotifierProvider<PrivacyNotifier, bool>((ref) {
  return PrivacyNotifier();
});

class PrivacyNotifier extends StateNotifier<bool> {
  PrivacyNotifier() : super(false); // default: false (not obscured, visible)

  void toggle() {
    state = !state;
  }
}
