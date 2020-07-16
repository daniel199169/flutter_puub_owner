import 'package:Pub/services/staticdata/static_data_service.dart';
import 'package:Pub/widgets/pub_flat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardComponent extends StatefulWidget {
  final String uid;
  DashboardComponent({this.uid});
  @override
  _DashboardComponentState createState() => _DashboardComponentState();
}

String _getMonthString(int month) {
  switch (month) {
    case DateTime.january:
      return 'Jan';
      break;
    case DateTime.february:
      return 'Feb';
      break;
    case DateTime.march:
      return 'Mar';
      break;
    case DateTime.april:
      return 'Apr';
      break;
    case DateTime.may:
      return 'May';
      break;
    case DateTime.june:
      return 'Jun';
      break;
    case DateTime.july:
      return 'July';
      break;
    case DateTime.august:
      return 'Aug';
      break;
    case DateTime.september:
      return 'Sept';
      break;
    case DateTime.october:
      return 'Oct';
      break;
    case DateTime.november:
      return 'Nov';
      break;
    case DateTime.december:
      return 'Dec';
      break;
    default:
  }
}

class _DashboardComponentState extends State<DashboardComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Dashboard',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(DateTime.now().day.toString() +
                    ' ' +
                    _getMonthString(DateTime.now().month) +
                    ', ' +
                    DateTime.now().year.toString()),
              ],
            ),
          ),
          StreamBuilder(
              stream: Firestore.instance
                  .collection('pubs')
                  .where('ownerUID', isEqualTo: widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List dealList = snapshot.data.documents.length == 0
                    ? new List()
                    : snapshot.data.documents[0]['deals'];
                int allDeals = dealList.length;
                List activeDealList = new List();
                for (Map m in dealList) {
                  DateTime endDate = m['endTime'].toDate();

                  if (endDate.isAfter(DateTime.now())) {
                    m.putIfAbsent('imageURL',
                        () => snapshot.data.documents[0]['imageURL']);
                    m.putIfAbsent('name', () => m['label']);
                    m.putIfAbsent(
                        'address', () => snapshot.data.documents[0]['address']);
                    activeDealList.add(m);
                  }
                }
                int activeDeals = activeDealList.length;
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      for (Map map in StaticDataService.homeDashboardData)
                        _getHomeDashboardItem(
                            map['label'] == 'All Deals'
                                ? allDeals.toString()
                                : map['label'] == 'Active Deals'
                                    ? activeDeals.toString()
                                    : (allDeals - activeDeals).toString(),
                            map['label'],
                            map['backgroundColor'],
                            map['textColor']),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _getHomeDashboardItem(
      String count, String label, Color backgroundColor, Color textColor) {
    return Column(
      children: <Widget>[
        PubFlatButton(
          data: count,
          backgroundColor: backgroundColor,
          textColor: textColor,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text('$label'),
      ],
    );
  }
}
