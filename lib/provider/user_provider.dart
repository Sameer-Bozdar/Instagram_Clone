
import 'package:flutter/cupertino.dart';
import 'package:instagram_project/models/user_model.dart';
import 'package:instagram_project/resources/auth.dart';

class UserProvider with ChangeNotifier{

  final AuthMethods _authMethods = AuthMethods();

  User? _user;
  User get getUser => _user!;

  Future<void> refreshUser()async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }


}