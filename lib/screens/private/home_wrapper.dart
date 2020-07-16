import 'package:Pub/screens/private/main/add_new_offer.dart';
import 'package:Pub/screens/private/main/home_screen.dart';
import 'package:Pub/screens/private/main/offer_screen.dart';
import 'package:Pub/screens/private/main/pub_screen.dart';
import 'package:Pub/screens/private/main/setting_screen.dart';
import 'package:Pub/services/staticdata/static_data_service.dart';
import 'package:Pub/widgets/pub_bottom_navigation_widget.dart';
import 'package:Pub/widgets/pub_dropdown_field.dart';
import 'package:flutter/material.dart';

class HomeWrapper extends StatefulWidget {
  final String uid;
  HomeWrapper({this.uid});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _curreentIndex;
  bool flag = false;
  int label = 0;
  bool isFreshOne = false;

  @override
  void initState() {
    _curreentIndex = 0;
    super.initState();
  }

  void _changeFlag(bool f) {
    setState(() {
      flag = f;
      isFreshOne = !isFreshOne;
    });
  }

  Widget _resolveBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen(uid: widget.uid);
        break;
      case 1:
        return PubScreen();
        break;
      case 2:
        return OfferScreen(
          shouldSave: shouldSaveOffer,
          uid: widget.uid,
        );
        break;
      case 3:
        return AddNewOffer(
          shouldSave: shouldSave,
          ss: _setShouldSaveToFalse,
          uid: widget.uid,
        );
        break;
      case 4:
        return SettingScreen();
        break;
      default:
        return HomeScreen();
    }
  }

  void resolveBodyIndex(int index) {
    setState(() {
      _curreentIndex = index;
      flag = false;
    });
  }

  void gotPushMessges(String title, String msgSource) {
    print('GGG BRB ' + msgSource);
  }

  bool shouldSave = false;
  bool shouldSaveOffer = false;

  _setShouldSaveToFalse() {
    setState(() {
      shouldSave = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puub'),
        actions: <Widget>[
          (_curreentIndex == 3 || _curreentIndex == 2)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (_curreentIndex == 2) {
                        setState(() {
                          shouldSaveOffer = true;
                        });
                      } else if (_curreentIndex == 3) {
                        setState(() {
                          shouldSave = true;
                        });
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            width: 20,
          )
        ],
        centerTitle: true,
        leading: flag
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _curreentIndex = 3;
                    label = 0;
                    isFreshOne = false;
                    flag = !flag;
                  });
                  //resolveBodyIndex(3);
                },
                child: Icon(
                  Icons.arrow_back,
                ),
              )
            : null,
      ),
      body: _resolveBody(_curreentIndex),
      bottomNavigationBar: PubBottomNavigationWidget(resolveBodyIndex),
    );
  }
}
