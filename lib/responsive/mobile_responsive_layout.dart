import 'package:flutter/material.dart';
import 'package:instagram_project/utils/colors.dart';
import 'package:instagram_project/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
   PageController? pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  void navigationTapped(int page){
    pageController!.jumpToPage(page);
  }
  void onPageChanged(int page){
    setState(() {
      _page = page;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
            children :homeScreenItem,
          physics:  NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,

        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor
              ),
              backgroundColor: secondaryColor,
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor),
              backgroundColor: secondaryColor,
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.favorite,color: _page == 3 ? primaryColor : secondaryColor),
              backgroundColor: secondaryColor,
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.person,color: _page == 4 ? primaryColor : secondaryColor),
              backgroundColor: secondaryColor,
            ),

          ],
          onTap: navigationTapped,
        ));
  }
}
