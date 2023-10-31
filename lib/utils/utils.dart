import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? file = await _imagePicker.pickImage(source: source);

  if (file != null) {
    return file!.readAsBytes();
  } else {
    debugPrint('No Image Selected');
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
