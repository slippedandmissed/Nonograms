// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Game _$$_GameFromJson(Map<String, dynamic> json) => _$_Game(
      id: json['id'] as String,
      nonogramSet:
          NonogramSet.fromJson(json['nonogramSet'] as Map<String, dynamic>),
      progress: NonogramSet.fromJson(json['progress'] as Map<String, dynamic>),
      imagePath: json['imagePath'] as String,
    );

Map<String, dynamic> _$$_GameToJson(_$_Game instance) => <String, dynamic>{
      'id': instance.id,
      'nonogramSet': instance.nonogramSet,
      'progress': instance.progress,
      'imagePath': instance.imagePath,
    };
