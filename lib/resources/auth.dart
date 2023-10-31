import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_project/models/user_model.dart' as model;
import 'package:instagram_project/resources/storage_methods.dart';

class AuthMethods {




  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<model.User> getUserDetails()async{

    User currentUser = auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('User').doc(currentUser!.uid).get();

    return model.User.fromSnap(snap);

  }


  //sign up the user
  Future<String> signup({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl =
            await StorageMethods().uploadImage('profilePicure', file, false);

        // add user to our database

        model.User user = model.User(
            bio: bio,
            email: email,
            uid: cred.user!.uid,
            password: password,
            username: username,
            photoUrl: photoUrl,
            followers: [],
            following: []);

        await _firestore
            .collection('User')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
// logging in user

  Future<String> loginUser({required email, required password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "Email not registered";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> signout()async{
    await auth.signOut();
  }

}
