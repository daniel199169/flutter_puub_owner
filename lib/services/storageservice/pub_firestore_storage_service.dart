import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PubFirestoreStorageService {
  PubFirestoreStorageService({@required this.uid}) : assert(uid != null);
  final String uid;

  /// Upload an avatar from file
  Future<String> uploadAvatar({
    @required File file,
  }) async =>
      await upload(
        file: file,
        path: 'avatar/$uid' + '/avatar.png',
        contentType: 'image/png',
      );
  Future<String> upload({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(
        file, StorageMetadata(contentType: contentType));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }

  //Upload Pub Image
  Future<List<String>> uploadPubImages({
    @required List<File> file,
  }) async =>
      await uploadPub(
        file: file,
        path: 'pubimages/$uid',
        contentType: 'image/png',
      );
  Future<List<String>> uploadPub({
    @required List<File> file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    StorageReference storageReference;
    StorageUploadTask uploadTask;
    List<String> downLoadURLList = new List();
    for (int i = 0; i < file.length; i++) {
      storageReference = FirebaseStorage.instance
          .ref()
          .child(path + '/' + (i + 1).toString() + '.png');
      uploadTask = storageReference.putFile(
          file[i], StorageMetadata(contentType: contentType));
      final snapshot = await uploadTask.onComplete;
      if (snapshot.error != null) {
        print('upload error code: ${snapshot.error}');
        throw snapshot.error;
      }
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('downloadUrl: $downloadUrl');
      downLoadURLList.add(downloadUrl);
    }

    return downLoadURLList;
  }

  //Upload Pub Image
  Future<String> uploadDealImages({
    @required File file,
  }) async =>
      await uploadDeal(
        file: file,
        path: 'pubimages/$uid/dealimages/',
        contentType: 'image/png',
      );
  Future<String> uploadDeal({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path+DateTime.now().millisecondsSinceEpoch.toString()+'.png');
    final uploadTask = storageReference.putFile(
        file, StorageMetadata(contentType: contentType));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
