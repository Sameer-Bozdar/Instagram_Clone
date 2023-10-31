import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_project/provider/user_provider.dart';
import 'package:instagram_project/responsive/mobile_responsive_layout.dart';
import 'package:instagram_project/responsive/responsive_layout.dart';
import 'package:instagram_project/responsive/web_responsive_layout.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:instagram_project/view/signin_view.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
      options:const FirebaseOptions(apiKey: "AIzaSyCkMa9tPmBl2pvlTUIDsQ5msh1PhF9697c",
          appId: "1:621092340587:web:6be622006526deb281822e",
          messagingSenderId: "621092340587",
          projectId: "instagramproject-9a1b2",
          storageBucket: "instagramproject-9a1b2.appspot.com"
      )
    );

  }else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Flutter',
        theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor),
        home:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webscreenlayout: WebScreenLayout(),
                  mobilescreenlayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("{$snapshot.error}"),
                );
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
               return const CircularProgressIndicator(
                color: primaryColor,
              );
            }
            return const SignInView();
          }

        ),
      ),
    );
  }
}



















