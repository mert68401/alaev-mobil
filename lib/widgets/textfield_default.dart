import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  final int maxLength;
  final double height;
  final String labelText;
  final dynamic counterText;

  TextFieldWidget(
      {@required this.controller,
      this.maxLines,
      this.counterText = '',
      this.height,
      this.labelText,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 7),
      height: height,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: 35,
        decoration: InputDecoration(
          counterText: counterText == null ? null : '',
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        autofocus: false,
      ),
    );
  }
}
