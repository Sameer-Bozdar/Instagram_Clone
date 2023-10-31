import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_project/models/user_model.dart';
import 'package:instagram_project/provider/user_provider.dart';
import 'package:instagram_project/resources/auth.dart';
import 'package:instagram_project/resources/firestore_methods.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:instagram_project/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isloading = false;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _descriptioncontroller = TextEditingController();

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isloading = true;
    });

    try {
      String res = await FirestoreMethods().uploadPost(
          username, profImage, _descriptioncontroller.text, _file!, uid);

      if (res == "success") {
        clearImage();
        setState(() {
          _isloading = false;
        });

        showSnackbar('Posted!', context);
      } else {
        setState(() {
          _isloading = false;
        });

        showSnackbar(res, context);
      }
    } catch (err) {
      showSnackbar(err.toString(), context);
    }
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  _selectedImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(title: Text('Create a Post'), children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            )
          ]);
        });
  }

@override
  void dispose() {
    // TODO: implement dispose
  _descriptioncontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: Container(
              child: IconButton(
                onPressed: () => _selectedImage(context),
                icon: Icon(Icons.upload),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => clearImage,
                ),
                title: const Text('Post to'),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed:() =>  postImage(user.uid,user.username,user.photoUrl),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                            color: blueColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ))
                ]),
            body: Column(
              children: [

                _isloading ? LinearProgressIndicator() : Padding(padding: EdgeInsets.only(top: 0)),const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptioncontroller,
                        decoration: InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                )
              ],
            ),
          );
  }
}
