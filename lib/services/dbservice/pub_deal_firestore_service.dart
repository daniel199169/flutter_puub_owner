import 'package:Pub/models/deal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PubDealFirestoreService {
  Firestore _firestore = Firestore();

  Stream<List<Deal>> get rootDeals {
    
    /*return _firestore.collection('deals')
            .where('parentID', isEqualTo: "0")
            .orderBy('id')
            .snapshots();*/
    /*return _firestore
        .collection('users')
        .document(uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));*/
  }
}