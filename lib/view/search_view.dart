import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:instagram_project/view/profile_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

TextEditingController searchController = TextEditingController();
bool isShowing = false;

class _SearchViewState extends State<SearchView> {
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(labelText: 'Search for a user'),
            onFieldSubmitted: (String _) {
              print(_);
              setState(() {
                isShowing = true;
              });
            },
          ),
        ),
        body: isShowing
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('User')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileView(
                          uid: (snapshot.data as dynamic).docs![0]['uid'],
                        ),
                      ),
                    ),
                    child: ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data as dynamic).docs[index]
                                        ['photoUrl']),
                              ),
                              title: Text((snapshot.data! as dynamic)
                                  .docs[index]['username']));
                        }),
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return MasonryGridView.builder(
                    itemCount: (snapshot.data as dynamic).docs.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Image.network(
                          (snapshot.data as dynamic).docs[index]['postUrl']),
                    ),
                  );
                }));
  }
}
