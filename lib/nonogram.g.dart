// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonogram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Nonogram _$$_NonogramFromJson(Map<String, dynamic> json) => _$_Nonogram(
      gridWidth: json['gridWidth'] as int,
      gridHeight: json['gridHeight'] as int,
      solution: (json['solution'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => $enumDecode(_$CellStateEnumMap, e))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$$_NonogramToJson(_$_Nonogram instance) =>
    <String, dynamic>{
      'gridWidth': instance.gridWidth,
      'gridHeight': instance.gridHeight,
      'solution': instance.solution
          .map((e) => e.map((e) => _$CellStateEnumMap[e]!).toList())
          .toList(),
    };

const _$CellStateEnumMap = {
  CellState.empty: 0,
  CellState.filled: 1,
  CellState.blocked: 2,
};

_$_NonogramSet _$$_NonogramSetFromJson(Map<String, dynamic> json) =>
    _$_NonogramSet(
      mosaicWidth: json['mosaicWidth'] as int,
      mosaicHeight: json['mosaicHeight'] as int,
      kernels: (json['kernels'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => Nonogram.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$$_NonogramSetToJson(_$_NonogramSet instance) =>
    <String, dynamic>{
      'mosaicWidth': instance.mosaicWidth,
      'mosaicHeight': instance.mosaicHeight,
      'kernels': instance.kernels,
    };
