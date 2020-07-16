import 'package:flutter/material.dart';

class PubDropdownField extends StatefulWidget {
  final String selectedMenu;
  final String hint;
  final List<String> menuItem;
  final Function onChanged;
  final bool shouldShowError;

  PubDropdownField({
    this.selectedMenu,
    this.hint,
    this.menuItem,
    this.onChanged,
    this.shouldShowError,
  });
  @override
  _PubDropdownFieldState createState() => _PubDropdownFieldState();
}

class _PubDropdownFieldState extends State<PubDropdownField> {
  @override
  Widget build(BuildContext context) {
    print('Selected ' + widget.selectedMenu.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            child: new DropdownButton<String>(
              isExpanded: true,
              underline: Container(),
              value: widget.selectedMenu != null ? widget.selectedMenu : null,
              onChanged: widget.onChanged,
              hint: widget.hint == null ? Text('Title') : Text(widget.hint),
              items: widget.menuItem.map((String label) {
                return new DropdownMenuItem<String>(
                  value: label,
                  child: new Text(
                    label,
                  ),
                );
              }).toList(),
            ),
          ),
          widget.shouldShowError
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'You must select a category',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
