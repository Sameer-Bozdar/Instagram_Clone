import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String description;
  final String uid;
  final String username;
  final String postid;
  final dynamic datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  PostModel(
      {required this.username,
        required this.description,
        required this.uid,
        required this.postid,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
        required this.likes});

  Map<String, dynamic> toJson() => {

    'username': username,
    'description': description,
    'uid': uid,
    'postid': postid,
    'datePublished': datePublished,
    'postUrl': postUrl,
    'profImage': profImage,
    'likes' : likes
  };


  static PostModel fromSnap(DocumentSnapshot snap){

    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
        username: snapshot['username'],
        description: snapshot['description'],
        uid: snapshot['uid'],
        postid: snapshot['postid'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes']
    );

  }

}
