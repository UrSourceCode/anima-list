import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    QuerySnapshot userQuerySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      return userQuerySnapshot.docs.first;
    }
    return null;
  }

  Future<DocumentSnapshot> getUserByUuid(String uid) async {
    DocumentSnapshot userDocSnapshot = await _db.collection('users').doc(uid).get();

    if (userDocSnapshot.exists) {
      return userDocSnapshot;
    }
    throw Exception('User not found with uid $uid');
  }

  Stream<DocumentSnapshot> getUserStreamByUuid(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  Future<void> updateUserPhotoUrl(String uid, String photoUrl) async {
    await _db.collection('users').doc(uid).update({
      'photoUrl': photoUrl,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> addUserToCollection(Users user, String uid) async {
    try {
      await _db.collection('users').doc(uid).set({
        'email': user.email,
        'username': user.username,
        'createdAt': user.createdAt,
        'updatedAt': user.updatedAt,
      });
    } catch (e) {
      throw Exception('Error adding user to collection: $e');
    }
  }


  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadImage(File image) async {
    try {
      final user = _auth.currentUser!;
      final storageRef = FirebaseStorage.instance.ref().child('user_photos/${user.uid}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await user.updatePhotoURL(downloadUrl);

      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }
}

// services/anime_service.dart
