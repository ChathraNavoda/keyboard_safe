/// 📱 KeyboardSafe Example App
///
/// This is the entry point for the demo app.
/// It shows a toggle between two pages:
///
/// ✅ `WithKeyboardSafePage`
///     Demonstrates proper keyboard handling using the KeyboardSafe widget.
///
/// 🚫 `WithoutKeyboardSafePage`
///     Shows the same UI without KeyboardSafe to illustrate common layout issues.
///
/// 📂 You can find the source files in:
/// - `example/lib/with_keyboard_safe.dart`
/// - `example/lib/without_keyboard_safe.dart`
///
/// 👉 To explore fully, consider cloning the repo:
/// https://github.com/ChathraNavoda/keyboard_safe
///
/// 💡 Run this demo using:
/// flutter run example
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'with_keyboard_safe.dart';
import 'without_keyboard_safe.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeyboardSafe Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB2BD),
          secondary: Colors.white,
          surface: Color(0xFF1E1E1E),
        ),
        textTheme: GoogleFonts.happyMonkeyTextTheme(
          ThemeData.dark().textTheme, // 👈 important
        ),
        useMaterial3: true,
      ),
      home: const DemoSwitcher(),
    );
  }
}

class DemoSwitcher extends StatefulWidget {
  const DemoSwitcher({super.key});

  @override
  State<DemoSwitcher> createState() => _DemoSwitcherState();
}

class _DemoSwitcherState extends State<DemoSwitcher> {
  bool showWithKeyboardSafe = true;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KeyboardSafe Demo'),
        centerTitle: true,
        backgroundColor: activeColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: inactiveColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  _ToggleButton(
                    text: 'With KeyboardSafe',
                    selected: showWithKeyboardSafe,
                    onTap: () => setState(() => showWithKeyboardSafe = true),
                  ),
                  _ToggleButton(
                    text: 'Without',
                    selected: !showWithKeyboardSafe,
                    onTap: () => setState(() => showWithKeyboardSafe = false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: showWithKeyboardSafe
                ? const WithKeyboardSafePage()
                : const WithoutKeyboardSafePage(),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
