import 'package:flutter/material.dart';

/// A widget that avoids keyboard overflow by adding bottom padding.
/// Optionally wraps content in a scroll view.
class KeyboardSafe extends StatelessWidget {
  final Widget child;
  final bool scroll;
  final EdgeInsets padding;
  final bool reverse;

  const KeyboardSafe({
    super.key,
    required this.child,
    this.scroll = false,
    this.padding = EdgeInsets.zero,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final totalPadding =
        padding.copyWith(bottom: padding.bottom + keyboardHeight);

    Widget content = Padding(
      padding: totalPadding,
      child: child,
    );

    if (scroll) {
      content = SingleChildScrollView(
        reverse: reverse,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    return content;
  }
}
