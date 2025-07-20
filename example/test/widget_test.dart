import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

void main() {
  testWidgets('dismisses keyboard on tap outside when enabled', (tester) async {
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KeyboardSafe(
            dismissOnTapOutside: true,
            scroll: true,
            child: Column(
              children: [
                const SizedBox(height: 100), // Create some top space
                TextField(focusNode: focusNode),
                const SizedBox(height: 600), // Ensure space to tap below
              ],
            ),
          ),
        ),
      ),
    );

    // Focus the TextField
    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, true);

    // Tap somewhere clearly outside the TextField
    await tester.tapAt(const Offset(20, 550));
    await tester.pumpAndSettle();

    // Expect keyboard (focus) dismissed
    expect(focusNode.hasFocus, false); // ✅
  });
}
