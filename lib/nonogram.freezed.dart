// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nonogram.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Nonogram _$NonogramFromJson(Map<String, dynamic> json) {
  return _Nonogram.fromJson(json);
}

/// @nodoc
mixin _$Nonogram {
  int get gridWidth => throw _privateConstructorUsedError;
  int get gridHeight => throw _privateConstructorUsedError;
  List<List<bool>> get solution => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NonogramCopyWith<Nonogram> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NonogramCopyWith<$Res> {
  factory $NonogramCopyWith(Nonogram value, $Res Function(Nonogram) then) =
      _$NonogramCopyWithImpl<$Res, Nonogram>;
  @useResult
  $Res call({int gridWidth, int gridHeight, List<List<bool>> solution});
}

/// @nodoc
class _$NonogramCopyWithImpl<$Res, $Val extends Nonogram>
    implements $NonogramCopyWith<$Res> {
  _$NonogramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gridWidth = null,
    Object? gridHeight = null,
    Object? solution = null,
  }) {
    return _then(_value.copyWith(
      gridWidth: null == gridWidth
          ? _value.gridWidth
          : gridWidth // ignore: cast_nullable_to_non_nullable
              as int,
      gridHeight: null == gridHeight
          ? _value.gridHeight
          : gridHeight // ignore: cast_nullable_to_non_nullable
              as int,
      solution: null == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as List<List<bool>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NonogramCopyWith<$Res> implements $NonogramCopyWith<$Res> {
  factory _$$_NonogramCopyWith(
          _$_Nonogram value, $Res Function(_$_Nonogram) then) =
      __$$_NonogramCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int gridWidth, int gridHeight, List<List<bool>> solution});
}

/// @nodoc
class __$$_NonogramCopyWithImpl<$Res>
    extends _$NonogramCopyWithImpl<$Res, _$_Nonogram>
    implements _$$_NonogramCopyWith<$Res> {
  __$$_NonogramCopyWithImpl(
      _$_Nonogram _value, $Res Function(_$_Nonogram) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gridWidth = null,
    Object? gridHeight = null,
    Object? solution = null,
  }) {
    return _then(_$_Nonogram(
      gridWidth: null == gridWidth
          ? _value.gridWidth
          : gridWidth // ignore: cast_nullable_to_non_nullable
              as int,
      gridHeight: null == gridHeight
          ? _value.gridHeight
          : gridHeight // ignore: cast_nullable_to_non_nullable
              as int,
      solution: null == solution
          ? _value._solution
          : solution // ignore: cast_nullable_to_non_nullable
              as List<List<bool>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Nonogram implements _Nonogram {
  const _$_Nonogram(
      {required this.gridWidth,
      required this.gridHeight,
      required final List<List<bool>> solution})
      : _solution = solution;

  factory _$_Nonogram.fromJson(Map<String, dynamic> json) =>
      _$$_NonogramFromJson(json);

  @override
  final int gridWidth;
  @override
  final int gridHeight;
  final List<List<bool>> _solution;
  @override
  List<List<bool>> get solution {
    if (_solution is EqualUnmodifiableListView) return _solution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_solution);
  }

  @override
  String toString() {
    return 'Nonogram(gridWidth: $gridWidth, gridHeight: $gridHeight, solution: $solution)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Nonogram &&
            (identical(other.gridWidth, gridWidth) ||
                other.gridWidth == gridWidth) &&
            (identical(other.gridHeight, gridHeight) ||
                other.gridHeight == gridHeight) &&
            const DeepCollectionEquality().equals(other._solution, _solution));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, gridWidth, gridHeight,
      const DeepCollectionEquality().hash(_solution));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NonogramCopyWith<_$_Nonogram> get copyWith =>
      __$$_NonogramCopyWithImpl<_$_Nonogram>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NonogramToJson(
      this,
    );
  }
}

abstract class _Nonogram implements Nonogram {
  const factory _Nonogram(
      {required final int gridWidth,
      required final int gridHeight,
      required final List<List<bool>> solution}) = _$_Nonogram;

  factory _Nonogram.fromJson(Map<String, dynamic> json) = _$_Nonogram.fromJson;

  @override
  int get gridWidth;
  @override
  int get gridHeight;
  @override
  List<List<bool>> get solution;
  @override
  @JsonKey(ignore: true)
  _$$_NonogramCopyWith<_$_Nonogram> get copyWith =>
      throw _privateConstructorUsedError;
}

NonogramSet _$NonogramSetFromJson(Map<String, dynamic> json) {
  return _NonogramSet.fromJson(json);
}

/// @nodoc
mixin _$NonogramSet {
  int get mosaicWidth => throw _privateConstructorUsedError;
  int get mosaicHeight => throw _privateConstructorUsedError;
  List<List<Nonogram>> get kernels => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NonogramSetCopyWith<NonogramSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NonogramSetCopyWith<$Res> {
  factory $NonogramSetCopyWith(
          NonogramSet value, $Res Function(NonogramSet) then) =
      _$NonogramSetCopyWithImpl<$Res, NonogramSet>;
  @useResult
  $Res call({int mosaicWidth, int mosaicHeight, List<List<Nonogram>> kernels});
}

/// @nodoc
class _$NonogramSetCopyWithImpl<$Res, $Val extends NonogramSet>
    implements $NonogramSetCopyWith<$Res> {
  _$NonogramSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mosaicWidth = null,
    Object? mosaicHeight = null,
    Object? kernels = null,
  }) {
    return _then(_value.copyWith(
      mosaicWidth: null == mosaicWidth
          ? _value.mosaicWidth
          : mosaicWidth // ignore: cast_nullable_to_non_nullable
              as int,
      mosaicHeight: null == mosaicHeight
          ? _value.mosaicHeight
          : mosaicHeight // ignore: cast_nullable_to_non_nullable
              as int,
      kernels: null == kernels
          ? _value.kernels
          : kernels // ignore: cast_nullable_to_non_nullable
              as List<List<Nonogram>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NonogramSetCopyWith<$Res>
    implements $NonogramSetCopyWith<$Res> {
  factory _$$_NonogramSetCopyWith(
          _$_NonogramSet value, $Res Function(_$_NonogramSet) then) =
      __$$_NonogramSetCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int mosaicWidth, int mosaicHeight, List<List<Nonogram>> kernels});
}

/// @nodoc
class __$$_NonogramSetCopyWithImpl<$Res>
    extends _$NonogramSetCopyWithImpl<$Res, _$_NonogramSet>
    implements _$$_NonogramSetCopyWith<$Res> {
  __$$_NonogramSetCopyWithImpl(
      _$_NonogramSet _value, $Res Function(_$_NonogramSet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mosaicWidth = null,
    Object? mosaicHeight = null,
    Object? kernels = null,
  }) {
    return _then(_$_NonogramSet(
      mosaicWidth: null == mosaicWidth
          ? _value.mosaicWidth
          : mosaicWidth // ignore: cast_nullable_to_non_nullable
              as int,
      mosaicHeight: null == mosaicHeight
          ? _value.mosaicHeight
          : mosaicHeight // ignore: cast_nullable_to_non_nullable
              as int,
      kernels: null == kernels
          ? _value._kernels
          : kernels // ignore: cast_nullable_to_non_nullable
              as List<List<Nonogram>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NonogramSet implements _NonogramSet {
  const _$_NonogramSet(
      {required this.mosaicWidth,
      required this.mosaicHeight,
      required final List<List<Nonogram>> kernels})
      : _kernels = kernels;

  factory _$_NonogramSet.fromJson(Map<String, dynamic> json) =>
      _$$_NonogramSetFromJson(json);

  @override
  final int mosaicWidth;
  @override
  final int mosaicHeight;
  final List<List<Nonogram>> _kernels;
  @override
  List<List<Nonogram>> get kernels {
    if (_kernels is EqualUnmodifiableListView) return _kernels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kernels);
  }

  @override
  String toString() {
    return 'NonogramSet(mosaicWidth: $mosaicWidth, mosaicHeight: $mosaicHeight, kernels: $kernels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NonogramSet &&
            (identical(other.mosaicWidth, mosaicWidth) ||
                other.mosaicWidth == mosaicWidth) &&
            (identical(other.mosaicHeight, mosaicHeight) ||
                other.mosaicHeight == mosaicHeight) &&
            const DeepCollectionEquality().equals(other._kernels, _kernels));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, mosaicWidth, mosaicHeight,
      const DeepCollectionEquality().hash(_kernels));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NonogramSetCopyWith<_$_NonogramSet> get copyWith =>
      __$$_NonogramSetCopyWithImpl<_$_NonogramSet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NonogramSetToJson(
      this,
    );
  }
}

abstract class _NonogramSet implements NonogramSet {
  const factory _NonogramSet(
      {required final int mosaicWidth,
      required final int mosaicHeight,
      required final List<List<Nonogram>> kernels}) = _$_NonogramSet;

  factory _NonogramSet.fromJson(Map<String, dynamic> json) =
      _$_NonogramSet.fromJson;

  @override
  int get mosaicWidth;
  @override
  int get mosaicHeight;
  @override
  List<List<Nonogram>> get kernels;
  @override
  @JsonKey(ignore: true)
  _$$_NonogramSetCopyWith<_$_NonogramSet> get copyWith =>
      throw _privateConstructorUsedError;
}
