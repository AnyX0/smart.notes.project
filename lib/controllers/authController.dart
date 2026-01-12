import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note/controllers/userController.dart';
import 'package:flutter_note/models/user.dart';
import 'package:flutter_note/services/database.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();

  Rxn<User> get firebaseUser => _firebaseUser;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String usersCollection = "users";
  Rxn<UserModel> userModel = Rxn<UserModel>();
  Rx<int> axisCount = 2.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, (User? firebaseUser) {
      if (firebaseUser != null) {
        print("Fetching user data for UID: ${firebaseUser.uid}");
        Database().getUser(firebaseUser.uid).then((userModel) {
          print("Fetched user: ${userModel.name}, ${userModel.email}");
          Get.find<UserController>().user = userModel;
        }).catchError((e) {
          print("Error fetching user: $e");
        });
      } else {
        print("User logged out, clearing user data");
        Get.find<UserController>().clear();
      }
    });
    super.onInit();
  }

  void createUser() async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      final uid = credential.user?.uid;
      if (uid == null) return;
      UserModel _user = UserModel(
        id: uid,
        name: name.text,
        email: email.text,
      );
      final created = await Database().createNewUser(_user);
      if (created) {
        Get.find<UserController>().user = _user;
        Get.back();
        _clearControllers();
      }
    } catch (e) {
      final msg = e is FirebaseAuthException
          ? (e.message ?? e.toString())
          : e.toString();
      Get.snackbar(
        'Error creating account',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void login() async {
    try {
      print("IN logging in email ${email.text} password ${password.text}");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      final uid = userCredential.user?.uid;
      if (uid != null) {
        try {
          Get.find<UserController>().user = await Database().getUser(uid);
        } catch (e) {
          // If user document doesn't exist, create it
          UserModel _user = UserModel(
            id: uid,
            name: '', // Will be empty since we don't have name from auth
            email: userCredential.user?.email ?? '',
          );
          await Database().createNewUser(_user);
          Get.find<UserController>().user = _user;
        }
      }
      _clearControllers();
    } catch (e) {
      final msg = e is FirebaseAuthException
          ? (e.message ?? e.toString())
          : e.toString();
      Get.snackbar(
        'Error logging in',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signout() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().user = null;
    } catch (e) {
      final msg = e is FirebaseAuthException
          ? (e.message ?? e.toString())
          : e.toString();
      Get.snackbar(
        'Error signing out',
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }
}
