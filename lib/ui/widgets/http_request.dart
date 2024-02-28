import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_exif/native_exif.dart';
import 'package:testtask/main.dart';



class CheckGPSWidget extends ConsumerStatefulWidget {
  const CheckGPSWidget({super.key});

  @override
  ConsumerState<CheckGPSWidget> createState() =>
      CheckGPSWidgetState();
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
    exifRead();
    return Scaffold(
      appBar: AppBar(title: Text('Отправлен')),
      body: Column(
        children: [
          Center(child: Text(attributes.toString())),
          SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: () {
                updateGPS();
              },
              child: Text('Set coordinates'))
        ],
      ),
    );
  }

  void updateGPS() async {
    try {
      await exif!.writeAttributes({
        'GPSLatitude': '1.0',
        'GPSLatitudeRef': 'N',
        'GPSLongitude': '2.0',
        'GPSLongitudeRef': 'W',
      });

      //shootingDate = await exif!.getOriginalDate();
      attributes = await exif!.getAttributes();
      coordinates = await exif!.getLatLong();
      await file!.writeAsBytes(await pickedFile!.readAsBytes());
      setState(() {});
    } catch (e) {
      showError(e);
    }
  }

  void exifRead() async {

    pickedFile = XFile(file!.path);
    exif = await Exif.fromPath(pickedFile!.path);
    try {
      final imageBytes = await pickedFile!.readAsBytes();
      attributes = await exif!.getAttributes();
      coordinates = await exif!.getLatLong();
      print(attributes);
    } catch (e) {
      showError(e);
    }
  }

  Future<void> showError(Object e) async {
    debugPrintStack(
        label: e.toString(), stackTrace: e is Error ? e.stackTrace : null);
  }
}
