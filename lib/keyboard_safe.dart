import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that avoids keyboard overflow, adds padding,
/// optionally scrolls and sticks a footer above the keyboard,
/// dismisses keyboard on tap, and respects safe areas.
class KeyboardSafe extends StatefulWidget {
  final Widget child;
  final Widget? footer;
  final bool scroll;
  final bool autoScrollToFocused;
  final bool dismissOnTapOutside;
  final bool safeArea;
  final bool persistFooter;
  final EdgeInsets padding;
  final bool reverse;
  final void Function(bool visible, double height)? onKeyboardChanged;

  const KeyboardSafe({
    super.key,
    required this.child,
    this.footer,
    this.scroll = false,
    this.autoScrollToFocused = true,
    this.dismissOnTapOutside = false,
    this.safeArea = false,
    this.persistFooter = false,
    this.padding = EdgeInsets.zero,
    this.reverse = false,
    this.onKeyboardChanged,
  });

  /// Call this to dismiss the keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  State<KeyboardSafe> createState() => _KeyboardSafeState();
}

class _KeyboardSafeState extends State<KeyboardSafe>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  double _lastKeyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.autoScrollToFocused) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.addListener(_handleFocusChange);
      });
    }
  }

  @override
  void dispose() {
    if (widget.autoScrollToFocused) {
      FocusManager.instance.removeListener(_handleFocusChange);
    }
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardHeight > 0.0;

    if (_lastKeyboardHeight != keyboardHeight) {
      _lastKeyboardHeight = keyboardHeight;
      widget.onKeyboardChanged?.call(keyboardVisible, keyboardHeight);
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
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    Widget content = Padding(
      padding: widget.padding.copyWith(
        bottom: widget.footer != null && !widget.persistFooter
            ? 16.0
            : keyboardHeight,
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

    if (widget.scroll) {
      content = SingleChildScrollView(
        controller: _scrollController,
        reverse: widget.reverse,
        padding: EdgeInsets.only(
            bottom: widget.persistFooter ? 0.0 : keyboardHeight),
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    if (widget.safeArea) {
      content = SafeArea(child: content);
    }

    if (widget.dismissOnTapOutside) {
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => KeyboardSafe.dismissKeyboard(context),
        child: content,
      );
    }

    return content;
  }
}
