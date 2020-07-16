import 'package:Pub/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PubAuthFirestoreService {
  PubAuthFirestoreService({this.uid});
  final String uid;

  Firestore _firestore = Firestore();
  User _user;  

  addUser({
    @required String id,
    @required String title,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String phoneNumber,
    @required DateTime dob,
    @required bool enableMarketingEmail,
    String password,
  }) async {
    _user = User(
      title: title,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      password: password,
      phoneNumber: phoneNumber,
      id: id,
      enableMarketingEmail: enableMarketingEmail,
      type: 'owner',
    );
    try {
      await _firestore.collection('users').document(id).setData(_user.toJson());
      return true;
    } catch (e) {
      print('error ' + e.toString());
      return false;
    }
  }

  isUsernameEmailAddressExits({String email}) async {
    var _result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .where('type', isEqualTo: 'owner')
        .limit(1)
        .getDocuments();
    if (_result.documents.length > 0) {
      return "email already Exits";
    }
    return null;
  }

  Future<bool> isFacebookUserAlreadyExits({String id}) async {
    var _result = _firestore.collection('users').document(id);
    if (_result.documentID != null) {
      return true;
    }
    return false;
  }

  Stream<User> get pubHero {
    return _firestore
        .collection('users')
        .document(uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }
}