import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';
import 'package:flutter_firebase_instagram/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({this.user});

  @override
  State<StatefulWidget> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = '';
  String _bio = '';
  String _profileImageUrl = '';

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    if (_profileImage != null) {
      _profileImageUrl = await StorageService.uploadProfileImage(
          widget.user.profileImageUrl, _profileImage);
    }

    User user = User(
        id: widget.user.id,
        name: _name,
        bio: _bio,
        profileImageUrl: _profileImageUrl);

    DatabaseService.updateUser(user);
    Navigator.pop(context);
  }

  _handelImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    //No new profile Image
    if (_profileImage == null) {
      // No profile user Image
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_paceholder.png');
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60.0,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                        onPressed: _handelImageFromGallery,
                        child: Text(
                          'Change Profile Image',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0),
                        )),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        labelText: 'Name',
                      ),
                      validator: (input) => input.trim().isEmpty
                          ? 'Please Enter a valied name'
                          : null,
                      onSaved: (input) => _name = input.trim(),
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30.0,
                        ),
                        labelText: 'Bio',
                      ),
                      validator: (input) => input.trim().length > 160
                          ? 'The bio must be less than 160 charactors'
                          : null,
                      onSaved: (input) => _bio = input.trim(),
                    ),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40.0,
                      width: 250.0,
                      child: FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: _submit,
                          child: Text(
                            'Save Profile',
                            style: TextStyle(fontSize: 18.0),
                          )),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
