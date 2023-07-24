import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageServices {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // save user image cloud storage
  static Future<String> saveUserImage(File image, String userImage) async {
    final Reference storageReference =
        _firebaseStorage.ref().child('userImage/$userImage');
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static Future<String> saveFiles(File image, String string) async {
    final Reference storageReference =
        _firebaseStorage.ref().child('images/$image');
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static Future<String> saveCertificate(File certificate, String id) async {
    final Reference storageReference =
        _firebaseStorage.ref().child('certificates/$id');
    final UploadTask uploadTask = storageReference.putFile(certificate);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static Future<String> sendFile(File file, String id) async {
    final Reference storageReference = _firebaseStorage
        .ref()
        .child('files/$id${DateTime.now().microsecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(file);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
