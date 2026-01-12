import 'package:flutter_note/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rxn<UserModel> _userModel = Rxn<UserModel>();

  UserModel? get user => _userModel.value;

  set user(UserModel? value) => this._userModel.value = value;

  void clear() {
    _userModel.value = null;
  }
}
