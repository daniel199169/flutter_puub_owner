import 'package:Pub/models/user_model.dart';
import 'package:Pub/screens/private/home_wrapper.dart';
import 'package:Pub/screens/public/welcome_screen.dart';
import 'package:Pub/services/dbservice/pub_auth_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PubWrapper extends StatelessWidget {
  const PubWrapper({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<FirebaseUser> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot == null) {
      
      return WelcomeScreen();
    } else if(userSnapshot.connectionState == ConnectionState.active && userSnapshot.data == null){
      return WelcomeScreen();
    }else if (userSnapshot.connectionState == ConnectionState.active) {
      final userService =
          Provider.of<PubAuthFirestoreService>(context, listen: false);
      return StreamBuilder<User>(
        stream: userService.pubHero,
        builder: (context, snapshot) {
          return userSnapshot.hasData ? HomeWrapper(uid: userSnapshot.data.uid,) : WelcomeScreen();
        },
      );
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}