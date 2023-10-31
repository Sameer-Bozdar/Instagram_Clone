import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_project/constants/follow_button.dart';
import 'package:instagram_project/resources/auth.dart';
import 'package:instagram_project/resources/firestore_methods.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:instagram_project/utils/utils.dart';
import 'package:instagram_project/view/signin_view.dart';

class ProfileView extends StatefulWidget {
  final uid;
  const ProfileView({super.key, required this.uid});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.uid)
          .get();
      // getting the post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
      height: 25,
          width: 25,
          child: Center(
            child: CircularProgressIndicator(
            ),
          ),
        )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postLen, "posts"),
                                    buildStateColumn(followers, "followers"),
                                    buildStateColumn(following, "following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            textColor: primaryColor,
                                            function: () async{
                                              await AuthMethods().signout();
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignInView(),),);
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                textColor: Colors.black,
                                                function: () async{
                                                 await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid,
                                                      userData['uid']);
                                                 setState(() {
                                                   isFollowing = false;
                                                   followers--;
                                                 });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.white,
                                                textColor: Colors.blue,
                                                function: () async{
                                                  await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid,
                                                      userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },

                                              )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 10,
                  thickness: 1.0,
                ),
                FutureBuilder(future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
                    builder: (context, snapshot){
                  return GridView.builder(
                    shrinkWrap:  true,
                      itemCount: (snapshot.data as dynamic).docs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1
                      ),
                      itemBuilder: (context, index){
                      DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                    return Container(
                      child: Image(image: NetworkImage(
                          snap['postUrl']
                      ),
                      fit: BoxFit.cover,),
                    );
                      });
                    })
              ],
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ))
      ],
    );
  }
}
