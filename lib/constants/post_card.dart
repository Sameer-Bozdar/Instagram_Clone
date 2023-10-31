import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_project/constants/like_animation.dart';
import 'package:instagram_project/models/user_model.dart';
import 'package:instagram_project/provider/user_provider.dart';
import 'package:instagram_project/resources/firestore_methods.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:instagram_project/utils/global_variable.dart';
import 'package:instagram_project/utils/utils.dart';
import 'package:instagram_project/view/comment_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

bool isLikeAnimating = false;
int commentLen = 0;

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    getComments();
    // TODO: implement initState
    super.initState();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: width > webScreenSize ? secondaryColor : mobileBackgroundColor
          ),
        color: mobileBackgroundColor
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map((e) => InkWell(
                                          onTap: () {
                                             FirestoreMethods().deletePost(
                                                widget.snap['postid']);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList())));
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(widget.snap['postid'],
                  widget.snap['uid'], widget.snap['likes']);

              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 120,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    }),
              )
            ]),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                onEnd: () {},
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postid'],
                          widget.snap['uid'], widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border)),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommentScreen(
                              snap: widget.snap,
                            )));
                  },
                  icon: Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      "${widget.snap['likes'].length} likes",
                      style: Theme.of(context).textTheme.bodyText2,
                    )),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${widget.snap['description']}'),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all ${commentLen} commments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '12-10-2023'
                    // DateFormat.yMMMd().toString()
                    // snap['datePublished']
                    ,
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
