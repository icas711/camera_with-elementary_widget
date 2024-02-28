import 'dart:math';

import 'package:elementary/elementary.dart';

import '../../data/shape_metriks_from_dto.dart';
import '../../data/sliders_colors_dto.dart';


class GenerateImageModel extends ElementaryModel {
  final _rnd = Random();

  bool get value => _value;
  var _value = false;

  String get text => _text;
  String _text = "";

  GenerateImageModel(ErrorHandler errorHandler) : super(errorHandler: errorHandler);

  bool setEditing() {
    return _value = !_value;
  }

  String setText(String value) {
    return _text = value;
  }


  Future<ShapeMetricFactorsDto> getNewShape() async {
    return Future.delayed(const Duration(milliseconds: 200)).then(
          (_) {
        return ShapeMetricFactorsDto(
          height: _rnd.nextDouble(),
          width: _rnd.nextDouble(),
          opacity: _rnd.nextDouble(),
          borderRadius: _rnd.nextDouble(),
          finalAngle: 0,
        );
      },
    );
  }

  Future<ShapeMetricFactorsDto> getStartShape() async {
    return Future.delayed(const Duration(milliseconds: 200)).then(
          (_) {
        return const ShapeMetricFactorsDto(
          height: 0.998,
          width: 0.998,
          opacity: 0.998,
          borderRadius: 0,
          finalAngle: 0,
        );
      },
    );
  }

  SlidersColorFactorsDto getSlidersColors() {
    return SlidersColorFactorsDto(
      height: _rnd.nextDouble(),
      width: _rnd.nextDouble(),
      opacity: _rnd.nextDouble(),
      borderRadius: _rnd.nextDouble(),
    );
  }
}

