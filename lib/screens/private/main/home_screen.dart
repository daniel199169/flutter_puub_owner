import 'package:Pub/screens/private/section/dashboard_component.dart';
import 'package:Pub/screens/private/section/home_slider.dart';
import 'package:Pub/widgets/pub_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  HomeScreen({this.uid});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DashboardComponent(
                uid: widget.uid,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My Pub',
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
                          '',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        if (snapshot.data.documents.isNotEmpty) {
                          return Container(
                            height: 250.0,
                            width: MediaQuery.of(context).size.width,
                            child: PubCard(
                              data: snapshot.data.documents.first.data,
                            ),
                          );
                        }
                      } else {}
                    }

                    return Center(
                      child: Text('No Pubs'),
                    );
                    //print('snapshot ' + snapshot.data.documents[0]['ownerUID']);
                  }),
              SizedBox(
                height: 10,
              ),
              HomeSlider(
                leftText: 'Active Deals',
                rightText: 'See All->',
                uid: widget.uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
