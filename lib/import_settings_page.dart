import 'dart:math';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:nonograms/image_processing.dart';
import 'package:nonograms/nonogram.dart';

@RoutePage()
class ImportSettingsPage extends ConsumerStatefulWidget {
  final img.Image image;
  const ImportSettingsPage({super.key, required this.image});

  @override
  ConsumerState<ImportSettingsPage> createState() => _ImportSettingsPageState();
}

const maxKernelSize = 32;
const minKernelSize = 3;

class _ImportSettingsPageState extends ConsumerState<ImportSettingsPage> {
  double mosaicSize = 9;
  int kernelSize = 15;
  double sobelLevel = 0.5;
  double luminanceThreshold = 0.5;

  bool isSubmitting = false;
  bool nonogramView = false;

  @override
  Widget build(BuildContext context) {
    final aspect = widget.image.width / widget.image.height;
    final numKernelsX = sqrt(mosaicSize * aspect);
    final numKernelsY = mosaicSize / numKernelsX;

    final imageWidth = (kernelSize * numKernelsX).round();
    final imageHeight = (kernelSize * numKernelsY).round();

    final nonogram = importImage(
      image: widget.image,
      kernelWidth: kernelSize,
      kernelHeight: kernelSize,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      sobelLevel: sobelLevel,
      luminanceThreshold: luminanceThreshold,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Import Image")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Kernel Size: $kernelSize×$kernelSize cells"),
            Slider(
                max: maxKernelSize.toDouble(),
                min: minKernelSize.toDouble(),
                divisions: maxKernelSize - minKernelSize,
                label: "$kernelSize",
                value: kernelSize.toDouble(),
                onChanged: (v) {
                  setState(() {
                    kernelSize = v.round();
                  });
                }),
            const SizedBox(height: 16),
            Text(
                "Mosaic Size: Approx. ${mosaicSize.toStringAsFixed(1)} kernels"),
            Slider(
                max: 60,
                min: 1,
                value: mosaicSize,
                onChanged: (v) {
                  setState(() {
                    mosaicSize = v;
                  });
                }),
            const SizedBox(height: 16),
            Text("Sobel Level: ${sobelLevel.toStringAsFixed(2)}"),
            Slider(
                max: 1,
                min: 0.01,
                value: sobelLevel,
                onChanged: (v) {
                  setState(() {
                    sobelLevel = v;
                  });
                }),
            const SizedBox(height: 16),
            Text(
                "Luminance Threshold: ${luminanceThreshold.toStringAsFixed(2)}"),
            Slider(
                max: 1,
                min: 0,
                value: luminanceThreshold,
                onChanged: (v) {
                  setState(() {
                    luminanceThreshold = v;
                  });
                }),
            const SizedBox(height: 32),
            GridPreview(
              kernelWidth: kernelSize,
              kernelHeight: kernelSize,
              imageWidth: imageWidth,
              imageHeight: imageHeight,
              // image: processImage(
              //   image: widget.image,
              //   imageWidth: imageWidth,
              //   imageHeight: imageHeight,
              //   kernelHeight: kernelSize,
              //   kernelWidth: kernelSize,
              //   sobelLevel: sobelLevel,
              //   luminanceThreshold: luminanceThreshold,
              // ),
              image: widget.image,
              nonogram: nonogram,
              nonogramView: nonogramView,
              totalWidth: 300,
            ),
            ToggleButtons(
              isSelected: [!nonogramView, nonogramView],
              onPressed: (index) {
                setState(() {
                  nonogramView = index == 1;
                });
              },
              children: const [Text("Image View"), Text("Nonogram View")],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () {
                      // setState(() {
                      //   isSubmitting = true;
                      // });
                    },
              style: ElevatedButton.styleFrom(
                elevation: 12,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
              child: isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ),
            const SizedBox(
              height: 128,
            )
          ],
        ),
      ),
    );
  }
}

final decodedImageProvider =
    FutureProvider.family<ui.Image, img.Image>((ref, image) async {
  return imgImageToUiImage(image);
});

class GridPreview extends ConsumerWidget {
  const GridPreview({
    super.key,
    required this.kernelWidth,
    required this.kernelHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.image,
    required this.totalWidth,
    required this.nonogram,
    required this.nonogramView,
    this.tileBorderWidth = 2,
  });

  final int kernelWidth, kernelHeight, imageWidth, imageHeight;
  final img.Image image;
  final NonogramSet nonogram;
  final double tileBorderWidth, totalWidth;
  final bool nonogramView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cellSize = (totalWidth -
            2 * tileBorderWidth * (1 + (imageWidth / kernelWidth).ceil())) /
        imageWidth;
    final totalHeight = cellSize * imageHeight +
        2 * tileBorderWidth * (1 + (imageHeight / kernelHeight).ceil());
    final uiImage = ref.watch(decodedImageProvider(image));
    return Stack(
      children: [
        if (!nonogramView)
          uiImage.when(
            data: (uiImage) => RawImage(
              fit: BoxFit.cover,
              image: uiImage,
              width: totalWidth,
              height: totalHeight,
            ),
            loading: () => SizedBox(
                width: totalWidth,
                height: totalHeight,
                child: const Center(
                  child: CircularProgressIndicator(),
                )),
            error: (_, __) => Container(
                width: totalWidth, height: totalHeight, color: Colors.red),
          ),
        Container(
          width: totalWidth,
          height: totalHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: tileBorderWidth),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < imageHeight; i += kernelHeight)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int j = 0; j < imageWidth; j += kernelWidth)
                      GridPreviewTile(
                        cellSize: cellSize,
                        kernelWidth: min(kernelWidth, imageWidth - j),
                        kernelHeight: min(kernelHeight, imageHeight - i),
                        borderWidth: tileBorderWidth,
                        nonogram: nonogram.kernels[(i / kernelHeight).floor()]
                            [(j / kernelWidth).floor()],
                        nonogramView: nonogramView,
                      )
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}

class GridPreviewTile extends StatelessWidget {
  const GridPreviewTile({
    super.key,
    required this.cellSize,
    required this.kernelWidth,
    required this.kernelHeight,
    required this.borderWidth,
    required this.nonogram,
    required this.nonogramView,
  });
  final int kernelWidth, kernelHeight;
  final double cellSize, borderWidth;
  final Nonogram nonogram;
  final bool nonogramView;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize * kernelWidth + 2 * borderWidth,
      height: cellSize * kernelHeight + 2 * borderWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < kernelHeight; i++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int j = 0; j < kernelWidth; j++)
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        color: nonogramView
                            ? (nonogram.solution[i][j]
                                ? Colors.white
                                : Colors.deepPurple)
                            : Colors.transparent),
                  )
              ],
            )
        ],
      ),
    );
  }
}
