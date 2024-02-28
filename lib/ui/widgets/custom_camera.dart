import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testtask/main.dart';
import 'package:testtask/ui/viewmodel/update_gps.dart';

class CustomCamera extends ConsumerStatefulWidget {
  const CustomCamera({
    super.key,
  });

  @override
  ConsumerState<CustomCamera> createState() => OnBoardingPageState();
}

class OnBoardingPageState extends ConsumerState<CustomCamera>
    with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  bool _isRearCameraSelected = true;
  var _imageFile;
  File imageFile = File("");
  bool _loading=false;
  LocationData? _location;
  final Location location = Location();

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final CameraController cameraController = await CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await cameraController
          .getMaxZoomLevel()
          .then((value) => _maxAvailableZoom = value);

      await cameraController
          .getMinZoomLevel()
          .then((value) => _minAvailableZoom = value);

      await cameraController
          .getMinExposureOffset()
          .then((value) => _minAvailableExposureOffset = value);

      await cameraController
          .getMaxExposureOffset()
          .then((value) => _maxAvailableExposureOffset = value);
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;

        _currentFlashMode = controller!.value.flashMode;
      });
    }
  }

  @override
  void initState() {
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack));
    onNewCameraSelected(cameras.first);
    super.initState();
  }

  @override
  void dispose() {
    unawaited(controller?.dispose());
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(children: [
              Container(
                color: Colors.black,
              ),
              AspectRatio(
                aspectRatio: 1 / controller!.value.aspectRatio,
                child: !_loading ? controller!.buildPreview() :
                const CircularProgressIndicator(),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 30.w,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _currentFlashMode = FlashMode.off;
                            });
                            await controller!.setFlashMode(
                              FlashMode.off,
                            );
                          },
                          child: Icon(
                            Icons.flash_off,
                            color: _currentFlashMode == FlashMode.off
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _currentFlashMode = FlashMode.auto;
                            });
                            await controller!.setFlashMode(
                              FlashMode.auto,
                            );
                          },
                          child: Icon(
                            Icons.flash_auto,
                            color: _currentFlashMode == FlashMode.auto
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _currentFlashMode = FlashMode.always;
                            });
                            await controller!.setFlashMode(
                              FlashMode.auto,
                            );
                          },
                          child: Icon(
                            Icons.flash_on,
                            color: _currentFlashMode == FlashMode.always
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _currentFlashMode = FlashMode.torch;
                            });
                            await controller!.setFlashMode(
                              FlashMode.torch,
                            );
                          },
                          child: Icon(
                            Icons.highlight,
                            color: _currentFlashMode == FlashMode.torch
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<ResolutionPreset>(
                        dropdownColor: Colors.black87,
                        underline: Container(),
                        value: currentResolutionPreset,
                        items: [
                          for (ResolutionPreset preset in resolutionPresets)
                            DropdownMenuItem(
                              child: Text(
                                preset.toString().split('.')[1].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              value: preset,
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            currentResolutionPreset = value!;
                            _isCameraInitialized = false;
                          });
                          onNewCameraSelected(controller!.description);
                        },
                        hint: Text("Выбрать нужное"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _currentExposureOffset.toStringAsFixed(1) + 'x',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: .5.sh,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              height: 30,
                              child: Slider(
                                value: _currentExposureOffset,
                                min: _minAvailableExposureOffset,
                                max: _maxAvailableExposureOffset,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white30,
                                onChanged: (value) async {
                                  setState(() {
                                    _currentExposureOffset = value;
                                  });
                                  await controller!.setExposureOffset(value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _currentZoomLevel,
                              min: _minAvailableZoom,
                              max: _maxAvailableZoom,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white30,
                              onChanged: (value) async {
                                setState(() {
                                  _currentZoomLevel = value;
                                });
                                await controller!.setZoomLevel(value);
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _currentZoomLevel.toStringAsFixed(1) + 'x',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20),
                        child: Wrap(
                          spacing: (1.sw - 204) / 3,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isCameraInitialized = false;
                                });
                                onNewCameraSelected(
                                  cameras[_isRearCameraSelected ? 0 : 1],
                                );
                                setState(() {
                                  _isRearCameraSelected =
                                      !_isRearCameraSelected;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.black38,
                                    size: 60,
                                  ),
                                  Icon(
                                    _isRearCameraSelected
                                        ? Icons.camera_front
                                        : Icons.camera_rear,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                XFile? rawImage = await takePicture();
                                File imageFile = File(rawImage!.path);

                                int currentUnix =
                                    DateTime.now().millisecondsSinceEpoch;
                                final directory =
                                    await getApplicationDocumentsDirectory();
                                String fileFormat =
                                    imageFile.path.split('.').last;

                                await imageFile.copy(
                                  '${directory.path}/$currentUnix.$fileFormat',
                                );
                                refreshAlreadyCapturedImages();
                              },
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(Icons.circle,
                                      color: Colors.white38, size: 80),
                                  Icon(Icons.circle,
                                      color: Colors.white, size: 65),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  context.goNamed('picture-list');
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    image: _imageFile != null
                                        ? DecorationImage(
                                            image: FileImage(_imageFile!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Container(),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.w,
                      )
                    ],
                  ),
                ],
              ),
            ])
          : Container(),
    );
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      DataGps exifData = await DataGps(File(file.path));
      await exifData.exifRead();
      //if(exifData.coordinates!=null) return file;
      await _getLocation();

      await exifData.updateGPS(_location!.latitude,_location!.longitude);

      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  // To store the retrieved files
  //List<File> allFileList = [];

  refreshAlreadyCapturedImages() async {
    // Get the directory
    List<File> allFileList = ref.watch(imageProvider);
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    ref.read(imageProvider.notifier).state = allFileList;

    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        allFileList.add(File(file.path));
        ref.read(imageProvider.notifier).state = allFileList;
        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });
    print(ref.watch(imageProvider).length);
    if (fileNames.isNotEmpty) {
      final recentFile =
          fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];

      _imageFile = File('${directory.path}/$recentFileName');

      setState(() {});
    }
  }


  String? _error;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final locationResult = await location.getLocation();
      setState(() {
        _location = locationResult;
        _loading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

}
