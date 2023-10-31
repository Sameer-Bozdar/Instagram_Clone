import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomRoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
final  bool isLoading ;
  CustomRoundButton({super.key, required this.title, required this.onTap, required this.isLoading });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            color: blueColor),
        child:  Center(
            child: isLoading ? CircularProgressIndicator(
              color: Colors.white,
            ) : Text(
          title,
          style: TextStyle(fontSize: 14),
        )),
      ),
    );
  }
}
