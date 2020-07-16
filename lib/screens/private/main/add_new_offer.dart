import 'dart:io';
import 'dart:async';
import 'package:Pub/models/pub.dart';
import 'package:Pub/services/authentication/pub_auth_service.dart';
import 'package:Pub/services/pub_camera_service.dart';
import 'package:Pub/services/staticdata/static_data_service.dart';
import 'package:Pub/services/storageservice/pub_firestore_storage_service.dart';
import 'package:Pub/widgets/pub_bottom_sheet_widget.dart';
import 'package:Pub/widgets/pub_dropdown_field.dart';
import 'package:Pub/widgets/pub_text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AddNewOffer extends StatefulWidget {
  final bool shouldSave;
  final Function ss;
  final String uid;
  AddNewOffer({this.shouldSave, this.ss, this.uid}) {
    print('shouldSave ' + shouldSave.toString());
  }
  @override
  _AddNewOfferState createState() => _AddNewOfferState();
}

class _AddNewOfferState extends State<AddNewOffer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Asset> images = List<Asset>();
  Map<String, Map<String, String>> _openingHours = new Map();
  Map<String, String> endPair;
  bool _sameOpeningHourForEveryDay = false;
  @override
  void initState() {
    _pubNameController = new TextEditingController();
    _firstLaneAddressController = new TextEditingController();
    _townController = new TextEditingController();
    _postcodeController = new TextEditingController();
    _pubDescriptionController = new TextEditingController();
    for (int k = 0; k < StaticDataService.pubAmenities.length; k++) {
      amenityList.add(false);
      amenityGroupList.add(null);
    }
    super.initState();
  }

  Future<void> loadAssets() async {
    print('Hello');
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print('Error ' + e.toString());
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    setState(() {
      images = resultList;
      //_error = error;
    });
  }

  void shouldShowBottomScreen(BuildContext context, String day) {
    showBottomSheet(
      context: context,
      elevation: 4.0,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext bc) {
        return PubBottomSheetWidget(
          switchValue: null,
          startTime: null,
          endTime: null,
          onDome: (value) {
            setState(() {
              if (_openingHours.containsKey(day)) {
                endPair = new Map();
                endPair.putIfAbsent('startTime', () => value['startTime']);
                endPair.putIfAbsent('endTime', () => value['endTime']);
                _openingHours.update(day, (value) => endPair);
              } else {
                endPair = new Map();
                endPair.putIfAbsent('startTime', () => value['startTime']);
                endPair.putIfAbsent('endTime', () => value['endTime']);
                _openingHours.putIfAbsent(day, () => endPair);
              }
            });

            print('Heyyy ' + value.toString());
          },
        );
      },
    );
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: (() {
                      _getImageFromGallery(context);
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: (() {
                      _getImageFromCamera(context);
                    }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<File> _imageList = new List();

  _getImageFromCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageList.add(image);
    });
    Navigator.of(context).pop();
  }

  _getImageFromGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageList.add(image);
    });
    Navigator.of(context).pop();
  }

  TextEditingController _pubNameController,
      _firstLaneAddressController,
      _townController,
      _postcodeController,
      _pubDescriptionController;
  String _pubName, _firstLaneAddress, _town, _postcode, _pubDescription;

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      switch (label) {
        case 'Pub name':
          _pubName = value;
          break;
        case '1st Address Line':
          _firstLaneAddress = value;
          break;
        case 'Town':
          _town = value;
          break;
        case 'Postcode':
          _postcode = value;
          break;
        case 'Description of pub':
          _pubDescription = value;
          break;
        default:
      }
    }
  }

  String _onValidate(String value, String label) {
    if (value.isEmpty) {
      if (label == 'Pub name') {
        return "Pub name can not be empty.";
      } else if (label == '1st Address Line') {
        return "1st Address Line can not be empty.";
      } else if (label == 'Town') {
        return "Town can not be empty.";
      } else if (label == 'Postcode') {
        return "Postcode can not be empty.";
      } else if (label == 'Description of pub') {
        return "Description of pub can not be empty.";
      }
    }
    return null;
  }

  List<String> imageFileURLList = new List();

  _saveImagesIfAny() async {
    if (_imageList.length > 0) {
      final storage =
          Provider.of<PubFirestoreStorageService>(context, listen: false);
      final downloadUrlList = await storage.uploadPubImages(file: _imageList);
      setState(() {
        imageFileURLList = downloadUrlList;
      });
    }
  }

  Map<String, bool> _buildPubAmenityMap() {
    Map<String, bool> myMap = new Map();
    for (int i = 0; i < StaticDataService.pubAmenities.length; i++) {
      myMap.putIfAbsent(
          StaticDataService.pubAmenities[i]['label'], () => amenityList[i]);
    }
    return myMap;
  }

  saveToFirebase() async {
    setState(() {
      isLoading = true;
    });
    print('Starting upload');
    await _saveImagesIfAny();
    print('upload done');

    Pub pub = new Pub(
      pubName: _pubName,
      pubFirstAddressLine: _firstLaneAddress,
      pubTown: _town,
      pubPostCode: _postcode,
      descriptionOfPub: _pubDescription,
      pubLocation: new LatLng(33.33, 27.04),
      openingHours: _openingHours,
      pubAmenities: _buildPubAmenityMap(),
      pubImageURL: imageFileURLList,
      ownerUID: widget.uid,
      creationTime: DateTime.now(),
    );
    print('Staerting upload');
    await Firestore.instance.collection('pubs').add(pub.toJson());
    print('Staer444ting upload');
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = false;
  bool flu = false;

  @override
  void dispose() {
    _pubNameController.dispose();
    _firstLaneAddressController.dispose();

    _townController.dispose();
    _postcodeController.dispose();
    _pubDescriptionController.dispose();
    if (_formKey.currentState != null) {
      _formKey.currentState.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('object ' + widget.shouldSave.toString());
    if (widget.shouldSave && !isLoading) {
      print('object 1 ' + widget.shouldSave.toString());
      if (_formKey.currentState != null) {
        if (!_formKey.currentState.validate()) {
        } else {
          //widget.ss();
          if (!flu) {
            setState(() {
              flu = true;
            });
            _formKey.currentState.save();
            saveToFirebase();
          }
        }
      }

      //widget.changeShouldSave();
    }
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Add New Pub',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      PubTextField(
                        controller: _pubNameController,
                        isSecret: false,
                        labelText: 'Pub name',
                        onSaved: (String value) {
                          _onSaved(value, 'Pub name');
                        },
                        validator: (String value) {
                          return _onValidate(value, 'Pub name');
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Attach Pub Images',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              _showDialog(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: MediaQuery.of(context).size.width * 0.06,
                              height: MediaQuery.of(context).size.width * 0.06,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Card(
                          borderOnForeground: true,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                for (int i = 0; i < _imageList.length; i++)
                                  _getImageBlock(context, i, _imageList[i]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PubTextField(
                        controller: _firstLaneAddressController,
                        isSecret: false,
                        labelText: '1st Address Line',
                        onSaved: (String value) {
                          _onSaved(value, '1st Address Line');
                        },
                        validator: (String value) {
                          return _onValidate(value, '1st Address Line');
                        },
                      ),
                      Row(
                        children: <Widget>[
                          new Flexible(
                            child: PubTextField(
                              controller: _townController,
                              isSecret: false,
                              labelText: "Town",
                              onSaved: (String value) {
                                _onSaved(value, 'Town');
                              },
                              validator: (String value) {
                                return _onValidate(value, 'Town');
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          new Flexible(
                            child: PubTextField(
                              controller: _postcodeController,
                              isSecret: false,
                              labelText: "Postcode",
                              onSaved: (String value) {
                                _onSaved(value, 'Postcode');
                              },
                              validator: (String value) {
                                return _onValidate(value, 'Postcode');
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: null,
                        validator: null,
                        onSaved: null,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Set Location on Map',
                          isDense: true,
                          fillColor: Colors.grey[200],
                          filled: true,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: () async {
                                LocationResult result =
                                    await showLocationPicker(
                                  context,
                                  'apikey',
                                  initialCenter: LatLng(31.1975844, 29.9598339),
                                  myLocationButtonEnabled: true,
                                  layersButtonEnabled: true,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                width: MediaQuery.of(context).size.width * 0.01,
                                height:
                                    MediaQuery.of(context).size.width * 0.01,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Opening Hours of Pub',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('(Monday to Sunday Select Hours)')
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (int i = 0;
                              i < StaticDataService.days.length;
                              i++)
                            _getOpeningHour(
                                context, StaticDataService.days[i]['label']),
                        ],
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: _pubDescriptionController,
                        validator: (String value) {
                          return _onValidate(value, 'Description of pub');
                        },
                        onSaved: (String value) {
                          _onSaved(value, 'Description of pub');
                        },
                        obscureText: false,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description of pub',
                          isDense: true,
                          fillColor: Colors.grey[200],
                          filled: true,
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('(Limit 500 Charecter)'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Pub Amenities:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _getPubAmenities(context),
                      Divider(
                        thickness: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  int extraImageCount = 0;

  Widget _getImageBlock(BuildContext context, int index, File image) {
    if (_imageList.length > 4) {
      setState(() {
        extraImageCount = _imageList.length - 4;
      });
    }
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        index <= 3
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: SizedBox(
                    height: 260,
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        index <= 3
                            ? Image.file(
                                image,
                                fit: BoxFit.fill,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
        index == 3
            ? Positioned(
                top: 20,
                left: 20,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        (extraImageCount != 0)
                            ? '+' + extraImageCount.toString()
                            : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (extraImageCount != 0) ? 'more' : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  TableRow _getTableRow(BuildContext context, int i) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      children: [
        for (int j = 0; j < 2; j++)
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Align(
              alignment: Alignment.topLeft,
              heightFactor: 1.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      highlightColor: Theme.of(context).primaryColor,
                      onTap: () {
                        setState(() {
                          amenityList[i + j] = !amenityList[i + j];
                        });
                      },
                      radius: 8,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                            ),
                            shape: BoxShape.circle,
                            color: amenityList[i + j]
                                ? Theme.of(context).primaryColor
                                : Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: amenityList[i + j]
                              ? Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.check_circle_outline,
                                  size: 14,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      StaticDataService.pubAmenities[i + j]['label'],
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<bool> amenityList = new List();
  List<String> amenityGroupList = new List();
  bool selected = false;
  Widget _getPubAmenities(BuildContext context) {
    return Table(
      children: [
        for (int i = 0; i < StaticDataService.pubAmenities.length; i = i + 2)
          _getTableRow(context, i),
      ],
    );
  }

  Map<String, bool> _dayCheck = new Map();

  Widget _getOpeningHour(BuildContext context, String textMsh) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                value: _dayCheck[textMsh] == null ? false : _dayCheck[textMsh],
                onChanged: (value) {
                  if (_dayCheck[textMsh] == null) {
                    setState(() {
                      _dayCheck.putIfAbsent(textMsh, () => value);
                    });
                  } else {
                    setState(() {
                      _dayCheck.update(
                        textMsh,
                        (existingValue) => value,
                      );
                    });
                  }
                },
                activeColor: Theme.of(context).primaryColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              Text(textMsh),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_dayCheck[textMsh] != null && _dayCheck[textMsh]) {
              shouldShowBottomScreen(context, textMsh);
            }
          },
          child: Text(
            _openingHours.containsKey(textMsh)
                ? _getOpeningText(textMsh)
                : 'Set Time',
            style: TextStyle(
                color: (_dayCheck[textMsh] != null && _dayCheck[textMsh])
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _getOpeningText(String dat) {
    Map myPair;
    for (MapEntry mapEntry in _openingHours.entries) {
      if (mapEntry.key == dat) {
        myPair = mapEntry.value;
        break;
      }
    }
    return "${myPair['startTime']} to ${myPair['endTime']}";
  }
}
