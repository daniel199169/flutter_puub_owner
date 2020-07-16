

import 'package:flutter/material.dart';

class User {
  String id;
  String title;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  DateTime dob;
  bool enableMarketingEmail;
  List<String> likedPub;
  String password;
  bool isDealOn;
  bool showInKm;
  String token;
  String type;

   User({
    @required this.id,
    @required this.title,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phoneNumber,
    @required this.dob,
    @required this.enableMarketingEmail,
    this.likedPub,
    this.password,
    this.isDealOn,
    this.showInKm,
    this.token,
    this.type,
  });

  factory User.fromMap(Map data) {
    data = data ?? {};
    return User(
      id: data['id'],
      type: data['type'] == null ? '' : data['type'],
      title: data['title'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      password: data['password'] == null ? '' : data['password'],
      dob: data['dob'].toDate(),
      enableMarketingEmail: data['enableMarketingEmail'] != null &&
              data['enableMarketingEmail'] == 'true'
          ? true
          : false,
      likedPub: data['likedPub'] == 'null'
          ? null
          : data['likedPub'].map<String>((data) {
              return data.toString();
            }).toList(),
      isDealOn: data['isDealOn'] == 'null' ? true : data['isDealOn'],
      showInKm: data['showInKm'] == 'null' ? true : data['showInKm'],
      token: data['token'] == 'null' ? null : data['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['title'] = this.title.trim();
    jsonUser['firstName'] = this.firstName.trim();
    jsonUser['lastName'] = this.lastName.trim();
    jsonUser['email'] = this.email.trim();
    jsonUser['type'] = this.type.trim();
    jsonUser['phoneNumber'] = this.phoneNumber.trim();
    jsonUser['dob'] = this.dob;
    jsonUser['enableMarketingEmail'] = this.enableMarketingEmail.toString();
    jsonUser['likedPub'] = this.likedPub.toString();
    jsonUser['password'] = this.password.toString();
    jsonUser['isDealOn'] = this.isDealOn.toString();
    jsonUser['showInKm'] = this.showInKm.toString();
    return jsonUser;
  }
}