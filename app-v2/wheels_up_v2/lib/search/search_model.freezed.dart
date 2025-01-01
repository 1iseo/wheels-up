// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchHit _$SearchHitFromJson(Map<String, dynamic> json) {
  return _SearchHit.fromJson(json);
}

/// @nodoc
mixin _$SearchHit {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get pricePerHour => throw _privateConstructorUsedError;
  String get thumbnail => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;

  /// Serializes this SearchHit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchHit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHitCopyWith<SearchHit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHitCopyWith<$Res> {
  factory $SearchHitCopyWith(SearchHit value, $Res Function(SearchHit) then) =
      _$SearchHitCopyWithImpl<$Res, SearchHit>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int pricePerHour,
      String thumbnail,
      String location});
}

/// @nodoc
class _$SearchHitCopyWithImpl<$Res, $Val extends SearchHit>
    implements $SearchHitCopyWith<$Res> {
  _$SearchHitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? pricePerHour = null,
    Object? thumbnail = null,
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as int,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchHitImplCopyWith<$Res>
    implements $SearchHitCopyWith<$Res> {
  factory _$$SearchHitImplCopyWith(
          _$SearchHitImpl value, $Res Function(_$SearchHitImpl) then) =
      __$$SearchHitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int pricePerHour,
      String thumbnail,
      String location});
}

/// @nodoc
class __$$SearchHitImplCopyWithImpl<$Res>
    extends _$SearchHitCopyWithImpl<$Res, _$SearchHitImpl>
    implements _$$SearchHitImplCopyWith<$Res> {
  __$$SearchHitImplCopyWithImpl(
      _$SearchHitImpl _value, $Res Function(_$SearchHitImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchHit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? pricePerHour = null,
    Object? thumbnail = null,
    Object? location = null,
  }) {
    return _then(_$SearchHitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerHour: null == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as int,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchHitImpl with DiagnosticableTreeMixin implements _SearchHit {
  _$SearchHitImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.pricePerHour,
      required this.thumbnail,
      required this.location});

  factory _$SearchHitImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchHitImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int pricePerHour;
  @override
  final String thumbnail;
  @override
  final String location;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SearchHit(id: $id, title: $title, description: $description, pricePerHour: $pricePerHour, thumbnail: $thumbnail, location: $location)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SearchHit'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('pricePerHour', pricePerHour))
      ..add(DiagnosticsProperty('thumbnail', thumbnail))
      ..add(DiagnosticsProperty('location', location));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, description, pricePerHour, thumbnail, location);

  /// Create a copy of SearchHit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHitImplCopyWith<_$SearchHitImpl> get copyWith =>
      __$$SearchHitImplCopyWithImpl<_$SearchHitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchHitImplToJson(
      this,
    );
  }
}

abstract class _SearchHit implements SearchHit {
  factory _SearchHit(
      {required final String id,
      required final String title,
      required final String description,
      required final int pricePerHour,
      required final String thumbnail,
      required final String location}) = _$SearchHitImpl;

  factory _SearchHit.fromJson(Map<String, dynamic> json) =
      _$SearchHitImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get pricePerHour;
  @override
  String get thumbnail;
  @override
  String get location;

  /// Create a copy of SearchHit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHitImplCopyWith<_$SearchHitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
