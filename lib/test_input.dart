import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: TextFormField(
        decoration: InputDecoration(
          error: Transform.translate(
            offset: const Offset(-16, 0),
            child: const Text('Exceeds balance', style: TextStyle(color: Colors.red)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ));
}
