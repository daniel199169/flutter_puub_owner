import 'dart:convert';

class FacebookUserModel {
  String id;
  String first_name;
  String last_name;
  DateTime birthday;

  FacebookUserModel({
    this.id,
    this.first_name,
    this.last_name,
    this.birthday,
  });

  factory FacebookUserModel.fromMap(Map data) {
    data = data ?? {};
    return FacebookUserModel(
      id: data['id'],
      first_name: data['first_name'],
      last_name: data['last_name'],
      birthday: data['birthday'],
    );
  }

  factory FacebookUserModel.fromString(String data) {
    var jsonMap = jsonDecode(data);
    jsonMap = jsonMap ?? {};
    String actualDate = jsonMap['birthday'].toString();
    actualDate = actualDate.replaceAll(new RegExp(r'\\'), '');
    List<String> datePart = actualDate.split('/');
    DateTime dt = new DateTime(
      int.parse(datePart[2]),
      int.parse(datePart[0]),
      int.parse(datePart[1]),
    );
    return FacebookUserModel(
      id: jsonMap['id'],
      first_name: jsonMap['first_name'],
      last_name: jsonMap['last_name'],
      birthday: dt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonUser = new Map<String, dynamic>();
    jsonUser['id'] = this.id.trim();
    jsonUser['first_name'] = this.first_name.trim();
    jsonUser['last_name'] = this.last_name.trim();
    jsonUser['birthday'] = this.birthday.toString();
    return jsonUser;
  }
}