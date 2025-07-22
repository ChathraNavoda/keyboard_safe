// INLINED keyboard_safe.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  final Duration keyboardAnimationDuration;
  final void Function(bool visible, double height)? onKeyboardChanged;
  final Curve keyboardAnimationCurve;

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
      setState(() {});
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

// MAIN APP
void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeyboardSafe DartPad Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1DB2BD),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Color(0xFFF8F9FA),
          labelStyle: TextStyle(color: Colors.black54),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const DemoFormPage(),
    );
  }
}

class DemoFormPage extends StatelessWidget {
  const DemoFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KeyboardSafe Demo'),
        backgroundColor: const Color(0xFF1DB2BD),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: KeyboardSafe(
        scroll: true,
        persistFooter: true,
        dismissOnTapOutside: true,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        footer: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1DB2BD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form submitted ✅')),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              'Welcome! This is a live demo of the `KeyboardSafe` widget.\n\n'
              'It prevents keyboard overflow, scrolls to inputs, and keeps the submit button above the keyboard.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Your Message'),
              maxLines: 3,
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
