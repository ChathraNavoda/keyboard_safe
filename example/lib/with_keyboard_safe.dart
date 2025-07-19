import 'package:flutter/material.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

class WithKeyboardSafePage extends StatefulWidget {
  const WithKeyboardSafePage({super.key});

  @override
  State<WithKeyboardSafePage> createState() => _WithKeyboardSafePageState();
}

class _WithKeyboardSafePageState extends State<WithKeyboardSafePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  void _handleSubmit() {
    KeyboardSafe.dismissKeyboard(context);

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted ✨')),
    );

    // Clear fields
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
    return KeyboardSafe(
      scroll: true,
      autoScrollToFocused: true,
      dismissOnTapOutside: true,
      persistFooter: true,
      onKeyboardChanged: (visible, height) {
        debugPrint(
            'Keyboard is ${visible ? 'visible' : 'hidden'} ($height px)');
      },
      safeArea: true,
      padding: const EdgeInsets.all(24),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ElevatedButton.icon(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF1DB2BD),
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text(
            'Send',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
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
            hint: 'Type something...',
            maxLines: 4,
            controller: messageController,
          ),
        ],
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextEditingController? controller;

  const _TextFieldBox({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
