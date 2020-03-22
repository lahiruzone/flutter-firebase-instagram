import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_instagram/models/user_data.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadProfileImage(String url, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      //Updating user profile image
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
    }
    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadPostImage(BuildContext context, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    String userId = Provider.of<UserData>(context, listen: false).currentUserId;
    StorageUploadTask uploadTask = storageRef
        .child('images/posts/$userId/post_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir =
        await getTemporaryDirectory(); // using path provider pac => getTemporaryDirectory()
    final path = tempDir.path;
    File compressedImagefile = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, '$path/imag_$photoId.jpg',
        quality: 70);
    return compressedImagefile;
  }
}
