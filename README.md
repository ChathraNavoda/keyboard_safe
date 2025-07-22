# 📱 keyboard_safe

A lightweight Flutter widget that prevents keyboard overflow by automatically adjusting padding and optionally scrolling input fields into view.

[![pub package](https://img.shields.io/pub/v/keyboard_safe.svg)](https://pub.dev/packages/keyboard_safe)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/ChathraNavoda/keyboard_safe?style=social)](https://github.com/ChathraNavoda/keyboard_safe/stargazers)
[![CI](https://github.com/ChathraNavoda/keyboard_safe/actions/workflows/flutter.yml/badge.svg)](https://github.com/ChathraNavoda/keyboard_safe/actions/workflows/flutter.yml)

---

## ✅ Why KeyboardSafe?

Flutter apps often struggle with keyboard handling, especially in complex forms.  
**`KeyboardSafe`** solves this with a single, configurable wrapper that offers:

- ✅ Automatically adjusts padding when the keyboard appears
- 🎯 Auto-scrolls to focused input fields
- 📌 Optional sticky footer support above the keyboard
- 👆 Tap outside to dismiss keyboard
- 📦 Optional SafeArea wrapping
- 🎬 Smooth animated transitions

---

## 🔧 Install it

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  keyboard_safe: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## 🔨 Usage

Wrap your form or layout with `KeyboardSafe`:

```dart
import 'package:keyboard_safe/keyboard_safe.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('KeyboardSafe Advanced Example'),
    ),
    body: KeyboardSafe(
      scroll: true,
      autoScrollToFocused: true,
      dismissOnTapOutside: true,
      persistFooter: true,
      safeArea: true,
      padding: const EdgeInsets.all(24),
      keyboardAnimationDuration: const Duration(milliseconds: 300),
      keyboardAnimationCurve: Curves.easeInOut,
      onKeyboardChanged: (visible, height) {
        debugPrint('Keyboard is ${visible ? 'visible' : 'hidden'} ($height px)');
      },
      footer: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ElevatedButton.icon(
          onPressed: () {
            KeyboardSafe.dismissKeyboard(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form submitted')),
            );
          },
          icon: const Icon(Icons.send),
          label: const Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your name',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Message',
              hintText: 'Type something...',
            ),
            maxLines: 4,
          ),
        ],
      ),
    ),
  );
}

```

---

### Advanced Example

```dart
import 'package:flutter/material.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdvancedKeyboardSafeDemo(),
  ));
}

class AdvancedKeyboardSafeDemo extends StatefulWidget {
  const AdvancedKeyboardSafeDemo({super.key});

  @override
  State<AdvancedKeyboardSafeDemo> createState() => _AdvancedKeyboardSafeDemoState();
}

class _AdvancedKeyboardSafeDemoState extends State<AdvancedKeyboardSafeDemo> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  void _handleSubmit() {
    KeyboardSafe.dismissKeyboard(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted ✅')),
    );

    nameController.clear();
    emailController.clear();
    messageController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced KeyboardSafe Example'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1DB2BD),
        foregroundColor: Colors.white,
      ),
      body: KeyboardSafe(
        scroll: true,
        autoScrollToFocused: true,
        dismissOnTapOutside: true,
        persistFooter: true,
        safeArea: true,
        padding: const EdgeInsets.all(24),
        keyboardAnimationDuration: const Duration(milliseconds: 300),
        keyboardAnimationCurve: Curves.easeInOut,
        footer: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ElevatedButton.icon(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF1DB2BD),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.send),
            label: const Text(
              'Send',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        onKeyboardChanged: (visible, height) {
          debugPrint('Keyboard is ${visible ? 'shown' : 'hidden'} ($height px)');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TextFieldBox(
              label: 'Name',
              hint: 'Your full name',
              controller: nameController,
            ),
            const SizedBox(height: 16),
            _TextFieldBox(
              label: 'Email',
              hint: 'you@example.com',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            _TextFieldBox(
              label: 'Message',
              hint: 'Type your message...',
              maxLines: 4,
              controller: messageController,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextEditingController controller;

  const _TextFieldBox({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

```

---

## 📱 Example App

The [`example/`](example/) app demonstrates the benefits of using `KeyboardSafe`:

✅ Includes a toggle for **'With' vs 'Without KeyboardSafe'**  
✅ Demonstrates auto-scroll to input, sticky footer, keyboard avoidance, and tap-outside dismissal

To run:

```bash
flutter run example
```

> 💡 If you use FVM, replace `flutter` with `fvm flutter` in the command above.

---

## 🎬 Demo

Here's a quick demo of `KeyboardSafe` in action 👇

<img src="https://raw.githubusercontent.com/ChathraNavoda/keyboard_safe/main/example/assets/keyboard_safe_demo.gif" width="600" alt="KeyboardSafe Demo" />

## 🧪 Try it on DartPad

Want to test it live? Here's a minimal demo running in DartPad 👇

[![Open in DartPad](https://dartpad.dev/assets/play_button.svg)](https://dartpad.dev/?id=2cb20d24bdaf111496bc2088822fe1b7)

## 🧪 Run the DartPad demo locally

To run the DartPad-compatible demo on your device/emulator:

```bash
# Make sure you're in the example/ folder
cd example

# Then run the custom demo entry point
flutter run -t lib/dartpad_demo.dart
```

> 💡 If you use FVM, replace `flutter` with `fvm flutter` in the command above.

## 📦 Parameters

| Parameter                   | Type                           | Default                       | Description                                                   |
| --------------------------- | ------------------------------ | ----------------------------- | ------------------------------------------------------------- |
| `child`                     | `Widget`                       | — _(required)_                | Main content inside the wrapper                               |
| `footer`                    | `Widget?`                      | `null`                        | Optional footer shown above the keyboard (e.g. Submit button) |
| `scroll`                    | `bool`                         | `false`                       | Whether to wrap in `SingleChildScrollView`                    |
| `autoScrollToFocused`       | `bool`                         | `true`                        | Automatically scroll focused field into view                  |
| `dismissOnTapOutside`       | `bool`                         | `false`                       | Tap anywhere to dismiss keyboard                              |
| `safeArea`                  | `bool`                         | `false`                       | Wrap in a `SafeArea` widget                                   |
| `persistFooter`             | `bool`                         | `false`                       | Whether footer should remain visible when keyboard appears    |
| `padding`                   | `EdgeInsets`                   | `EdgeInsets.zero`             | Base padding applied before keyboard adjustment               |
| `reverse`                   | `bool`                         | `false`                       | Reverses scroll direction                                     |
| `onKeyboardChanged`         | `void Function(bool, double)?` | `null`                        | Callback when keyboard appears/disappears                     |
| `keyboardAnimationDuration` | `Duration`                     | `Duration(milliseconds: 250)` | Duration of keyboard transitions                              |
| `keyboardAnimationCurve`    | `Curve`                        | `Curves.easeOut`              | Curve used in `AnimatedPadding` and `AnimatedContainer`       |

---

## ⌨️ Dismiss Keyboard

You can programmatically dismiss the keyboard using:

```dart
KeyboardSafe.dismissKeyboard(context);
```

---

## 🧪 Testing

This package includes widget tests that verify key behaviors:

```bash
flutter test
```

Covered features:

✅ Padding applied when `MediaQuery.viewInsets.bottom` is non-zero  
✅ Keyboard dismissal when tapping outside of input

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

---

## 💡 Contribute

Feel free to file issues or submit PRs to help improve this package.  
Star ⭐ the repo if you found this helpful!

---

## 💬 Maintainer

Made by [@ChathraNavoda](https://github.com/ChathraNavoda)
