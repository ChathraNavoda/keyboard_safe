import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A comprehensive Flutter widget that prevents keyboard overflow and layout issues by:
/// - Adding padding when the keyboard appears
/// - Optionally scrolling to focused input fields
/// - Supporting sticky footers above the keyboard
/// - Dismissing the keyboard when tapping outside
/// - Respecting SafeArea padding
/// - Animating layout transitions smoothly
///
/// This widget handles all common keyboard-related UI challenges in Flutter apps,
/// providing a seamless user experience across different screen sizes and orientations.
class KeyboardSafe extends StatefulWidget {
  /// The main content of your screen or form.
  final Widget child;

  /// An optional footer (e.g. Submit button) to be shown above the keyboard.
  ///
  /// When [persistFooter] is false (recommended), the footer stays at the screen
  /// bottom for better UX. When true, it floats above the keyboard.
  final Widget? footer;

  /// If true, wraps the content in a [SingleChildScrollView].
  ///
  /// Enable this when your content might be taller than the available space,
  /// especially in forms with multiple input fields.
  final bool scroll;

  /// If true, automatically scrolls focused input fields into view when the keyboard appears.
  ///
  /// This ensures users can always see what they're typing, even on smaller screens.
  /// Only works when [scroll] is enabled.
  final bool autoScrollToFocused;

  /// If true, dismisses the keyboard when tapping outside of input fields.
  ///
  /// Provides a native app-like experience where users can tap anywhere
  /// to hide the keyboard and see more content.
  final bool dismissOnTapOutside;

  /// If true, wraps the entire layout in a [SafeArea].
  ///
  /// Use this to avoid system UI elements like notches and navigation bars.
  /// Often better to handle SafeArea at the screen level rather than here.
  final bool safeArea;

  /// Controls footer behavior when the keyboard is open.
  ///
  /// **IMPORTANT UX NOTE**:
  /// - When false (default): Footer stays at screen bottom for better UX
  /// - When true: Footer floats above keyboard which can feel intrusive
  ///
  /// Most apps should keep this false unless the footer contains critical
  /// actions that must remain visible while typing.
  final bool persistFooter;

  /// Additional padding to apply around the content.
  ///
  /// This padding is applied in addition to keyboard-aware padding.
  /// Useful for consistent margins throughout your app.
  final EdgeInsets padding;

  /// If true, reverses the scroll direction (useful for chat-like interfaces).
  ///
  /// When enabled, new content appears at the bottom and scrolling feels
  /// natural for bottom-up lists like chat messages.
  final bool reverse;

  /// Callback invoked when the keyboard visibility or height changes.
  ///
  /// Useful for triggering custom animations or updating app state
  /// when the keyboard appears/disappears.
  final void Function(bool visible, double height)? onKeyboardChanged;

  /// Duration of keyboard-related animations.
  ///
  /// Shorter durations feel more responsive, longer ones feel smoother.
  /// The default 250ms balances both well.
  final Duration keyboardAnimationDuration;

  /// Animation curve used for keyboard-related transitions.
  ///
  /// [Curves.easeOut] provides a natural deceleration that feels responsive.
  final Curve keyboardAnimationCurve;

  /// Creates a [KeyboardSafe] widget.
  ///
  /// The [child] parameter is required and contains your main content.
  /// All other parameters are optional with sensible defaults.
  ///
  /// Example:
  /// ```dart
  /// KeyboardSafe(
  ///   scroll: true,
  ///   footer: ElevatedButton(
  ///     onPressed: () => _submitForm(),
  ///     child: Text('Submit'),
  ///   ),
  ///   child: Form(
  ///     child: Column(
  ///       children: [
  ///         TextFormField(decoration: InputDecoration(labelText: 'Name')),
  ///         TextFormField(decoration: InputDecoration(labelText: 'Email')),
  ///       ],
  ///     ),
  ///   ),
  /// )
  /// ```
  const KeyboardSafe({
    super.key,
    required this.child,
    this.footer,
    this.scroll = false,
    this.autoScrollToFocused = true,
    this.dismissOnTapOutside = false,
    this.safeArea = false,
    this.persistFooter = false, // Default false for better UX
    this.padding = EdgeInsets.zero,
    this.reverse = false,
    this.keyboardAnimationDuration = const Duration(milliseconds: 250),
    this.onKeyboardChanged,
    this.keyboardAnimationCurve = Curves.easeOut,
  }) : assert(
          !autoScrollToFocused || scroll,
          'autoScrollToFocused requires scroll to be enabled',
        );

