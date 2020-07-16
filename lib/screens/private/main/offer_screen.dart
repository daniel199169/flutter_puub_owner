import 'dart:io';

import 'package:Pub/models/category.dart';
import 'package:Pub/models/deal.dart';
import 'package:Pub/services/staticdata/static_data_service.dart';
import 'package:Pub/services/storageservice/pub_firestore_storage_service.dart';
import 'package:Pub/widgets/pub_cached_network_image.dart';
import 'package:Pub/widgets/pub_dropdown_field.dart';
import 'package:Pub/widgets/pub_text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  final bool shouldSave;
  final String uid;
  OfferScreen({this.shouldSave, this.uid});
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  DateTime _expiryDate, _startDate;
  String _expiry, _start;
  List<Category> cataList = [];
  String _selectedCategory = null;
  TextEditingController _offerTitleController,
      _descriptionOfOfferController,
      _expiryController,
      _startController;
  String _offerName, _offerDescription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _dropdownError = false;
  String _selectedParentID;
  File _image;
  bool _isImageUploaded = true;

  @override
  void initState() {
    _offerTitleController = new TextEditingController();
    _descriptionOfOfferController = new TextEditingController();
    _expiryController = new TextEditingController();
    _startController = new TextEditingController();
    for (int k = 0; k < StaticDataService.pubOfferAmenities.length; k++) {
      amenityList.add(false);
      amenityGroupList.add(null);
    }
    super.initState();
  }

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      switch (label) {
        case 'Offer Title':
          _offerName = value;
          break;
        case 'Description of Offer':
          _offerDescription = value;
          break;
        case 'Expiry':
          //_offerDescription = value;
          break;
        default:
      }
    }
  }

  String _onValidate(String value, String label) {
    if (value.isEmpty) {
      if (label == 'Offer Title') {
        return "Offer Title can not be empty.";
      } else if (label == 'Description of Offer') {
        return "Description of Offer can not be empty.";
      } else if (label == 'Expiry') {
        return "Expiry date of Offer can not be empty.";
      } else if (label == 'Starts From') {
        return "Start date of Offer can not be empty.";
      }
    } else if (value.isNotEmpty) {
      if (label == 'Offer Title') {
        if (value.length > 30) {
          return "Offer Title can not exceeds 30 charecters.";
        }
      } else if (label == 'Description of Offer') {
        if (value.length > 500) {
          return "Offer Title can not exceeds 500 charecters.";
        }
      }
    }
    return null;
  }

  _saveImagesIfAny() async {
    if (_image != null) {
      setState(() {
        _isImageUploaded = true;
      });
      final storage =
          Provider.of<PubFirestoreStorageService>(context, listen: false);
      final downloadUrlList = await storage.uploadDealImages(file: _image);
      setState(() {
        _dealImageURL = downloadUrlList;
      });
    }
  }

  bool _extraValidation() {
    if (_image == null) {
      setState(() {
        _isImageUploaded = false;
        isLoading = false;
      });
      return false;
    }

    if (_selectedCategory == null) {
      print('No dropdown');
      setState(() {
        _dropdownError = true;
        isLoading = false;
      });
      return false;
    } else {
      setState(() {
        _dropdownError = false;
      });
      //return
    }

    if (_startDate != null) {
      if (!_startDate.isBefore(_expiryDate)) {
        setState(() {
          _isStartDateError = true;
          isLoading = false;
        });
        return false;
      }
    }
    return true;
  }

  String _dealImageURL;
  bool isLoading = false;
  bool flu = false;
  bool _isSubmitted = false;
  bool _isStartDateError = false;
  saveToFirebase() async {
    print('saveToFirebase');
    setState(() {
      isLoading = true;
    });

    //validate start and experiy

    await _saveImagesIfAny();

    Map<String, bool> map = _buildPubOfferAmenityMap();
    String parentID = _findParentID();
    Deal deal = new Deal(
      description: _descriptionOfOfferController.text,
      label: _offerName,
      pubAmenity: map,
      endTime: _expiryDate,
      startTime: _startDate,
      creationTime: DateTime.now(),
      parentID: parentID,
      dealImageURL: _dealImageURL,
    );

    final qs = await Firestore.instance
        .collection('pubs')
        .where('ownerUID', isEqualTo: widget.uid)
        .getDocuments();
    final ds = qs.documents.first;
    List existingDeals = ds.data['deals'] ?? new List();
    String documentID = ds.documentID;
    existingDeals.add({
      'label': deal.label,
      'description': deal.description,
      'pubAmenity': deal.pubAmenity,
      'parentID': deal.parentID,
      'startTime': deal.startTime,
      'endTime': deal.endTime,
      'creationTime': deal.creationTime,
      'dealImageURL': deal.dealImageURL,
    });
    await Firestore.instance
        .collection('pubs')
        .document(documentID)
        .updateData({'deals': existingDeals});
    setState(() {
      isLoading = false;
      _image = null;
      _dealImageURL = null;
      _expiryDate = null;
      _expiry = null;
      _start = null;
      _startDate = null;
      _selectedCategory = null;
      _offerTitleController = new TextEditingController();
      _descriptionOfOfferController = new TextEditingController();
      _startController = new TextEditingController();
      _expiryController = new TextEditingController();
      _isSubmitted = false;
      _isStartDateError = false;
    });
    _resetAmenity();
  }

  void _resetAmenity() {
    for (int i = 0; i < amenityList.length; i++) {
      amenityList[i] = false;
    }
  }

  String _findParentID() {
    for (Category c in cataList) {
      if (c.category == _selectedCategory) {
        return c.parentID;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _offerTitleController.dispose();
    _descriptionOfOfferController.dispose();
    if (_formKey.currentState != null) {
      _formKey.currentState.dispose();
    }

    super.dispose();
  }

  _getImageFromCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  _getImageFromGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    print('KKKK');
    if (widget.shouldSave && !isLoading) {
      print('KKKK2');
      if (_formKey.currentState != null) {
        print('KKKK3');
        if (_formKey.currentState.validate()) {
          bool _isExtraValidated = _extraValidation();
          print('KKKK4 ' + _isSubmitted.toString());
          if (!_isSubmitted && _isExtraValidated) {
            _formKey.currentState.save();
            saveToFirebase();
          }
        } else {}
      }

      //widget.changeShouldSave();
    }
    return Stack(
      children: <Widget>[
        Container(
          child: Center(
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
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: GestureDetector(
                              onTap: () {
                                _showDialog(context);
                              },
                              child: Card(
                                elevation: 4.0,
                                color: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: _image == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.file_upload,
                                              color: Colors.black54,
                                            ),
                                            Text(
                                              'Upload Deal Image',
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            child: Image.file(
                                              _image,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          _image == null && !_isImageUploaded
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'You must upload a deal image',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      PubTextField(
                        controller: _offerTitleController,
                        isSecret: false,
                        labelText: 'Offer Title',
                        onSaved: (String value) {
                          _onSaved(value, 'Offer Title');
                        },
                        validator: (String value) {
                          return _onValidate(value, 'Offer Title');
                        },
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '(Limit 30 charecters)',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 6,
                        controller: _descriptionOfOfferController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "Description of Offer",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (String value) {
                          return _onValidate(value, 'Description of Offer');
                        },
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '(Limit 500 charecters)',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('deals')
                            .where('parentID', isEqualTo: "0")
                            .orderBy('id')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          } else {
                            cataList = new List<Category>();
                            for (int k = 0;
                                k < snapshot.data.documents.length;
                                k++) {
                              cataList.add(new Category(
                                  category: snapshot.data.documents[k]['label'],
                                  parentID: snapshot.data.documents[k]['id']));
                            }
                            return PubDropdownField(
                              shouldShowError: _dropdownError,
                              menuItem: _getCatList(cataList),
                              onChanged: (String v) {
                                //print('v '+v);
                                setState(() {
                                  _selectedCategory = v;
                                });
                              },
                              selectedMenu: _selectedCategory,
                              hint: 'Category',
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _startController,
                            readOnly: true,
                            decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              labelText: "Starts From",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 12.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onTap: () async {
                              final datePick = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate == null
                                      ? new DateTime.now()
                                      : _startDate,
                                  firstDate: new DateTime.now(),
                                  lastDate:
                                      new DateTime(DateTime.now().year + 1));
                              if (datePick != null && datePick != _startDate) {
                                setState(() {
                                  _startDate = datePick;
                                  _start =
                                      "${_startDate.day}/${_startDate.month}/${_startDate.year}";
                                  _startController.text = _start;
                                });
                              }
                            },
                            onSaved: (String value) {
                              _onSaved(value, 'Starts From');
                            },
                            validator: (String value) {
                              return _onValidate(value, 'Starts From');
                            },
                          ),
                          _isStartDateError
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Start date must be before expiry date',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _expiryController,
                        readOnly: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "Expiry",
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 12.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onTap: () async {
                          final datePick = await showDatePicker(
                              context: context,
                              initialDate: _expiryDate == null
                                  ? new DateTime.now()
                                  : _expiryDate,
                              firstDate: new DateTime.now(),
                              lastDate: new DateTime(DateTime.now().year + 1));
                          if (datePick != null && datePick != _expiryDate) {
                            setState(() {
                              _expiryDate = datePick;
                              _expiry =
                                  "${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}";
                              _expiryController.text = _expiry;
                            });
                          }
                        },
                        onSaved: (String value) {
                          _onSaved(value, 'Expiry');
                        },
                        validator: (String value) {
                          return _onValidate(value, 'Expiry');
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Pub Amenities',
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
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  List<String> _getCatList(List<Category> catList) {
    List<String> st = new List();
    for (Category c in catList) {
      st.add(c.category);
    }
    return st;
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

  Map<String, bool> _buildPubOfferAmenityMap() {
    Map<String, bool> myMap = new Map();
    for (int i = 0; i < StaticDataService.pubOfferAmenities.length; i++) {
      myMap.putIfAbsent(StaticDataService.pubOfferAmenities[i]['label'],
          () => amenityList[i]);
    }
    return myMap;
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
                          bool u = amenityList[i + j];
                          if ((i + j) == 0) {
                            for (int k = 0;
                                k < StaticDataService.pubOfferAmenities.length;
                                k++) {
                              if (u) {
                                amenityList[k] = false;
                              } else {
                                amenityList[k] = true;
                              }
                            }
                          } else {
                            amenityList[i + j] = !amenityList[i + j];
                          }
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
                      StaticDataService.pubOfferAmenities[i + j]['label'],
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
}
