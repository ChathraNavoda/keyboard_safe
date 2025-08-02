# 📱 keyboard_safe

A comprehensive Flutter widget that eliminates keyboard overflow issues with intelligent layout management, auto-scrolling, and smooth animations.

[![pub package](https://img.shields.io/pub/v/keyboard_safe.svg)](https://pub.dev/packages/keyboard_safe)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/ChathraNavoda/keyboard_safe?style=social)](https://github.com/ChathraNavoda/keyboard_safe/stargazers)
[![CI](https://github.com/ChathraNavoda/keyboard_safe/actions/workflows/flutter.yml/badge.svg)](https://github.com/ChathraNavoda/keyboard_safe/actions/workflows/flutter.yml)

---

## 🌟 Why KeyboardSafe?

Keyboard handling is one of Flutter's biggest pain points. **`KeyboardSafe`** transforms this challenge into a seamless experience with a single, powerful wrapper that provides:

- ✅ **Smart Layout Management**: Automatically adjusts padding when keyboard appears/disappears
- 🎯 **Auto-Scroll Intelligence**: Focused input fields scroll into view automatically
- 📌 **Flexible Footer Support**: Choose between sticky footers or screen-bottom placement
- 👆 **Tap-to-Dismiss**: Native-like keyboard dismissal when tapping outside
- 🛡️ **SafeArea Integration**: Optional SafeArea wrapping for notched devices
- 🎬 **Buttery Smooth Animations**: Configurable duration and curves for all transitions
- 📱 **UX-First Design**: Built with mobile app best practices in mind

Perfect for forms, chat interfaces, login screens, and any app with text input!

---

## 🚀 Quick Start

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  keyboard_safe: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Basic Usage

Transform your forms in seconds:

```dart
import 'package:keyboard_safe/keyboard_safe.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: KeyboardSafe(
      scroll: true,
      dismissOnTapOutside: true,
      footer: ElevatedButton(
        onPressed: _submitForm,
        child: const Text('Submit'),
      ),
      child: Column(
        children: [
          TextField(decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height: 16),
          TextField(decoration: InputDecoration(labelText: 'Password')),
        ],
      ),
    ),
  );
}
```

That's it! Your form now handles keyboard overflow, auto-scrolls to focused fields, and includes a responsive footer.

---

## 🎯 Complete Example

Here's a production-ready form showcasing all features:

```dart
import 'package:flutter/material.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: KeyboardSafe(
        // Enable scrolling for better UX
        scroll: true,

        // Auto-scroll focused fields into view
        autoScrollToFocused: true,

        // Tap anywhere to dismiss keyboard
        dismissOnTapOutside: true,

        // Respect device safe areas
        safeArea: true,

        // Add consistent padding
        padding: EdgeInsets.all(24),

        // Customize animation timing
        keyboardAnimationDuration: Duration(milliseconds: 300),
        keyboardAnimationCurve: Curves.easeInOut,

        // Track keyboard state changes
        onKeyboardChanged: (visible, height) {
          setState(() => _isKeyboardVisible = visible);
          print('Keyboard ${visible ? 'shown' : 'hidden'}: ${height}px');
        },

        // Footer stays at screen bottom (recommended UX)
        footer: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              // Dismiss keyboard before processing
              KeyboardSafe.dismissKeyboard(context);
              _handleLogin();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isKeyboardVisible ? 'Login' : 'Login to Continue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo or header
              Container(
                height: 120,
                margin: EdgeInsets.only(bottom: 32),
                child: Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ),

              // Email field
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'you@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Password field
              TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              // Additional options
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Forgot password? Tap here to reset',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20), // Extra space before footer
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
    }
  }
}
```

---

## 📦 API Reference

### KeyboardSafe Parameters

| Parameter                       | Type                      | Default           | Description                                                  |
| ------------------------------- | ------------------------- | ----------------- | ------------------------------------------------------------ |
| **`child`**                     | `Widget`                  | _required_        | Main content inside the wrapper                              |
| **`footer`**                    | `Widget?`                 | `null`            | Optional footer (e.g. Submit button) shown above keyboard    |
| **`scroll`**                    | `bool`                    | `false`           | Wraps content in `SingleChildScrollView` for tall layouts    |
| **`autoScrollToFocused`**       | `bool`                    | `true`            | Auto-scrolls focused input fields into view                  |
| **`dismissOnTapOutside`**       | `bool`                    | `false`           | Dismisses keyboard when tapping outside input fields         |
| **`safeArea`**                  | `bool`                    | `false`           | Wraps layout in `SafeArea` widget                            |
| **`persistFooter`**             | `bool`                    | `false`           | If `true`, footer floats above keyboard (can feel intrusive) |
| **`padding`**                   | `EdgeInsets`              | `EdgeInsets.zero` | Additional padding around content                            |
| **`reverse`**                   | `bool`                    | `false`           | Reverses scroll direction (useful for chat interfaces)       |
| **`onKeyboardChanged`**         | `Function(bool, double)?` | `null`            | Callback when keyboard visibility changes                    |
| **`keyboardAnimationDuration`** | `Duration`                | `250ms`           | Duration of keyboard-related animations                      |
| **`keyboardAnimationCurve`**    | `Curve`                   | `Curves.easeOut`  | Animation curve for smooth transitions                       |

### Static Methods

```dart
// Dismiss keyboard programmatically
KeyboardSafe.dismissKeyboard(context);
```

---

## 🎨 Usage Patterns

### 1. Simple Forms

```dart
KeyboardSafe(
  scroll: true,
  child: YourFormContent(),
)
```

### 2. Forms with Submit Button

```dart
KeyboardSafe(
  scroll: true,
  footer: SubmitButton(),
  child: YourFormContent(),
)
```

### 3. Chat Interface

```dart
KeyboardSafe(
  scroll: true,
  reverse: true, // New messages at bottom
  persistFooter: true, // Keep input visible
  footer: MessageInput(),
  child: MessageList(),
)
```

### 4. Full-Screen Experience

```dart
KeyboardSafe(
  safeArea: true,
  dismissOnTapOutside: true,
  padding: EdgeInsets.all(16),
  child: YourContent(),
)
```

---

## 🆚 Footer Behavior Guide

**`persistFooter: false` (Recommended)**

- Footer stays at screen bottom
- Provides familiar mobile app experience
- Better for submit buttons and navigation

**`persistFooter: true` (Use Sparingly)**

- Footer floats above keyboard
- Can feel intrusive in most contexts
- Good for chat apps where input must stay visible

---

## 🎬 Demo

See `KeyboardSafe` in action:

<img src="https://raw.githubusercontent.com/ChathraNavoda/keyboard_safe/main/example/assets/keyboard_safe_demo.gif" width="600" alt="KeyboardSafe Demo" />

## 🎬 Demo

**See the dramatic difference KeyboardSafe makes:**

### 📱 Side-by-Side Comparison

|                                                                               Without KeyboardSafe                                                                                |                                                                            With KeyboardSafe                                                                            |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| <img src="https://raw.githubusercontent.com/ChathraNavoda/keyboard_safe/main/example/assets/without_keyboard_safe_demo.mp4" width="300" alt="Without KeyboardSafe - Broken UX" /> | <img src="https://raw.githubusercontent.com/ChathraNavoda/keyboard_safe/main/example/assets/with-reducing----3.mp4" width="300" alt="With KeyboardSafe - Perfect UX" /> |
|                                 ❌ Footer covers form fields<br/>❌ No auto-scroll<br/>❌ Manual keyboard handling<br/>❌ Broken user experience                                  |                     ✅ Smart layout management<br/>✅ Auto-scroll to focused fields<br/>✅ Tap-to-dismiss keyboard<br/>✅ Seamless user experience                      |

### 🎯 The Problem vs Solution

**The Problem (Left):** Typical Flutter keyboard issues that frustrate users:

- Footer floats up and covers input fields
- No automatic scrolling to focused fields
- Users must manually dismiss keyboard
- Broken layouts and poor UX

**The Solution (Right):** KeyboardSafe transforms the experience:

- Intelligent layout adjustment
- Automatic field focusing and scrolling
- Native-like tap-to-dismiss behavior
- Professional, polished user experience

---

## 🧪 Try it Live

Experience the difference yourself:

[![Open in DartPad](https://img.shields.io/badge/DartPad-Try%20Live%20Demo-blue?logo=dart&logoColor=white)](https://dartpad.dev/?id=2cb20d24bdaf111496bc2088822fe1b7)

### Run Example App

```bash
cd example
flutter run
```

### Run DartPad Demo Locally

```bash
cd example
flutter run -t lib/dartpad_demo.dart
```

---

## 🧪 Testing

KeyboardSafe includes comprehensive widget tests:

```bash
flutter test
```

**Test Coverage:**

- ✅ Keyboard padding application
- ✅ Auto-scroll to focused fields
- ✅ Footer positioning behavior
- ✅ Tap-outside dismissal
- ✅ Animation timing
- ✅ SafeArea integration

---

## 🔄 Migration Guide

### From v0.0.x to v1.0.0

v1.0.0 introduces powerful new features while maintaining backward compatibility:

**✅ No Breaking Changes**: Existing code continues to work  
**🆕 New Features**: Enhanced footer control, better animations, improved UX  
**📖 Better Docs**: Comprehensive examples and usage patterns

**Recommended Updates:**

```dart
// Before (still works)
KeyboardSafe(child: MyForm())

// After (recommended)
KeyboardSafe(
  scroll: true,
  dismissOnTapOutside: true,
  footer: MySubmitButton(),
  child: MyForm(),
)
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **🐛 Report Issues**: Found a bug? [Open an issue](https://github.com/ChathraNavoda/keyboard_safe/issues)
2. **💡 Suggest Features**: Have ideas? We'd love to hear them
3. **🔧 Submit PRs**: Improvements and fixes are always welcome
4. **⭐ Star the Repo**: Help others discover this package

### Development Setup

```bash
git clone https://github.com/ChathraNavoda/keyboard_safe.git
cd keyboard_safe
flutter pub get
flutter test
```

---

## 📊 Package Stats

- 🎯 **100% Dart**: Pure Flutter implementation
- 📱 **All Platforms**: iOS, Android, Web, Desktop
- 🧪 **Well Tested**: Comprehensive test suite
- 📖 **Fully Documented**: Every API has detailed docs
- 🚀 **Production Ready**: Used in real-world apps

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 💪 Built by the Community

**KeyboardSafe** started as a solution to a common Flutter problem and evolved into a comprehensive package thanks to community feedback and real-world usage.

**Made by [@ChathraNavoda](https://github.com/ChathraNavoda)**

---

_If KeyboardSafe saved you time and headaches, consider starring ⭐ the repo to help others discover it!_
