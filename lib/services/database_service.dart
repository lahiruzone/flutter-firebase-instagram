import 'package:flutter_firebase_instagram/models/user_model.dart';
import 'package:flutter_firebase_instagram/utilities/constant.dart';

class DatabaseService {
  static void updateUser(User user) async {
    userRef.document(user.id).updateData({
      'name': user.name,
      'bio': user.bio,
      'profileImageUrl': user.profileImageUrl,
    });
  }
}
