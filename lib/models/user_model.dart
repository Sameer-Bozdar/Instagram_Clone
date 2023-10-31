import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String uid;
  final String password;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  User(
      {required this.username,
      required this.email,
      required this.uid,
      required this.password,
      required this.bio,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {

    'username': username,
    'email': email,
    'uid': uid,
    'password': password,
    'bio': bio,
    'photoUrl': photoUrl,
    'followers': [],
    'following': []
  };


  static User fromSnap(DocumentSnapshot snap){

    var snapshot = snap.data() as Map<String, dynamic>;

     return User(username: snapshot['username'],
         email: snapshot['email'],
         uid: snapshot['uid'],
         password: snapshot['password'],
         bio: snapshot['bio'],
         photoUrl: snapshot['photoUrl'],
         followers: snapshot['followers'],
         following: snapshot['following']
     );

  }

}
