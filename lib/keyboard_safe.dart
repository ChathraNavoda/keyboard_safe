import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that avoids keyboard overflow and layout issues by:
/// - Adding padding when the keyboard appears
/// - Optionally scrolling to focused input fields
/// - Supporting sticky footers above the keyboard
/// - Dismissing the keyboard when tapping outside
/// - Respecting SafeArea padding
/// - Animating layout transitions
class KeyboardSafe extends StatefulWidget {
  /// The main content of your screen or form.
  final Widget child;

  /// An optional footer (e.g. Submit button) to be shown above the keyboard.
  final Widget? footer;

  /// If true, wraps the content in a [SingleChildScrollView].
  final bool scroll;

  /// If true, auto-scrolls the focused input into view when the keyboard appears.
  final bool autoScrollToFocused;

  /// If true, dismisses the keyboard when tapping outside of input fields.
  final bool dismissOnTapOutside;

  /// If true, wraps the entire layout in a [SafeArea].
  final bool safeArea;

  /// If true, keeps the footer visible even when the keyboard is open.
  final bool persistFooter;

  /// Additional padding to apply around the content.
  final EdgeInsets padding;

  /// If true, reverses the scroll direction (useful for bottom-up lists).
  final bool reverse;

  /// Callback invoked when the keyboard visibility or height changes.
  final void Function(bool visible, double height)? onKeyboardChanged;

  /// Duration of the keyboard animation.
  final Duration keyboardAnimationDuration;

  /// Curve used in keyboard-related animations.
  final Curve keyboardAnimationCurve;

  /// Creates a [KeyboardSafe] widget.
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
    this.keyboardAnimationDuration = const Duration(milliseconds: 250),
    this.onKeyboardChanged,
    this.keyboardAnimationCurve = Curves.easeOut,
  });

  /// Programmatically dismisses the keyboard.
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
      setState(() {}); // Triggers animation
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

    Widget content = AnimatedPadding(
      duration: widget.keyboardAnimationDuration,
      curve: widget.keyboardAnimationCurve,
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

    return AnimatedContainer(
      duration: widget.keyboardAnimationDuration,
      curve: widget.keyboardAnimationCurve,
      child: content,
    );
  }
}
