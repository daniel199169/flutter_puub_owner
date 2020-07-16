import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticDataService {
  static const double CAMERA_TILT = 80;
  static const double CAMERA_BEARING = 30;
  static const double CAMERA_ZOOM = 15;

  static const List<Map> bottomAppBarItem = [
    {
      "text": "Home",
      "icon": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Pub",
      "icon": FaIcon(FontAwesomeIcons.bars),
    },
    {
      "text": "Offers",
      "icon": FaIcon(FontAwesomeIcons.salesforce),
    },
    {
      "text": "Add Pub",
      "icon": FaIcon(FontAwesomeIcons.addressBook),
    },
    {
      "text": "Settings",
      "icon": FaIcon(FontAwesomeIcons.toolbox),
    },
  ];

  static const List<Map> settingData = [
    {
      "text": "App Settings",
      "images": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Personal Details",
      "images": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Puub ID",
      "images": FaIcon(FontAwesomeIcons.calendarCheck),
    },
    {
      "text": "Saved Pubs",
      "images": FaIcon(FontAwesomeIcons.user),
    },
    {
      "text": "Terms and Conditions",
      "images": FaIcon(FontAwesomeIcons.user),
    },
  ];

  static const List<Map> verifyData = [
    {
      "label": "Cristiano Ronaldo",
      "isLink": false,
    },
    {
      "label": "Juventas",
      "isLink": false,
    },
    {
      "label": "Verified Until XXX",
      "isLink": false,
    },
    {
      "label": "Reverify now",
      "isLink": true,
    },
    {
      "label": "Change instituition",
      "isLink": true,
    },
  ];

  static const List<Map> days = [
    {
      "label": "Monday",
    },
    {
      "label": "Tuesday",
    },
    {
      "label": "Wednesday",
    },
    {
      "label": "Thursday",
    },
    {
      "label": "Friday",
    },
    {
      "label": "Saturday",
    },
    {
      "label": "Sunday",
    },
  ];

  static const List<Map> pubOfferAmenities = [
    {
      "label": "All",
    },
    {
      "label": "Monday",
    },
    {
      "label": "Tuesday",
    },
    {
      "label": "Wednesday",
    },
    {
      "label": "Thursday",
    },
    {
      "label": "Friday",
    },
    {
      "label": "Saturday",
    },
    {
      "label": "Sunday",
    },
  ];

  static const List<Map> pubAmenities = [
    {
      "label": "Wifi",
    },
    {
      "label": "Garden",
    },
    {
      "label": "Covered smoking area",
    },
    {
      "label": "Sky Sports",
    },
    {
      "label": "BR Sports",
    },
    {
      "label": "Food",
    },
    {
      "label": "Darts",
    },
    {
      "label": "Snooker/Pool",
    },
  ];

  static const List<String> menuItem = [
    "12:00 Night",
    "01:00 am",
    "02:00 am",
    "03:00 am",
    "04:00 am",
    "05:00 am",
    "06:00 am",
    "07:00 am",
    "08:00 am",
    "09:00 am",
    "04:00 pm",
    "05:00 pm",
    "06:00 pm",
    "07:00 pm",
    "08:00 pm",
    "09:00 pm",
    "10:00 pm",
  ];

  static const List<Map> homeDashboardData = [
    {
      "count": "18",
      "label": 'All Deals',
      "backgroundColor": Color.fromRGBO(255, 230, 215, 1),
      "textColor": Colors.deepOrange,
    },
    {
      "count": "15",
      "label": 'Active Deals',
      "backgroundColor": Color.fromRGBO(203, 238, 238, 1),
      "textColor": Colors.blue,
    },
    {
      "count": "03",
      "label": 'Expired Deals',
      "backgroundColor": Color.fromRGBO(246, 206, 206, 1),
      "textColor": Colors.red,
    },
  ];

  static const String TWITTER_KEY = 'IfcWffzMiS2aa0fcG2uOFxPLu';
  static const String TWITTER_SECRET =
      'VG9lDtIjkmXuBSRN3mlRbB5IpmASnwtpw71eULIPaqu5zcLRnk';

  static const String INSTAGRAM_KEY = '576649349662433';
  static const String INSTAGRAM_SECRET = '34686202ba0cb7c20ec701c49ffae839';

  static const LatLng kLake = LatLng(37.43296265331129, -122.08832357078792);

  static const List<Map> appSettings = [
    {
      "text": "Alert if walk near pub with deal on",
      "type": 'switch',
    },
    {
      "text": "Display in miles or km",
      "type": 'switch',
    },
    {
      "text": 'Verify as "Student"',
      "type": 'normal',
    },
    {
      "text": 'Verify as "NHS"',
      "type": 'normal',
    },
    {
      "text": 'Verify as "Forces"',
      "type": 'normal',
    },
  ];

  static const List<Map> categoryData = [
    {
      "text": "Puub Deal near me",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Top Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Beer Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Cider Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Wine Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Spirits Deals",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "Favourite Pubs",
      "images": 'assets/images/cat.jpeg',
    },
    {
      "text": "All Deals",
      "images": 'assets/images/cat.jpeg',
    },
  ];
}
