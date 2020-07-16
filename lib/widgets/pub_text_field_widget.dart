import 'package:flutter/material.dart';

class PubTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isSecret;
  final String labelText;
  final int maxLine;
  final Function validator;
  final Function onSaved;
  PubTextField({
    this.controller,
    this.isSecret,
    this.labelText,
    this.maxLine,
    this.validator,
    this.onSaved,
  });
  @override
  _PubTextFieldState createState() => _PubTextFieldState();
}

class _PubTextFieldState extends State<PubTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autofocus: false,
        maxLines: widget.maxLine,
        controller: widget.controller,
        validator: widget.validator,
        onSaved: widget.onSaved,
        obscureText: widget.isSecret,
        decoration: InputDecoration(
          labelText: widget.labelText,
          fillColor: Colors.grey[200],
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            /*borderSide: BorderSide(
              width: 0,
            ),*/
          ),
        ),
      ),
    );
  }
}
