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
  return KeyboardSafe(
    scroll: true,
    dismissOnTapOutside: true,
    footer: ElevatedButton(
      onPressed: () {},
      child: const Text('Submit'),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        TextField(decoration: InputDecoration(labelText: 'Email')),
        SizedBox(height: 16),
        TextField(decoration: InputDecoration(labelText: 'Password')),
      ],
    ),
  );
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

---

## 🎥 Demo Video

[▶️ Watch Demo Video](https://github.com/ChathraNavoda/keyboard_safe/blob/main/example/assets/keyboard_safe_demo.mp4)

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
