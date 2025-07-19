import 'package:flutter/material.dart';

class WithoutKeyboardSafePage extends StatelessWidget {
  const WithoutKeyboardSafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _TextFieldBox(label: 'Name', hint: 'Your full name'),
          SizedBox(height: 16),
          _TextFieldBox(label: 'Email', hint: 'you@example.com'),
          SizedBox(height: 16),
          _TextFieldBox(
              label: 'Message', hint: 'Type something...', maxLines: 4),
        ],
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;

  const _TextFieldBox({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: TextField(
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
