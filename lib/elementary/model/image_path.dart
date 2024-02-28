import 'dart:io';

import 'package:flutter/material.dart';

class ImageFiles with ChangeNotifier {
  File _imageFile = File("");
  List<File> _imageFileList = [];

  File get getImageFile => _imageFile;

  List<File> get getImageFileList => _imageFileList;

  void changeImageFile(File newFile) {
    _imageFile = newFile;

    notifyListeners();
  }

  void addImageFileToList(File newFile) {
    _imageFileList.add(newFile);

    notifyListeners();
  }
  void clearImageFileToList() {
    _imageFileList.clear();

    notifyListeners();
  }
}
