import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_exif/native_exif.dart';

class DataGps {
  final File file;

  DataGps(this.file);

  bool _imgHasLocation = false;
  ExifLatLong? coordinates;
  Map<String, Object>? attributes;
  Exif? exif;
  XFile? pickedFile;

  Map<String, Object>? get gpsCoordinates => attributes;

  Future<void> showError(Object e) async {
    debugPrintStack(
        label: e.toString(), stackTrace: e is Error ? e.stackTrace : null);
  }

  Future<void> exifRead() async {
    //Map<String, Object?>? _exif;
    //  final exif = await readExifFromBytes(file.readAsBytesSync());
    //_exif = exif;
    //print(_exif);

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

  Future<void> updateGPS(
    double? latitude,
    double? longitude,
  ) async {
    try {
      if (latitude != null && longitude != null) {
        await exif!.writeAttributes({
          'GPSLatitude': latitude.toStringAsFixed(6),
          'GPSLatitudeRef': 'N',
          'GPSLongitude': longitude.toStringAsFixed(6),
          'GPSLongitudeRef': 'W',
          'comment': 'A photo from the phone camera.',
          'photo': '@test.png'
        });
      } else {
        await exif!.writeAttributes({
          'GPSLatitude': '38.897675',
          'GPSLatitudeRef': 'N',
          'GPSLongitude': '-77.036547',
          'GPSLongitudeRef': 'W',
          'comment': 'A photo from the phone camera.',
          'photo': '@test.png'
        });
      }

      //shootingDate = await exif!.getOriginalDate();
      attributes = await exif!.getAttributes();
      coordinates = await exif!.getLatLong();
      await file!.writeAsBytes(await pickedFile!.readAsBytes());
    } catch (e) {
      showError(e);
    }
  }
}