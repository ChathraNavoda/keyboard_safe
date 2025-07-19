import 'package:flutter/material.dart';

/// A widget that avoids keyboard overflow by adding bottom padding.
/// Also supports scroll wrapping and sticky footer above the keyboard.
class KeyboardSafe extends StatelessWidget {
  final Widget child;
  final Widget? footer;
  final bool scroll;
  final EdgeInsets padding;
  final bool reverse;

  const KeyboardSafe({
    super.key,
    required this.child,
    this.footer,
    this.scroll = false,
    this.padding = EdgeInsets.zero,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final adjustedPadding = padding.copyWith(
      bottom: padding.bottom + (footer == null ? keyboardHeight : 0),
    );

    Widget mainContent = Padding(
      padding: adjustedPadding,
      child: child,
    );

    if (scroll) {
      mainContent = SingleChildScrollView(
        reverse: reverse,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: mainContent,
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: mainContent,
        ),
        if (footer != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: footer!,
          ),
      ],
    );
  }
}
