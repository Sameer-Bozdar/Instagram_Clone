import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_project/view/add_post_screen.dart';
import 'package:instagram_project/view/feed_screen.dart';
import 'package:instagram_project/view/profile_view.dart';
import 'package:instagram_project/view/search_view.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItem = [
  FeedScreen(),
  SearchView(),
  AddPostScreen(),
  Text('favourite'),
  ProfileView(uid: FirebaseAuth.instance.currentUser!.uid)
];