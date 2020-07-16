
import 'package:Pub/services/authentication/pub_auth_service.dart';
import 'package:Pub/widgets/pub_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  final Function stateChange;
  LoginScreen({this.stateChange});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  PubAuthService authService = PubAuthService();
bool _isLoading = false;
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        children: <Widget>[
          Container(
            //child: SingleChildScrollView(
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
                    'Sign in to continue',
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
            // ),
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
    );
  }

  void _onSaved(String value, String label) {
    if (label.isNotEmpty) {
      if (label == "Email") {
        _email = value;
      } else if (label == "Password") {
        _password = value;
      } else {
        // Should not be here!!
      }
    } else {
      // Should not be here
    }
  }

  String _fieldValidator(String value) {
    if (value.isEmpty) {
      return "Mandatory Field";
    }
    return null;
  }

  Widget _getFormSection(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
            isSecret: true,
            maxLine: 1,
            labelText: "Password",
            onSaved: (String value) {
              _onSaved(value, 'Password');
            },
            validator: _fieldValidator,
          ),
          CheckboxListTile(
            title: Text("Remember Me"),
            value: true,
            onChanged: null,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("Login"),
              onPressed: _proceed,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.twitter),
                  onPressed: () {
                    print("Pressed");
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
          ),
          GestureDetector(
            onTap: () {
              widget.stateChange(false);
            },
            child: Text('Not signed up?'),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _proceed() {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }
    _loginFormKey.currentState.save();
    authService.loginWithEmailAndPassword(email: _email, password: _password);
  }
}
