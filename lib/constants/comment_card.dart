import 'package:flutter/material.dart';
import 'package:instagram_project/constants/like_animation.dart';
import 'package:instagram_project/models/user_model.dart';
import 'package:instagram_project/provider/user_provider.dart';
import 'package:instagram_project/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}


class _CommentCardState extends State<CommentCard> {

  @override
  Widget build(BuildContext context) {
   final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: widget.snap['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${widget.snap['text']}')
                      ])),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w100),
                        ),
                      ),
                    ])),
          ),

          IconButton(onPressed: (){
    },
         icon: Icon(Icons.favorite_outline_rounded)
          )


        ],
      ),
    );
  }
}