  /// Programmatically dismisses the keyboard from anywhere in your app.
  ///
  /// Example:
  /// ```dart
  /// ElevatedButton(
  ///   onPressed: () {
  ///     KeyboardSafe.dismissKeyboard(context);
  ///     _submitForm();
  ///   },
  ///   child: Text('Submit'),
  /// )
  /// ```
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
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.autoScrollToFocused) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          FocusManager.instance.addListener(_handleFocusChange);
        }
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (widget.autoScrollToFocused) {
      FocusManager.instance.removeListener(_handleFocusChange);
    }
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_isDisposed) return;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardHeight > 0.0;

    if (_lastKeyboardHeight != keyboardHeight) {
      _lastKeyboardHeight = keyboardHeight;
      widget.onKeyboardChanged?.call(keyboardVisible, keyboardHeight);

      // Only rebuild if still mounted
      if (mounted) {
        setState(() {}); // Triggers smooth animation
      }
    }
  }

  void _handleFocusChange() {
    if (_isDisposed || !widget.scroll || !mounted) return;

    final focused = FocusManager.instance.primaryFocus;
    if (focused?.context != null && _scrollController.hasClients) {
      // Small delay to ensure keyboard animation has started
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_isDisposed && _scrollController.hasClients) {
          try {
            Scrollable.ensureVisible(
              focused!.context!,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: 0.2, // Show focused field in upper 20% of visible area
            );
          } catch (e) {
            // Gracefully handle edge cases where context becomes invalid
            debugPrint('KeyboardSafe: Could not scroll to focused widget: $e');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return _wrapWithOptionalFeatures(
      _buildMainLayout(keyboardHeight, isKeyboardVisible),
    );
  }

  Widget _buildMainLayout(double keyboardHeight, bool isKeyboardVisible) {
    if (widget.footer != null) {
      if (widget.persistFooter) {
        // INTRUSIVE MODE: Footer floats above keyboard
        return _buildPersistentFooterLayout(keyboardHeight);
      } else {
        // RECOMMENDED MODE: Footer stays at screen bottom for better UX
        return _buildBottomFooterLayout(keyboardHeight);
      }
    } else {
      // No footer layout
      return _buildNoFooterLayout(keyboardHeight);
    }
  }

  /// Layout with footer that sticks above keyboard (can feel intrusive)
  Widget _buildPersistentFooterLayout(double keyboardHeight) {
    return Column(
      children: [
        // Scrollable content area that shrinks when keyboard appears
        Expanded(
          child: widget.scroll
              ? SingleChildScrollView(
                  controller: _scrollController,
                  reverse: widget.reverse,
                  physics: const BouncingScrollPhysics(),
                  padding: widget.padding,
                  child: widget.child,
                )
              : AnimatedPadding(
                  duration: widget.keyboardAnimationDuration,
                  curve: widget.keyboardAnimationCurve,
                  padding: widget.padding,
                  child: widget.child,
                ),
        ),
        // Footer that follows keyboard up smoothly
        AnimatedContainer(
          duration: widget.keyboardAnimationDuration,
          curve: widget.keyboardAnimationCurve,
          margin: EdgeInsets.only(bottom: keyboardHeight),
          child: widget.footer!,
        ),
      ],
    );
  }

  /// Layout with footer at screen bottom (recommended for better UX)
  Widget _buildBottomFooterLayout(double keyboardHeight) {
    if (widget.scroll) {
      // When scrollable: Include footer in scroll area for seamless experience
      return AnimatedPadding(
        duration: widget.keyboardAnimationDuration,
        curve: widget.keyboardAnimationCurve,
        padding: widget.padding.copyWith(
          bottom: widget.padding.bottom + keyboardHeight,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                reverse: widget.reverse,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widget.child,
                    const SizedBox(height: 24), // Breathing room before footer
                    widget.footer!,
                    const SizedBox(height: 20), // Extra space at bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // When not scrollable: Keep footer anchored at screen bottom
      return Column(
        children: [
          // Content area that adjusts padding for keyboard
          Expanded(
            child: AnimatedPadding(
              duration: widget.keyboardAnimationDuration,
              curve: widget.keyboardAnimationCurve,
              padding: widget.padding.copyWith(
                bottom: widget.padding.bottom + keyboardHeight,
              ),
              child: widget.child,
            ),
          ),
          // Footer stays at very bottom of screen
          SizedBox(
            width: double.infinity,
            child: widget.footer!,
          ),
        ],
      );
    }
  }

  /// Layout without footer - just content with keyboard-aware padding
  Widget _buildNoFooterLayout(double keyboardHeight) {
    final keyboardPadding = widget.padding.copyWith(
      bottom: widget.padding.bottom + keyboardHeight,
    );

    if (widget.scroll) {
      return AnimatedPadding(
        duration: widget.keyboardAnimationDuration,
        curve: widget.keyboardAnimationCurve,
        padding: keyboardPadding,
        child: SingleChildScrollView(
          controller: _scrollController,
          reverse: widget.reverse,
          physics: const BouncingScrollPhysics(),
          child: widget.child,
        ),
      );
    } else {
      return AnimatedPadding(
        duration: widget.keyboardAnimationDuration,
        curve: widget.keyboardAnimationCurve,
        padding: keyboardPadding,
        child: widget.child,
      );
    }
  }

  /// Wraps content with optional features like SafeArea and tap-to-dismiss
  Widget _wrapWithOptionalFeatures(Widget content) {
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
