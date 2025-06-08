import 'package:flutter/material.dart';

class DevTextFieldWidget extends StatelessWidget {
  final TextEditingController TextCtrl;
  final hint;
  final int maxLine;
  DevTextFieldWidget({
    required this.TextCtrl,
    required this.hint,
    this.maxLine = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
      ),
      maxLines: maxLine,
    );
  }
}
