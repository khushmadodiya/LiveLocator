import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final controller;
  final ispass;
  final hint;
  final isform;
  const InputText({super.key, required this.controller, this.ispass=false, required this.hint, this.isform=false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: isform ? 1:null,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      obscureText: ispass ? true : false,
      onSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
