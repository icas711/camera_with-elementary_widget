import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testtask/elementary/widgetmodels/widget_model.dart';
import 'package:testtask/elementary/widgetmodels/widget_model_factory.dart';
import 'package:testtask/ui/viewmodel/shape_model.dart';
import 'package:testtask/ui/widgets/image_intstruments.dart';
import 'package:testtask/ui/widgets/image_shape.dart';
import 'package:testtask/utils/text_style.dart';

class GenerateImage extends ElementaryWidget<GenerateImageWidgetModel> {
  GenerateImage({
    Key? key,
    WidgetModelFactory wmFactory = generateImagePageWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(GenerateImageWidgetModel wm) {

    String urlText = "";
    bool isHandset = 1.sw < 400;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          //direction: isHandset ? Axis.vertical : Axis.horizontal,
          children: [
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                    height: isHandset ? 1.sw : 1.sh - 30.h,
                    width: isHandset ? 1.sw : 1.sw / 2,
                    child: Center(
                      child: StreamBuilder<bool>(
                          stream: wm.isLoadingShapeStream,
                          initialData: wm.isLoadingShapeValue,
                          builder: (context, isLoading) {
                            return StreamBuilder<ShapeMetrics>(
                                stream: wm.shapeStream,
                                initialData: wm.shapeValue,
                                builder: (context, ShapeMetrics) {
                                  final metriks = ShapeMetrics.requireData;
                                  if (isLoading.requireData) {
                                    return const CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    );
                                  }
                                  return ImageShape(
                                    wm: wm,
                                    size: metriks.size,
                                    opacity: metriks.opacity,
                                    borderRadius: metriks.borderRadius,
                                    finalAngle: metriks.finalAngle,
                                  );
                                });
                          }),
                    )),
                //if(isHandset) const Expanded(child: SizedBox.shrink()),
              ]),
            ),
            EntityStateNotifierBuilder<bool>(
                listenableEntityState: wm.valueState,
                builder: (_, data) {
                  return EntityStateNotifierBuilder<String>(
                    listenableEntityState: wm.textState,
                    builder: (_, data) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 5.w,
                          ),
                          TextButton(
                              onPressed: wm.generateNewShape,
                              child: const Text('Сгенерировать шаблон')),
                          //SizedBox(height: 1.sh-1.2.sw,),
                          Spacer(),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data!,
                              style: ThemeText.welcome,
                            ),
                          ),
                          ImageInstruments(wm2: wm),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                TextButton(
                                  child: const Text('Введите текст'),
                                  onPressed: () async {
                                    await showDialog(
                                      context: _,
                                      builder: (_) => AlertDialog(
                                        title:
                                            const Text('Введи послание предкам'),
                                        content: TextField(
                                          onChanged: (text) {
                                            wm.changeTetx(text);
                                          },
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    wm.changeTetx(""),
                                                child: const Text('Очистить'),
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                onPressed: () => Navigator.of(_,
                                                        rootNavigator: true)
                                                    .pop(),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                if (data != "") Spacer(),
                                if (data != "")
                                  TextButton(
                                      child:
                                      const Text('Послать на сервер'),
                                      onPressed: () {
                                        _.goNamed('request');
                                        }),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class showEditImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('data');
  }
}
