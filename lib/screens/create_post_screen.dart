import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/post_model.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:flutter_firebase_instagram/services/database_service.dart';
import 'package:flutter_firebase_instagram/services/storage_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatePostScreenState();
  }
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _imageFile;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _islooding = false;

  _showSelectImageDailog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidBottomSheet();
  }

  _iosBottomSheet() {
    return SimpleDialog(
      title: Text('Add Photo'),
      children: <Widget>[
        SimpleDialogOption(
          child: Text('Take Photo'),
          onPressed: () => _handleImage(ImageSource.camera),
        ),
        SimpleDialogOption(
          child: Text('Choose From Gallery'),
          onPressed: () => _handleImage(ImageSource.gallery),
        ),
        SimpleDialogOption(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  _androidBottomSheet() {
    print("object");
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () => _handleImage(ImageSource.camera),
                  child: Text('Take Photo')),
              CupertinoActionSheetAction(
                  onPressed: () => _handleImage(ImageSource.gallery),
                  child: Text('Choose From Gallery')),
            ],
            cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          );
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    return croppedImage;
  }
  _submit() async {
    if(!_islooding && _imageFile != null && _caption.trim().isNotEmpty){
      setState(() {
        _islooding = true;
      });

      //create post
      String imageUrl = await StorageService.uploadPostImage(context, _imageFile);
      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likes: {},
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      DatabaseService.createPost(post);

      //reset data
      _captionController.clear();
      setState(() {
        _caption = '';
        _imageFile = null;
        _islooding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Create Post',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: _submit)
          ],
        ),
        body: GestureDetector(                               //GestureDetector: on tap=> for when you tap background of view keyboard diapper
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: height,
              child: Column(
                children: <Widget>[
                  _islooding ? Padding(padding: EdgeInsets.only(bottom: 10.0), child: LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),)
                  : SizedBox.shrink(),
                  GestureDetector( 
                    onTap: _showSelectImageDailog,
                    child: Container(
                      width: width,
                      height: width,
                      color: Colors.grey[300],
                      child: _imageFile == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: Colors.white70,
                              size: 150.0,
                            )
                          : Image(
                              image: FileImage(_imageFile),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      controller: _captionController,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(labelText: 'Caption'),
                      onChanged: (input) => _caption = input,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
