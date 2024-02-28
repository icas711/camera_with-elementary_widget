import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtask/elementary/widgetmodels/widget_model.dart';
import 'package:testtask/ui/pages/generate_image_page.dart';
import 'package:testtask/ui/widgets/screen_horizontal_slider_widget.dart';

class ImageInstruments extends GenerateImage {
  final GenerateImageWidgetModel wm2;

  ImageInstruments({Key? key, required this.wm2}) : super(key: key);

  @override
  Widget build(GenerateImageWidgetModel wm) {
    bool isHandset = 1.sw < 400;
    return //super.build(wm);
        SizedBox(
      width: isHandset ? 1.sw : 1.sw / 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ширина',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  )),
              ScreenHorizontalSliderWidget(
                indicatorSize: const Size(20, 20),
                controller: wm2.widthController,
                duration: const Duration(milliseconds: 500),
                screenWidth: constraints.maxWidth,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Высота',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  )),
              ScreenHorizontalSliderWidget(
                indicatorSize: const Size(20, 20),
                controller: wm2.heightController,
                duration: const Duration(milliseconds: 500),
                screenWidth: constraints.maxWidth,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Радиус углов',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  )),
              ScreenHorizontalSliderWidget(
                indicatorSize: const Size(20, 20),
                controller: wm2.borderRadiusController,
                duration: const Duration(milliseconds: 500),
                screenWidth: constraints.maxWidth,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Прозрачность',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.w600),
                  )),
              ScreenHorizontalSliderWidget(
                indicatorSize: const Size(20, 20),
                controller: wm2.opacityController,
                duration: const Duration(milliseconds: 500),
                screenWidth: constraints.maxWidth,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        }),
      ),
    );
  }
}
