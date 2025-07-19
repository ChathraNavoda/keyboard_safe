import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

void main() {
  testWidgets('adds keyboard padding when viewInsets.bottom is non-zero',
      (WidgetTester tester) async {
    const keyboardHeight = 300.0;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: keyboardHeight),
          ),
          child: KeyboardSafe(
            scroll: false,
            padding: EdgeInsets.zero,
            child: Container(key: Key('child')),
          ),
        ),
      ),
    );

    final padding = tester.widget<Padding>(find.byType(Padding));
    final paddingValue = padding.padding as EdgeInsets;

    expect(paddingValue.bottom, keyboardHeight);
  });

  testWidgets('dismisses keyboard on tap outside when enabled',
      (WidgetTester tester) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KeyboardSafe(
            scroll: true,
            dismissOnTapOutside: true,
            child: Column(
              children: [
                const SizedBox(
                    height: 100), // 🟢 Tap target (safe outside area)
                TextField(focusNode: focusNode),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      ),
    );

    // Focus the text field
    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, true);

    // Tap the top area (above the text field)
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    // Focus should be removed
    expect(focusNode.hasFocus, false);
  });
}
