import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:testtask/main.dart';
import 'package:testtask/ui/widgets/show_dialog_check_image.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ImageCard extends ConsumerWidget {
  final imageFile;

  const ImageCard({super.key, this.imageFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ZoomTapAnimation(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Согласие'),
                  content: Text('Эту фото отправлять?'),
                  actions: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: const Text('Нет'),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            ref.read(imageToGenerate.notifier).state=imageFile;
                            Navigator.of(context, rootNavigator: true).pop();
                            context.goNamed(
                              'generate',
                              /*pathParameters: {
                                'imageFile': imageFile.path,
                              },*/
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ));
      },
      child: Container(
        // width: 60,
        // height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white, width: 2),
          image: imageFile != null
              ? DecorationImage(
                  image: FileImage(imageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Container(),
      ),
    );
  }
}
