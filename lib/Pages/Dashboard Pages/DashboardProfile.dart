import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/UserProfileController.dart';
import '../../Services/StorageService.dart';
import '../../Services/UserDBService.dart';

class DashboardProfile extends StatelessWidget {
  final UserProfileController userProfileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 150,
                width: Get.context.width,
                color: Colors.indigo.withOpacity(0.05),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error ${snapshot.error}");
                    }
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Text("No data");
                    }
                    if (snapshot.hasData) {
                      var doc = snapshot.data;
                      // print(doc.id);
                      var name = doc.get("userinfo.name");
                      var phoneno = doc.get("userinfo.phoneno");
                      var photourl = doc.get("userinfo.photourl");
                      return userProfileHeader(
                          imageurl: photourl,
                          mobilenumber: phoneno,
                          name: name);
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                )),
          )
        ],
      ),
    );
  }

  userProfileHeader({String imageurl, String name, String mobilenumber}) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: buildProfileImage(imageurl),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: GoogleFonts.cairo(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              mobilenumber,
              style: GoogleFonts.cairo(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: ElevatedButton(
                onPressed: () async {
                  Get.offAllNamed("/");
                },
                child: Text("Sign Out"),
              )),
        ),
      ],
    );
  }

  Container buildProfileImage(String imageurl) {
    return !imageurl.isBlank
        ? Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    imageurl,
                  ),
                )),
            child: Stack(
              children: [buildEditIcon()],
            ), // color: Colors.blue),
          )
        : Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.blueGrey.shade100),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: FlutterLogo(
                    size: 90,
                  ),
                ),
                buildEditIcon()
              ],
            ),
          );
  }

  buildEditIcon() {
    return Positioned(
      right: -10,
      bottom: 0,
      child: IconButton(
        onPressed: () async {
          var originalimagepath = await pickaimage();
          var userid = FirebaseAuth.instance.currentUser.uid;
          if (!originalimagepath.isBlank) {
            var compressimagepath =
                await compressImage(imagepath: originalimagepath);

            if (!compressimagepath.isBlank) {
              var imageurl = await uploadUserProfileImage(
                  userid: userid, path: compressimagepath);
              var isupdated =
                  await UserDBService().updateProfileImage(imageurl: imageurl);
              if (isupdated) {
                Get.snackbar("Profile Updated Successfully", "");
              } else {
                Get.snackbar("Failed to update profile", "");
              }
            } else {
              Get.snackbar("Compress image path is blank", "");
            }
          }
        },
        icon: Icon(
          Icons.add_a_photo_outlined,
          color: Colors.amber,
        ),
      ),
    );
  }
}
