import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pub {
  String pubName;
  List<String> pubImageURL;
  String pubFirstAddressLine;
  String pubTown;
  String pubPostCode;
  LatLng pubLocation;
  Map<String, Map<String, String>> openingHours;
  String descriptionOfPub;
  Map<String, bool> pubAmenities;
  String ownerUID;
  List<Map> deals;
  DateTime creationTime;

  Pub({
    this.pubName,
    this.pubImageURL,
    this.pubFirstAddressLine,
    this.pubTown,
    this.pubPostCode,
    this.pubLocation,
    this.openingHours,
    this.descriptionOfPub,
    this.pubAmenities,
    this.ownerUID,
    this.deals,
    this.creationTime,
  });

  factory Pub.fromMap(Map data) {
    data = data ?? {};
    return Pub(
        pubName: data['name'],
        pubImageURL:
            data['imageURL'] == null ? new List() : data['imageURL'].toList(),
        pubFirstAddressLine: data['address']
        //pubTown:
        );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonPub = new Map<String, dynamic>();
    //jsonPub['id'] = this.id.trim();
    jsonPub['name'] = this.pubName.trim();
    jsonPub['address'] = this.pubFirstAddressLine.trim();
    jsonPub['phoneNumber'] = null;
    jsonPub['latitute'] = this.pubLocation.latitude.toString();
    jsonPub['longitude'] = this.pubLocation.longitude.toString();
    jsonPub['imageURL'] = this.pubImageURL;
    jsonPub['deals'] = this.deals == null ? new List() : this.deals;
    jsonPub['description'] = this.descriptionOfPub;
    jsonPub['openingHours'] = this.openingHours;
    jsonPub['pubAmenities'] = this.pubAmenities;
    jsonPub['ownerUID'] = this.ownerUID;
    jsonPub['creationTime'] = this.creationTime;

    return jsonPub;
  }
}
