import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_exif/native_exif.dart';
import 'package:testtask/main.dart';

class CheckGPSWidget extends ConsumerStatefulWidget {
  const CheckGPSWidget({super.key});

  @override
  ConsumerState<CheckGPSWidget> createState() => CheckGPSWidgetState();
}

class CheckGPSWidgetState extends ConsumerState<CheckGPSWidget> {
  bool _imgHasLocation = false;
  ExifLatLong? coordinates;
  Map<String, Object>? attributes;
  Exif? exif;
  XFile? pickedFile;
  File? file;

  @override
 Widget build(BuildContext context) {
    file = ref.watch(imageToGenerate);
    final exif = exifRead();
    return Scaffold(
      appBar: AppBar(title: const Text('Метаданные картинки')),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
        FutureBuilder<String>(
            future: exif, // a previously-obtained Future<String> or null
            builder: (context, snapshot) {


              return snapshot.hasData ? Center(child: Text(attributes.toString())) : const Text('Нет метаданных');

            }),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Future<String> exifRead() async {
    pickedFile = XFile(file!.path);
    exif = await Exif.fromPath(pickedFile!.path);
    try {
      final imageBytes = await pickedFile!.readAsBytes();
      attributes = await exif!.getAttributes();
      coordinates = await exif!.getLatLong();
      if (kDebugMode) {
        print(attributes);
      }

    } catch (e) {
      showError(e);
    }
    return attributes.toString();
  }

  Future<void> showError(Object e) async {
    debugPrintStack(
        label: e.toString(), stackTrace: e is Error ? e.stackTrace : null);
  }
}
