import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtask/utils/constants.dart';
import 'package:testtask/main.dart';
import 'package:testtask/ui/widgets/image_card.dart';

class PictureListScreen extends ConsumerStatefulWidget {
  const PictureListScreen({super.key});

  @override
  ConsumerState<PictureListScreen> createState() => PictureListScreenState();
}

class PictureListScreenState extends ConsumerState<PictureListScreen>
    with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    List<File> allFileList = ref.watch(imageProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Список картинок')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        child: GridView.builder(
          itemCount: allFileList.length, // + (isLoading ? 1 : 0),

          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: ImageCard(imageFile: allFileList[index]),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (getSize(context)==ScreenSize.normal)
                ? (getSize(context)==ScreenSize.large
                ? (getSize(context)==ScreenSize.extraLarge
                ? 6
                : 4)
                : 3)
                : 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 9 / 16,
          ),
        ),
      ),
    );
  }
}
