import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_project/models/post_model.dart';
import 'package:instagram_project/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String username, String profileImage,
      String description, Uint8List file, String uid) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImage('postImage', file, true);
      String postid = Uuid().v1();

      PostModel post = PostModel(
          username: username,
          description: description,
          uid: uid,
          postid: postid,
          datePublished: DateTime.now().toString(),
          postUrl: photoUrl,
          profImage: profileImage,
          likes: []);

      _firestore.collection('posts').doc(postid).set(post.toJson());
      return res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    if (likes.contains(uid)) {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    String res = '';
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('User').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('User').doc().update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('User').doc().update({
          'following': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('User').doc().update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('User').doc().update({
          'following': FieldValue.arrayRemove([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
