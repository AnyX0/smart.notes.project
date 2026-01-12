import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note/controllers/authController.dart';
import 'package:flutter_note/models/noteModel.dart';
import 'package:flutter_note/services/database.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  RxList<NoteModel> noteList = RxList<NoteModel>();
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> bodyController = TextEditingController().obs;

  // ignore: invalid_use_of_protected_member
  List<NoteModel> get notes => noteList.value;

  @override
  void onInit() {
    final auth = Get.find<AuthController>();
    final String? uid = auth.user?.uid;
    print("NoteController onInit :: $uid");
    if (uid != null) {
      noteList.bindStream(Database().noteStream(uid).handleError((error) {
        print("Error in noteStream: $error");
      }));
    }
    ever<User?>(auth.firebaseUser, (user) {
      final newUid = user?.uid;
      print("Auth user changed in NoteController :: $newUid");
      if (newUid != null) {
        noteList.bindStream(Database().noteStream(newUid).handleError((error) {
          print("Error in noteStream: $error");
        }));
      } else {
        noteList.clear();
      }
    });
    super.onInit();
  }
}
