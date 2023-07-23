import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:nonograms/nonogram.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<img.Image?> loadImage(Uint8List bytes) async {
  return img.decodeImage(bytes);
}

Future<String> saveImage(img.Image image, {bool temp = false}) async {
  final documentsDir = await (temp
      ? getTemporaryDirectory()
      : getApplicationDocumentsDirectory());
  final filename = "${const Uuid().v4()}.png";
  final path = p.join(documentsDir.path, filename);
  await img.encodePngFile(path, image);
  return path;
}

img.Image processImage({
  required img.Image image,
  required int kernelWidth,
  required int kernelHeight,
  required int imageWidth,
  required int imageHeight,
  required double sobelLevel,
  required double luminanceThreshold,
}) {
  final copy = img.copyResize(
    image,
    width: imageWidth,
    height: imageHeight,
  );
  img.edgeGlow(copy, amount: sobelLevel);
  img.grayscale(copy);
  img.sobel(copy, amount: sobelLevel);
  img.luminanceThreshold(copy, threshold: luminanceThreshold);
  return copy;
}

NonogramSet importImage({
  required img.Image image,
  required int kernelWidth,
  required int kernelHeight,
  required int imageWidth,
  required int imageHeight,
  required double sobelLevel,
  required double luminanceThreshold,
  required bool invert,
}) {
  final copy = processImage(
    image: image,
    kernelWidth: kernelWidth,
    kernelHeight: kernelHeight,
    imageWidth: imageWidth,
    imageHeight: imageHeight,
    sobelLevel: sobelLevel,
    luminanceThreshold: luminanceThreshold,
  );
  final pixels = copy.getRange(0, 0, imageWidth, imageHeight);

  final kernels = <List<List<List<CellState>>>>[];

  while (pixels.moveNext()) {
    final pixel = pixels.current;
    final kernelX = (pixel.x / kernelWidth).floor();
    final kernelY = (pixel.y / kernelHeight).floor();
    // final cellX = pixel.x % kernelWidth;
    final cellY = pixel.y % kernelHeight;

    // print(
    //     "${pixel.x},${pixel.y} ($kernelX.$cellX, $kernelY.$cellY) --- ${pixel.luminance}");

    if (kernels.length <= kernelY) {
      kernels.add([]);
    }
    if (kernels[kernelY].length <= kernelX) {
      kernels[kernelY].add([]);
    }
    if (kernels[kernelY][kernelX].length <= cellY) {
      kernels[kernelY][kernelX].add([]);
    }
    kernels[kernelY][kernelX][cellY].add(
      pixel.luminance > 0
          ? (invert ? CellState.filled : CellState.empty)
          : (invert ? CellState.empty : CellState.filled),
    );
  }

  final nonograms = <List<Nonogram>>[];
  for (final kernelRow in kernels) {
    final nonogramRow = <Nonogram>[];
    for (final kernel in kernelRow) {
      nonogramRow.add(
        Nonogram(
            gridWidth: kernel[0].length,
            gridHeight: kernel.length,
            solution: kernel),
      );
    }
    nonograms.add(nonogramRow);
  }
  return NonogramSet(
    mosaicWidth: nonograms[0].length,
    mosaicHeight: nonograms.length,
    kernels: nonograms,
  );
}
