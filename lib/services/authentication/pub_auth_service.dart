import 'package:Pub/models/facebook_user_model.dart';
import 'package:Pub/models/user_model.dart';
import 'package:Pub/services/dbservice/pub_auth_firestore_service.dart';
import 'package:Pub/services/staticdata/static_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:http/http.dart' as http;

class PubAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = FacebookLogin();

  updateDealOnRadio(bool val, String uid) async {
    print('UID ' + uid);
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'isDealOn': val});
  }

  updateMessagingToken(String token, String uid) async {
    print('UID ' + uid);
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'token': token});
  }

  updateShowInKmRadio(bool val, String uid) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'showInKm': val});
  }

  twitterLogin() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: StaticDataService.TWITTER_KEY,
      consumerSecret: StaticDataService.TWITTER_SECRET,
    );

    final TwitterLoginResult result = await twitterLogin.authorize();
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        TwitterSession session = result.session;
        print('USERNAME ' + session.username);
        break;
      case TwitterLoginStatus.cancelledByUser:
        print('cancelled by user');
        break;
      case TwitterLoginStatus.error:
        print('Some error is there ' + result.errorMessage);
        break;
    }
  }

  facebookLogin() async {
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('token ${accessToken.token}');
        print('userId ${accessToken.userId}');
        print('expires ${accessToken.expires}');
        print('permissions ${accessToken.permissions}');
        print('declinedPermissions ${accessToken.declinedPermissions}');
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=id,first_name,last_name,birthday&access_token=${accessToken.token}');
        print(graphResponse.body);
        final credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        FacebookUserModel fbUser =
            FacebookUserModel.fromString(graphResponse.body);
        if (fbUser.id != null) {
          PubAuthFirestoreService _fireStoreData =
              PubAuthFirestoreService(uid: null);
          final AuthResult _result =
              await _auth.signInWithCredential(credential);

          if (_result.user.uid != null) {
            final bool flag = await _fireStoreData.isFacebookUserAlreadyExits(
                id: _result.user.uid);
            print('flag ' + flag.toString());
            if (!flag) {
              await _fireStoreData.addUser(
                id: _result.user.uid,
                title: '',
                firstName: fbUser.first_name,
                lastName: fbUser.last_name,
                email: '',
                phoneNumber: '',
                password: '',
                dob: fbUser.birthday,
                enableMarketingEmail: false,
              );
            }
          }
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<User> _getUser(String id) async {
    print('JJJ3');
    return await getCurrentUser(id);
  }

  Future<User> getCurrentUser(String uid) async {
    final _result =
        await Firestore.instance.collection('users').document(uid).get();
    print('_result.documentID ' + _result.documentID.toString());
    final data = _result.data;
    return User.fromMap(data);
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map((event) {
      return event;
    });
  }

  Future registerUser({
    @required String title,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String phoneNumber,
    @required DateTime dob,
    @required String password,
    @required bool enableMarketingEmail,
  }) async {
    try {
      final PubAuthFirestoreService _fireStoreData =
          PubAuthFirestoreService(uid: null);
      final _isuserExits =
          await _fireStoreData.isUsernameEmailAddressExits(email: email);
      print('_isuserExits ' + _isuserExits.toString());
      if (_isuserExits == null) {
        print('Hello');
        AuthResult _result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        print('_result ' + _result.user.uid);
        if (_result.user.uid != null) {
          await _fireStoreData.addUser(
            id: _result.user.uid,
            title: title,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            dob: dob,
            enableMarketingEmail: enableMarketingEmail,
          );
        }
        return null;
      } else {
        print('He');
        return _isuserExits;
      }
    } catch (e) {
      print('error ' + e.toString());
      return null;
    }
  }

  Future<bool> loginWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (_result.user.uid != null) {
        return true;
      }
      return false;
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  Future<bool> forgotPassword({
    String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Sign Out Code
  facebookLogout() async {
    await _facebookLogin.logOut();
  }

  Future signOut() async {
    try {
      final bool isFacebookeLoggedIn = await _facebookLogin.isLoggedIn;
      if (isFacebookeLoggedIn) {
        await _facebookLogin.logOut();
      }
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
