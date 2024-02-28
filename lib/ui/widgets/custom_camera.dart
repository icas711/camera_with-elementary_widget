import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testtask/main.dart';
import 'package:testtask/ui/viewmodel/update_gps.dart';
import 'package:testtask/ui/widgets/camera/flash_row.dart';

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
  double _minAvailableZoom = 1;
  double _maxAvailableZoom = 1;
  double _currentZoomLevel = 1;
  double _minAvailableExposureOffset = 0;
  double _maxAvailableExposureOffset = 0;
  double _currentExposureOffset = 0;
  bool _isRearCameraSelected = true;
  late File _imageFile;
  File imageFile = File('');
  bool _loading = false;
  LocationData? _location;
  final Location location = Location();
  final container = ProviderContainer();

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

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
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }

    if (mounted) {
      setState(() {
        controller = cameraController;

        _isCameraInitialized = controller!.value.isInitialized;

        ref.read(currentFlashMode.notifier).state = controller!.value.flashMode;

        ref.read(aspectRatio.notifier).state = controller!.value.aspectRatio;
      });
    }
  }

  Future<void> setFlashMode() async {
    await controller!.setFlashMode(ref.watch(currentFlashMode));
  }

  @override
  void initState() {
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack));
    unawaited(onNewCameraSelected(cameras.first));
    refreshAlreadyCapturedImages();
    super.initState();
  }

  @override
  void dispose() {
    unawaited(controller?.dispose());
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      await cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FlashMode>(currentFlashMode,
            (previousCount, newCount) async {
          await setFlashMode();
        });
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(children: [
        Container(
          color: Colors.black,
        ),
        AspectRatio(
          aspectRatio: 1 / controller!.value.aspectRatio,
          child: !_loading
              ? controller!.buildPreview()
              : Stack(children: [
            controller!.buildPreview(),
            const Center(
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator()),
            )
          ]),
        ),
        Column(
          children: [
            SizedBox(
              height: 30.w,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FlashModeRow(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButton<ResolutionPreset>(
                  dropdownColor: Colors.black87,
                  underline: Container(),
                  value: currentResolutionPreset,
                  items: [
                    for (ResolutionPreset preset in resolutionPresets)
                      DropdownMenuItem(
                        value: preset,
                        child: Text(
                          preset.toString().split('.')[1].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                  ],
                  onChanged: (value) async {
                    setState(() {
                      currentResolutionPreset = value!;
                      _isCameraInitialized = false;
                    });
                    await onNewCameraSelected(controller!.description);
                  },
                  hint: const Text('Выбрать нужное'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${_currentExposureOffset.toStringAsFixed(1)}x',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: .5.sh,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SizedBox(
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
            const Spacer(),
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
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${_currentZoomLevel.toStringAsFixed(1)}x',
                          style: const TextStyle(color: Colors.white),
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
                        onTap: () async {
                          setState(() {
                            _isCameraInitialized = false;
                          });
                          await onNewCameraSelected(
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
                          final rawImage = await takePicture();
                          final imageFile = File(rawImage!.path);

                          final currentUnix =
                              DateTime.now().millisecondsSinceEpoch;
                          final directory =
                          await getApplicationDocumentsDirectory();
                          final fileFormat =
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
                              borderRadius: BorderRadius.circular(10),
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
    final cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      final file = await cameraController.takePicture();
      final exifData = DataGps(File(file.path));
      await exifData.exifRead();
      await _getLocation();

      await exifData.updateGPS(_location!.latitude, _location!.longitude);

      return file;
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error occured while taking picture: $e');
      }
      return null;
    }
  }

  // To store the retrieved files
  //List<File> allFileList = [];

  void refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileList = await directory.list().toList();
    ref.read(imageProvider.notifier).state.clear();

    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        ref.read(imageProvider.notifier).state.add(File(file.path));
        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });
    if (fileNames.isNotEmpty) {
      final recentFile =
      fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      final String recentFileName = recentFile[1];

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
