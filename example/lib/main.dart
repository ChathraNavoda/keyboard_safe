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
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1DB2BD),
          secondary: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
        ),
        textTheme: GoogleFonts.happyMonkeyTextTheme(),
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
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
