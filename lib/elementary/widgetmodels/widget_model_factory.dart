
import 'package:flutter/material.dart';
import 'package:testtask/elementary/widgetmodels/widget_model.dart';

import '../model/app_error_handler.dart';
import '../model/model.dart';

GenerateImageWidgetModel generateImagePageWidgetModelFactory(BuildContext context){
return GenerateImageWidgetModel(GenerateImageModel(AppErrorHandler()));
}
