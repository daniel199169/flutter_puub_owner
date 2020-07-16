import 'package:Pub/widgets/pub_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  final String leftText;
  final String rightText;
  final String uid;
  HomeSlider({this.leftText, this.rightText, this.uid});
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('pubs')
            .where('ownerUID', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No Pubs'),
            );
          }
          if (snapshot.hasData) {
            List dealList = snapshot.data.documents.length == 0
                ? new List()
                : snapshot.data.documents[0]['deals'];
            List activeDealList = new List();
            for (Map m in dealList) {
              DateTime endDate = m['endTime'].toDate();

              if (endDate.isAfter(DateTime.now())) {
                List dealImageList = new List();
                dealImageList.add(m['dealImageURL']);
                m.putIfAbsent('imageURL', () => dealImageList);
                m.putIfAbsent('name', () => m['label']);
                m.putIfAbsent(
                    'address', () => snapshot.data.documents[0]['address']);
                activeDealList.add(m);
              }
            }
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          activeDealList.length > 0 ? widget.leftText : '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            activeDealList.length > 1 ? widget.rightText : '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: activeDealList.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 10.0,
                        child: PubCard(
                          data: activeDealList[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text('No Deals'),
            );
          }
        });
  }
}
