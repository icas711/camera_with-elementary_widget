import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtask/utils/custom_scroll_behavior.dart';
import 'package:testtask/routes.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const ProviderScope(child: MyApp()),
  );
}

final  imageProvider = StateProvider<List<File>>((ref) {return [File("")];});
final  imageToGenerate = StateProvider<File>((ref) {return File("");});

class MyApp extends StatelessWidget  {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        //designSize: const Size(360, 690),
        minTextAdapt: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (context, snapshot) {
          return MaterialApp.router(
              routerConfig: router,
              title: ' ',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.deepPurple)
                        .copyWith(background: Colors.grey.shade200),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff49A5C1),
                    elevation: 10,
                    shadowColor: const Color(0xff49A5C1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
              ),
              scrollBehavior: (!Platform.isAndroid ||
                      !Platform.isIOS ||
                      !Platform.isFuchsia)
                  ? CustomScrollBehavior()
                  : const ScrollBehavior());
        });
  }
}