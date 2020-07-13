import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  final int maxLength;
  final double height;
  final double width;
  final String labelText;
  final String hintText;
  final dynamic counterText;
  final dynamic keyboardType;
  final dynamic onChanged;

  TextFieldWidget(
      {@required this.controller,
      this.maxLines,
      this.counterText = '',
      this.height,
      this.width,
      this.labelText,
      this.hintText,
      this.maxLength,
      this.keyboardType,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      height: height,
      width: width,
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: counterText == null ? null : '',
          border: OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        autofocus: false,
      ),
    );
  }
}
