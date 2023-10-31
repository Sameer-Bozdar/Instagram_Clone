import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_project/resources/auth.dart';
import 'package:instagram_project/responsive/mobile_responsive_layout.dart';
import 'package:instagram_project/responsive/responsive_layout.dart';
import 'package:instagram_project/responsive/web_responsive_layout.dart';
import 'package:instagram_project/utils/global_variable.dart';
import 'package:instagram_project/utils/utils.dart';
import 'package:instagram_project/view/signup_view.dart';
import '../constants/custom_Round_button.dart';
import '../constants/custom_Textfield.dart';
import '../utils/colors.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false ;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
void loginUser()async{
    setState(() {
      isLoading = true;
    });
    String res =await  AuthMethods().loginUser(email: emailController.text, password: passwordController.text);

    if(res == "success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ResponsiveLayout(
        webscreenlayout: WebScreenLayout(),
        mobilescreenlayout: MobileScreenLayout(),
      )));
      setState(() {
        isLoading = false;
      });
      //
    }else{
      showSnackbar(res, context);
      setState(() {
        isLoading = false;
      });
    }


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /3) : const EdgeInsets.symmetric(horizontal: 25),
            // width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Flexible(child: Container(), flex: 2),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              CustomTextFormField(
                hinttext: 'Enter Email',
                controller: emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 27,
              ),
              CustomTextFormField(
                hinttext: 'Enter Password',
                controller: passwordController,
                obscure: true,
                inputType: TextInputType.text,
              ),
              const SizedBox(
                height: 40,
              ),
              CustomRoundButton(
                title: "Signin",
                onTap: loginUser,
                isLoading: isLoading,
              ),

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
                      child: const Text("Don't have any account?")),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context,MaterialPageRoute(builder: (context)=> SignUpView()));
                   },
                   child: Container(
                     padding: EdgeInsets.symmetric(vertical: 8),
                     child: Text(' Sign up' ,style: TextStyle(fontWeight: FontWeight.bold),),
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
