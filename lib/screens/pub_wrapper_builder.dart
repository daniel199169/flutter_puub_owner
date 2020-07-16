import 'package:Pub/services/authentication/pub_auth_service.dart';
import 'package:Pub/services/dbservice/pub_auth_firestore_service.dart';
import 'package:Pub/services/storageservice/pub_firestore_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PubWrapperBuilder extends StatelessWidget {
  const PubWrapperBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<FirebaseUser>) builder;
  @override
  Widget build(BuildContext context) {
    print('PuubWrapper rebuild');
    final authService = Provider.of<PubAuthService>(context, listen: false);
    return StreamBuilder<FirebaseUser>(
      stream: authService.user,
      builder: (context, snapshot) {
        print('StreamBuilder: ${snapshot.connectionState}');
        final FirebaseUser user = snapshot.data;

        if (user != null) {
          return MultiProvider(
            providers: [
              Provider<FirebaseUser>.value(value: user),
              Provider<PubAuthFirestoreService>(
                create: (_) => PubAuthFirestoreService(uid: user.uid),
              ),
              Provider<PubFirestoreStorageService>(
                create: (_) => PubFirestoreStorageService(uid: user.uid),
              ),
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}