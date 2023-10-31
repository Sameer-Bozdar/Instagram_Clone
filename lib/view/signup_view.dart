import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_project/responsive/mobile_responsive_layout.dart';
import 'package:instagram_project/responsive/responsive_layout.dart';
import 'package:instagram_project/responsive/web_responsive_layout.dart';
import 'package:instagram_project/utils/global_variable.dart';
import 'package:instagram_project/utils/utils.dart';
import 'package:instagram_project/view/signin_view.dart';
import '../constants/custom_Round_button.dart';
import '../constants/custom_Textfield.dart';
import '../resources/auth.dart';
import '../utils/colors.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void initState() {
    // print(_emailController.text.toString());
    // TODO: implement initState
    super.initState();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupUser() async{
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signup(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    if(res != "success") {
      showSnackbar(res,context);
      setState(() {
        isLoading = false;
      });
    } else{
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResponsiveLayout(
         webscreenlayout: WebScreenLayout(),
         mobilescreenlayout: MobileScreenLayout(),
       )));
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
            padding: width > webScreenSize ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3): EdgeInsets.symmetric(horizontal: 25),
            // width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 1),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVoRlmXdh-WdDE4s4LFsOL1p05KKG8_ERrfqVFXaC57xgNLZFMMEqTmNJ8ltgGAYEdEwA&usqp=CAU'),
                            ),
                      Positioned(
                          left: 80,
                          bottom: -10,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.add_a_photo),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextFormField(
                    hinttext: 'Enter your username',
                    controller: _usernameController,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextFormField(
                    hinttext: 'Enter your Email',
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextFormField(
                    hinttext: 'Enter password',
                    controller: _passwordController,
                    obscure: true,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextFormField(
                    hinttext: 'Enter bio',
                    controller: _bioController,
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomRoundButton(
                      title: "Sign up",
                      onTap: signupUser,
                    isLoading: isLoading,
                  ),
                  // print({"$res this is the clicked function "});

                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Already have an account? ")),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInView()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Login',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ])));
  }
}
