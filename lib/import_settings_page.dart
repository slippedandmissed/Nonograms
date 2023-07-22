import 'dart:math';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:nonograms/game.dart';
import 'package:nonograms/image_processing.dart';
import 'package:nonograms/nonogram.dart';
import 'package:uuid/uuid.dart';

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
  double _mosaicSize = 9;
  int _kernelSize = 15;
  double _sobelLevel = 0.5;
  double _luminanceThreshold = 0.5;

  var isSubmitting = false;
  var nonogramView = false;
  var _invert = false;

  @override
  Widget build(BuildContext context) {
    final aspect = widget.image.width / widget.image.height;
    final numKernelsX = sqrt(_mosaicSize * aspect);
    final numKernelsY = _mosaicSize / numKernelsX;

    final imageWidth = (_kernelSize * numKernelsX).round();
    final imageHeight = (_kernelSize * numKernelsY).round();

    final nonogram = importImage(
      image: widget.image,
      kernelWidth: _kernelSize,
      kernelHeight: _kernelSize,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      sobelLevel: _sobelLevel,
      luminanceThreshold: _luminanceThreshold,
      invert: _invert,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Import Image")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Kernel Size: $_kernelSize×$_kernelSize cells"),
            Slider(
                max: maxKernelSize.toDouble(),
                min: minKernelSize.toDouble(),
                divisions: maxKernelSize - minKernelSize,
                label: "$_kernelSize",
                value: _kernelSize.toDouble(),
                onChanged: (v) {
                  setState(() {
                    _kernelSize = v.round();
                  });
                }),
            const SizedBox(height: 8),
            Text(
                "Mosaic Size: Approx. ${_mosaicSize.toStringAsFixed(1)} kernels"),
            Slider(
                max: 60,
                min: 1,
                value: _mosaicSize,
                onChanged: (v) {
                  setState(() {
                    _mosaicSize = v;
                  });
                }),
            const SizedBox(height: 8),
            Text("Sobel Level: ${_sobelLevel.toStringAsFixed(2)}"),
            Slider(
                max: 1,
                min: 0,
                value: _sobelLevel,
                onChanged: (v) {
                  setState(() {
                    _sobelLevel = v;
                  });
                }),
            const SizedBox(height: 8),
            Text(
                "Luminance Threshold: ${_luminanceThreshold.toStringAsFixed(2)}"),
            Slider(
                max: 1,
                min: 0,
                value: _luminanceThreshold,
                onChanged: (v) {
                  setState(() {
                    _luminanceThreshold = v;
                  });
                }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Invert"),
                Checkbox(
                    value: _invert,
                    onChanged: (invert) {
                      setState(() {
                        _invert = invert ?? false;
                      });
                    })
              ],
            ),
            const SizedBox(height: 32),
            GridPreview(
              kernelWidth: _kernelSize,
              kernelHeight: _kernelSize,
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
            const SizedBox(height: 8),
            ToggleButtons(
              isSelected: [!nonogramView, nonogramView],
              onPressed: (index) {
                setState(() {
                  nonogramView = index == 1;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Image View"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Nonogram View"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      setState(() {
                        isSubmitting = true;
                      });
                      final progress = <List<Nonogram>>[];
                      for (final kernelRow in nonogram.kernels) {
                        final progressKernelRow = <Nonogram>[];
                        for (final kernel in kernelRow) {
                          final progressKernel = <List<CellState>>[];
                          for (final cellRow in kernel.solution) {
                            final progressCellRow = <CellState>[];
                            for (final _ in cellRow) {
                              progressCellRow.add(CellState.empty);
                            }
                            progressKernel.add(progressCellRow);
                          }
                          progressKernelRow.add(
                            Nonogram(
                                gridWidth: progressKernel[0].length,
                                gridHeight: progressKernel.length,
                                solution: progressKernel),
                          );
                        }
                        progress.add(progressKernelRow);
                      }
                      final progressNonogram = NonogramSet(
                        mosaicWidth: progress[0].length,
                        mosaicHeight: progress.length,
                        kernels: progress,
                      );

                      final imagePath = await saveImage(widget.image);
                      final id = const Uuid().v4();
                      final game = Game(
                        id: id,
                        imagePath: imagePath,
                        nonogramSet: nonogram,
                        progress: progressNonogram,
                      );
                      await ref.read(storedGamesProvider).storeGame(game);
                      if (!mounted) return;
                      context.router.pop();
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
    this.image,
    required this.totalWidth,
    this.nonogram,
    this.wins,
    required this.nonogramView,
    this.tileBorderWidth = 2,
    this.onTap,
  }) : assert((nonogramView && nonogram != null) ||
            (!nonogramView && image != null));

  final int kernelWidth, kernelHeight, imageWidth, imageHeight;
  final img.Image? image;
  final NonogramSet? nonogram;
  final List<List<bool>>? wins;
  final double tileBorderWidth, totalWidth;
  final bool nonogramView;
  final Function(int kernelX, int kernelY)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cellSize = (totalWidth -
            2 * tileBorderWidth * (1 + (imageWidth / kernelWidth).ceil())) /
        imageWidth;
    final totalHeight = cellSize * imageHeight +
        2 * tileBorderWidth * (1 + (imageHeight / kernelHeight).ceil());
    final uiImage =
        nonogramView ? null : ref.watch(decodedImageProvider(image!));
    return Stack(
      children: [
        if (!nonogramView)
          uiImage!.when(
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
                      GridKernelPreview(
                        cellSize: cellSize,
                        kernelWidth: min(kernelWidth, imageWidth - j),
                        kernelHeight: min(kernelHeight, imageHeight - i),
                        kernelX: (j / kernelWidth).floor(),
                        kernelY: (i / kernelHeight).floor(),
                        wins: wins?[(i / kernelHeight).floor()]
                                [(j / kernelWidth).floor()] ??
                            false,
                        borderWidth: tileBorderWidth,
                        nonogram: nonogram!.kernels[(i / kernelHeight).floor()]
                            [(j / kernelWidth).floor()],
                        nonogramView: nonogramView,
                        onTap: onTap,
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

class GridKernelPreview extends StatelessWidget {
  const GridKernelPreview({
    super.key,
    required this.cellSize,
    required this.kernelWidth,
    required this.kernelHeight,
    required this.borderWidth,
    required this.nonogram,
    required this.nonogramView,
    required this.kernelX,
    required this.kernelY,
    this.onTap,
    this.wins = false,
  });
  final int kernelWidth, kernelHeight, kernelX, kernelY;
  final double cellSize, borderWidth;
  final Nonogram nonogram;
  final bool nonogramView;
  final bool wins;
  final Function(int kernelX, int kernelY)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(kernelX, kernelY),
      child: Container(
        width: cellSize * kernelWidth + 2 * borderWidth,
        height: cellSize * kernelHeight + 2 * borderWidth,
        decoration: BoxDecoration(
          border: Border.all(
              color: wins ? Colors.green : Colors.black, width: borderWidth),
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
                              ? nonogram.solution[i][j] == CellState.filled
                                  ? Colors.deepPurple
                                  : Colors.white
                              : Colors.transparent),
                      child: nonogramView &&
                              nonogram.solution[i][j] == CellState.blocked
                          ? CustomPaint(
                              painter: BlockCrossPainter(),
                            )
                          : null,
                    )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class BlockCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(size.width, 0);
    final p2 = Offset(0, size.height);
    const p3 = Offset(0, 0);
    final p4 = Offset(size.width, size.height);
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(BlockCrossPainter oldDelegate) => false;
}
