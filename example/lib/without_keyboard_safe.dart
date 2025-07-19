import 'package:flutter/material.dart';

class WithoutKeyboardSafePage extends StatelessWidget {
  const WithoutKeyboardSafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TextFieldBox(label: 'Name', hint: 'Your full name'),
          const SizedBox(height: 12),
          const _TextFieldBox(label: 'Email', hint: 'you@example.com'),
          const SizedBox(height: 12),
          const _TextFieldBox(
              label: 'Message', hint: 'Type something...', maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Submitted ✨')),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF1DB2BD), // pastel teal
              foregroundColor: Colors.black87, // 👈 makes text and icon visible
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            label: const Text(
              'Send',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
