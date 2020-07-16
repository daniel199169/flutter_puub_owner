import 'package:Pub/services/authentication/pub_auth_service.dart';
import 'package:Pub/widgets/pub_dropdown_field.dart';
import 'package:Pub/widgets/pub_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  final Function stateChange;
  RegisterScreen({this.stateChange});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> menuItems;
  PubAuthService authService = PubAuthService();
  final _dobController = TextEditingController();
  DateTime _birthDate;
  bool _isLoading = false;

  String _dob;

  String _title, _firstName, _lastName, _email, _phoneNumber, _password;

  @override
  void initState() {
    _initiateMenu();
    super.initState();
  }

  void _initiateMenu() {
    setState(() {
      menuItems = new List();
      menuItems.add("Mr");
      menuItems.add("Mrs");
      menuItems.add("Ms");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Welcome To Puub',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Sign Up to continue',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _getFormSection(context),
                ],
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  String _fieldValidator(String value) {
    if (value.isEmpty) {
      return "Mandatory Field";
    }
    return null;
  }

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      if (label == "Title") {
        _title = value;
      } else if (label == "First Name") {
        _firstName = value;
      } else if (label == "Last Name") {
        _lastName = value;
      } else if (label == "Email") {
        _email = value;
      } else if (label == "Phonenumber") {
        _phoneNumber = value;
      } else if (label == "Password") {
        _password = value;
      } else if (label == "DOB") {
        _password = value;
      } else {
        // Should not be here!!
      }
    } else {
      // Should not be here
    }
  }

  void _proceed() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print('_title ');
    print('_firstName ' + _firstName);
    print('_lastName ' + _lastName);
    print('_email ' + _email);
    print('_password ' + _password);
    authService.registerUser(
      title: 'Mr.',
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      phoneNumber: _phoneNumber,
      dob: _birthDate,
      password: _password,
      enableMarketingEmail: true,
    );
  }

  Widget _getFormSection(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PubDropdownField(
            menuItem: menuItems,
            onChanged: (String v) {
              setState(() {
                //selectedMenu = v;
              });
            },
            selectedMenu: "Mr",
          ),
          Row(
            children: <Widget>[
              new Flexible(
                child: PubTextField(
                  controller: null,
                  isSecret: false,
                  maxLine: 1,
                  labelText: "First Name",
                  onSaved: (String value) {
                    _onSaved(value, 'First Name');
                  },
                  validator: _fieldValidator,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              new Flexible(
                child: PubTextField(
                  controller: null,
                  isSecret: false,
                  maxLine: 1,
                  labelText: "Last Name",
                  onSaved: (String value) {
                    _onSaved(value, 'Last Name');
                  },
                  validator: _fieldValidator,
                ),
              ),
            ],
          ),
          PubTextField(
            controller: null,
            isSecret: false,

                  maxLine: 1,
            labelText: "Email",
            onSaved: (String value) {
              _onSaved(value, 'Email');
            },
            validator: _fieldValidator,
          ),
          PubTextField(
            controller: null,
            isSecret: false,

                  maxLine: 1,
            labelText: "Phonenumber",
            onSaved: (String value) {
              _onSaved(value, 'Phonenumber');
            },
            validator: _fieldValidator,
          ),
          TextFormField(
            controller: _dobController,
            readOnly: true,
            
            decoration: InputDecoration(
              labelText: "Date of Birth",
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
                  initialDate:
                      _birthDate == null ? new DateTime.now() : _birthDate,
                  firstDate: new DateTime(1900),
                  lastDate: new DateTime.now());
              if (datePick != null && datePick != _birthDate) {
                setState(() {
                  _birthDate = datePick;
                  _dob =
                      "${_birthDate.day}/${_birthDate.month}/${_birthDate.year}";
                  _dobController.text = _dob;
                });
              }
            },
            onSaved: (String value) {
              _onSaved(value, 'DOB');
            },
            validator: _fieldValidator,
          ),
          PubTextField(
            controller: null,
            maxLine: 1,
            isSecret: true,
            labelText: "Password",
            onSaved: (String value) {
              _onSaved(value, 'Password');
            },
            validator: _fieldValidator,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: CheckboxListTile(
                  title: Text("Term & Condition"),
                  value: true,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              new Flexible(
                fit: FlexFit.tight,
                child: CheckboxListTile(
                  title: Text("Marketing Emails"),
                  value: true,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("Login"),
              onPressed: _proceed,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: FaIcon(FontAwesomeIcons.twitter),
                onPressed: () async {
                  await authService.twitterLogin();
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.facebook),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await authService.facebookLogin();
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.instagram),
                onPressed: () {
                  print("Pressed");
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              widget.stateChange(true);
            },
            child: Text('Already Signed Up?'),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
