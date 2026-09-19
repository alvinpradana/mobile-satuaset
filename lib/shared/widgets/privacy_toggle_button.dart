import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../providers/privacy_provider.dart';

class PrivacyToggleButton extends ConsumerWidget {
  final Color color;
  final double size;

  const PrivacyToggleButton({
    super.key,
    this.color = Colors.grey,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscured = ref.watch(privacyProvider);

    return GestureDetector(
      onTap: () {
        ref.read(privacyProvider.notifier).toggle();
      },
      child: Icon(
        isObscured ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
        color: color,
        size: size,
      ),
    );
  }
}
