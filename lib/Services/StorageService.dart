import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

File _image;
final picker = ImagePicker();
FirebaseStorage storage = FirebaseStorage.instance;
final categorystorage = storage.ref("/category");
//
///
////
Future<String> pickaimage() async {
  var filepath = "";
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    _image = File(pickedFile.path);
    print("Original image size ${filesize(_image.lengthSync())}");
    filepath = pickedFile.path;
  } else
    print("no image selected");
  return filepath;
}

Future<String> compressImage({String imagepath}) async {
  var compressedimagepath = "";
  CompressObject compressObject = CompressObject(
    imageFile: File(imagepath), //image
    path: (await getTemporaryDirectory()).path, //compress to path
    quality: 85, //first compress quality, default 80
    step:
        9, //compress quality step, The bigger the fast, Smaller is more accurate, default 6
    mode: CompressMode.LARGE2SMALL, //default AUTO
  );
  await Luban.compressImage(compressObject).then((_path) {
    compressedimagepath = _path;
  }).onError((error, stackTrace) {
    Get.snackbar("Compress Failed", "Eroor $error");
  });
  print(
      "Compressed file image size ${filesize(File(compressedimagepath).lengthSync())}");
  return compressedimagepath;
}

Future<String> uploadUserProfileImage({String userid, String path}) async {
  var profileurl = "";
  var fileextension = p.extension(path);
  var storageref = FirebaseStorage.instance
      .ref()
      .child("Users")
      .child("$userid")
      .child(userid + fileextension);
  await storageref.putFile(File(path));

  profileurl = await storageref.getDownloadURL();
  return profileurl;
}
