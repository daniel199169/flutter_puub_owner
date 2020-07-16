import 'package:Pub/widgets/pub_cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PubCard extends StatefulWidget {
  final Map data;
  PubCard({this.data});
  @override
  _PubCardState createState() => _PubCardState();
}

class _PubCardState extends State<PubCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.all(10.0),
      child: _getCardChild(context),
    );
  }

  Widget _getCardChild(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //Nothing as of now
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      child: Image.network(
                        widget.data['imageURL'][0],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            //Nothing to do as of now
                          },
                          child: new Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //Nothing to do as of now
                          },
                          child: new Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                    child: _getDescription(),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  _getFooter(),
                ],
              ),
            )
          ],
        ));
  }

  Widget _getFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.5),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Text('views'), Text('1234')],
            ),
            VerticalDivider(
              thickness: 2,
              indent: 2,
              endIndent: 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Uploaded Date'),
                Text(DateFormat('dd MMM, yyyy')
                    .format(widget.data['creationTime'].toDate()))
              ],
            ),
            VerticalDivider(
              thickness: 2,
              indent: 2,
              endIndent: 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Text('Expiry (Date)'), Text('20 March, 2020')],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDescription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < 3; i++) _getRows(i),
      ],
    );
  }

  Widget _getRows(int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          index == 0
              ? CircleAvatar(
                  backgroundImage: Image.network(
                    widget.data['imageURL'][0],
                    fit: BoxFit.contain,
                  ).image,
                  child: Text(' '),
                  radius: 7.0,
                )
              : index == 1
                  ? Icon(
                      Icons.room_service,
                      size: 14,
                    )
                  : Icon(
                      Icons.room,
                      size: 14,
                      color: Colors.grey,
                    ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            index == 0
                ? widget.data['name']
                : index == 1
                    ? widget.data['address']
                    : widget.data['description'],
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
