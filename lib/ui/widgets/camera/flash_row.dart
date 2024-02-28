import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testtask/main.dart';

class FlashModeRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            ref.read(currentFlashMode.notifier).state = FlashMode.off;
          },
          child: Icon(
            Icons.flash_off,
            color:  ref.watch(currentFlashMode)== FlashMode.off
                ? Colors.amber
                : Colors.white,
          ),
        ),
        InkWell(
          onTap: () async {
            ref.read(currentFlashMode.notifier).state = FlashMode.auto;
          },
          child: Icon(
            Icons.flash_auto,
            color: ref.watch(currentFlashMode) == FlashMode.auto
                ? Colors.amber
                : Colors.white,
          ),
        ),
        InkWell(
          onTap: () async {
            ref.read(currentFlashMode.notifier).state = FlashMode.always;
          },
          child: Icon(
            Icons.flash_on,
            color: ref.watch(currentFlashMode) == FlashMode.always
                ? Colors.amber
                : Colors.white,
          ),
        ),
        InkWell(
          onTap: () async {
            ref.read(currentFlashMode.notifier).state = FlashMode.torch;
          },
          child: Icon(
            Icons.highlight,
            color: ref.watch(currentFlashMode) == FlashMode.torch
                ? Colors.amber
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
