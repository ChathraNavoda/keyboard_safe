/// 📱 KeyboardSafe Example App
///
/// This is the entry point for the demo app.
/// It shows a toggle between two pages:
///
/// ✅ `WithKeyboardSafePage`
///     Demonstrates proper keyboard handling using the KeyboardSafe widget.
///
/// 🚫 `WithoutKeyboardSafeScreen`
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
///library;
library;

import 'package:example/with_keyboard_safe.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'without_keyboard_safe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primaryColor = Color.fromARGB(255, 1, 70, 124);
  static const blueColor = Color(0xFF2192C5);
  static const greenColor = Color(0xFF28A745);
  static const ashColor = Color(0xFF585656);
  static const ashDark = Color(0xFF3A3838);
  static const ashLight = Color(0xFF8F8D8D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keyboard Safe Demo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: blueColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          centerTitle: true,
          elevation: 3,
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              inherit: true,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const primaryColor = MyApp.primaryColor;
  static const blueColor = MyApp.blueColor;
  static const greenColor = MyApp.greenColor;
  static const redColor = MyApp.ashColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: blueColor.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Keyboard Safe Demo'),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/c/c6/Dart_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🎯 Hero section
            Column(
              children: [
                Text(
                  'Compare Form Implementations',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'See the difference between forms with and without keyboard-safe handling.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ✅ With Keyboard Safe Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const WithKeyboardSafeScreen()),
                );
              },
              icon: const Icon(Icons.check_circle, color: greenColor),
              label: Text(
                'With Keyboard Safe',
                style: GoogleFonts.poppins(
                  color: greenColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor.withOpacity(0.4),
                side: const BorderSide(color: greenColor, width: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // ❌ Without Keyboard Safe Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const WithoutKeyboardSafeScreen()),
                );
              },
              icon: const Icon(Icons.cancel_sharp, color: redColor),
              label: Text(
                'Without Keyboard Safe',
                style: GoogleFonts.poppins(
                  color: redColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor.withOpacity(0.4),
                side: const BorderSide(color: redColor, width: 1.5),
              ),
            ),
            const SizedBox(height: 36),

            // 💡 Info Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: blueColor, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: blueColor),
                      const SizedBox(width: 8),
                      Text(
                        'How to Test',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: blueColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Tap on text fields to open keyboard\n'
                    '• Green button shows proper keyboard handling\n'
                    '• Red button shows layout issues\n'
                    '• Notice the UI behavior when keyboard appears',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
