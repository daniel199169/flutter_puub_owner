import 'package:Pub/services/staticdata/static_data_service.dart';
import 'package:Pub/widgets/pub_dropdown_field.dart';
import 'package:flutter/material.dart';

class PubBottomSheetWidget extends StatefulWidget {
  PubBottomSheetWidget({
    @required this.switchValue,
    this.startTime,
    this.endTime,
    this.onDome,
  });
  final bool switchValue;
  final String startTime;
  final String endTime;
  final Function onDome;
  @override
  _PubBottomSheetWidgetState createState() => _PubBottomSheetWidgetState();
}

class _PubBottomSheetWidgetState extends State<PubBottomSheetWidget> {
  bool _sameOpeningHourForEveryDay = false;
  String _startTime = '09:00 am';
  String _endTime = '06:00 pm';
  @override
  void initState() {
    _sameOpeningHourForEveryDay = widget.switchValue != null
        ? widget.switchValue
        : _sameOpeningHourForEveryDay;

    _startTime = widget.startTime != null ? widget.startTime : _startTime;
    _endTime = widget.startTime != null ? widget.endTime : _endTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * 0.33,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Please enter your Timing'),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: PubDropdownField(
                    menuItem: StaticDataService.menuItem,
                    onChanged: (String v) {
                      setState(() {
                        _startTime = v;
                      });
                    },
                    selectedMenu: _startTime,
                    shouldShowError: false,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: PubDropdownField(
                    menuItem: StaticDataService.menuItem,
                    onChanged: (String v) {
                      setState(() {
                        _endTime = v;
                      });
                    },
                    selectedMenu: _endTime,
                    shouldShowError: false,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Checkbox(
                    checkColor: Colors.white,
                    value: _sameOpeningHourForEveryDay,
                    onChanged: (bool value) {
                      setState(() {
                        _sameOpeningHourForEveryDay = value;
                        //widget.valueChanged(value);
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  Text('Same opening hour'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    focusColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    //color: Theme.of(context).primaryColor,
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Map m = new Map();
                      m.putIfAbsent('sameOpeningHourForEveryDay',
                          () => _sameOpeningHourForEveryDay);
                      m.putIfAbsent('startTime', () => _startTime);
                      m.putIfAbsent('endTime', () => _endTime);
                      widget.onDome(m);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
