import 'package:flutter/material.dart';

/// A widget that avoids keyboard overflow, adds padding,
/// optionally scrolls and sticks a footer above the keyboard.
class KeyboardSafe extends StatefulWidget {
  final Widget child;
  final Widget? footer;
  final bool scroll;
  final bool autoScrollToFocused;
  final EdgeInsets padding;
  final bool reverse;

  const KeyboardSafe({
    super.key,
    required this.child,
    this.footer,
    this.scroll = false,
    this.autoScrollToFocused = true,
    this.padding = EdgeInsets.zero,
    this.reverse = false,
  });

  /// Call this to dismiss the keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  State<KeyboardSafe> createState() => _KeyboardSafeState();
}

class _KeyboardSafeState extends State<KeyboardSafe> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.autoScrollToFocused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.addListener(_handleFocusChange);
      });
    }
  }

  void _handleFocusChange() {
    final focused = FocusManager.instance.primaryFocus;
    if (focused?.context != null) {
      Scrollable.ensureVisible(
        focused!.context!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.2,
      );
    }
  }

  @override
  void dispose() {
    if (widget.autoScrollToFocused) {
      FocusManager.instance.removeListener(_handleFocusChange);
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final content = Padding(
      padding: widget.padding.copyWith(
        bottom: widget.footer != null ? 16.0 : keyboardHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.child,
          if (widget.footer != null) ...[
            const SizedBox(height: 24),
            widget.footer!,
          ],
        ],
      ),
    );

    if (!widget.scroll) return content;

    return SingleChildScrollView(
      controller: _scrollController,
      reverse: widget.reverse,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      physics: const BouncingScrollPhysics(),
      child: content,
    );
  }
}
