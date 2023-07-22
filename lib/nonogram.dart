import 'package:freezed_annotation/freezed_annotation.dart';

part 'nonogram.freezed.dart';
part 'nonogram.g.dart';

@freezed
class Nonogram with _$Nonogram {
  const factory Nonogram({
    required int gridWidth,
    required int gridHeight,
    required List<List<bool>> solution,
  }) = _Nonogram;

  factory Nonogram.fromJson(Map<String, Object?> json) =>
      _$NonogramFromJson(json);
}

@freezed
class NonogramSet with _$NonogramSet {
  const factory NonogramSet({
    required int mosaicWidth,
    required int mosaicHeight,
    required List<List<Nonogram>> kernels,
  }) = _NonogramSet;

  factory NonogramSet.fromJson(Map<String, Object?> json) =>
      _$NonogramSetFromJson(json);
}
