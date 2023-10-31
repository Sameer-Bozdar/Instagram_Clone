
import 'package:flutter/material.dart';
import 'package:instagram_project/provider/user_provider.dart';
import 'package:instagram_project/utils/global_variable.dart';
import 'package:provider/provider.dart';




class ResponsiveLayout extends StatefulWidget {

  final Widget webscreenlayout;
  final Widget mobilescreenlayout;
  const ResponsiveLayout({super.key, required this.webscreenlayout, required this.mobilescreenlayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {


  @override
  void initState() {
    addUserData();
    super.initState();
  }

  addUserData()async{
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){

      if(constraints.maxWidth > webScreenSize){
        return widget.webscreenlayout;
      }else{
        return widget.mobilescreenlayout;
      }

    });
  }
}


