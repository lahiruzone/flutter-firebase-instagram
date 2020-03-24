import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/services/auth_service.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignupScreen extends StatefulWidget {
  static final id = 'signup_screen';

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;
  ProgressDialog _prograssDailog;

  _showPrograssDailog() {
    _prograssDailog = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal, showLogs: false);
    _prograssDailog.style(message: 'Signing');
    _prograssDailog.show();
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _showPrograssDailog();
      _formKey.currentState.save();
      try {
        await AuthService.signUpUser(context, _name, _email, _password)
            .then((_) => _prograssDailog.dismiss());
      } catch (error) {
        _prograssDailog.dismiss();
        _showErrorDailog(error.message);
      }
    }
  }

  _showErrorDailog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Instagram",
                style: TextStyle(fontSize: 50.0, fontFamily: 'Billabong'),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (input) =>
                              input.trim().isEmpty ? 'Name required' : null,
                          onSaved: (input) => _name = input.trim(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (input) => !input.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => _email = input.trim(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (input) => input.trim().length < 6
                              ? 'Must be at least 6 characters'
                              : null,
                          onSaved: (input) => _password = input.trim(),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          padding: EdgeInsets.all(10.0),
                          color: Colors.blue,
                          child: Text(
                            'Signup',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 250.0,
                        child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.all(10.0),
                          color: Colors.blue,
                          child: Text(
                            'Back',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
