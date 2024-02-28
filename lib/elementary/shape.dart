

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtask/main.dart';



class SomeShape extends ConsumerWidget {
  final double height;
  final double width;
  final double opacity;
  final double borderRadius;
  final double finalAngle;

  const SomeShape({
    required this.height,
    required this.width,
    required this.opacity,
    required this.borderRadius,
    required this.finalAngle,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: width,
        child: Opacity(
          opacity: opacity,
          child://Image.network('https://static01.nyt.com/images/2017/05/18/watching/twin-peaks-watching/twin-peaks-watching-mediumSquareAt3X-v2.jpg',
          Image.file(ref.watch(imageToGenerate),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
