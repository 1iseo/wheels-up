// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rental_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RentalState {
  List<RentalRequestWithRelations> get requests =>
      throw _privateConstructorUsedError;

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RentalStateCopyWith<RentalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RentalStateCopyWith<$Res> {
  factory $RentalStateCopyWith(
          RentalState value, $Res Function(RentalState) then) =
      _$RentalStateCopyWithImpl<$Res, RentalState>;
  @useResult
  $Res call({List<RentalRequestWithRelations> requests});
}

/// @nodoc
class _$RentalStateCopyWithImpl<$Res, $Val extends RentalState>
    implements $RentalStateCopyWith<$Res> {
  _$RentalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requests = null,
  }) {
    return _then(_value.copyWith(
      requests: null == requests
          ? _value.requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<RentalRequestWithRelations>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RentalStateImplCopyWith<$Res>
    implements $RentalStateCopyWith<$Res> {
  factory _$$RentalStateImplCopyWith(
          _$RentalStateImpl value, $Res Function(_$RentalStateImpl) then) =
      __$$RentalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RentalRequestWithRelations> requests});
}

/// @nodoc
class __$$RentalStateImplCopyWithImpl<$Res>
    extends _$RentalStateCopyWithImpl<$Res, _$RentalStateImpl>
    implements _$$RentalStateImplCopyWith<$Res> {
  __$$RentalStateImplCopyWithImpl(
      _$RentalStateImpl _value, $Res Function(_$RentalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requests = null,
  }) {
    return _then(_$RentalStateImpl(
      requests: null == requests
          ? _value._requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<RentalRequestWithRelations>,
    ));
  }
}

/// @nodoc

class _$RentalStateImpl implements _RentalState {
  const _$RentalStateImpl(
      {required final List<RentalRequestWithRelations> requests})
      : _requests = requests;

  final List<RentalRequestWithRelations> _requests;
  @override
  List<RentalRequestWithRelations> get requests {
    if (_requests is EqualUnmodifiableListView) return _requests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requests);
  }

  @override
  String toString() {
    return 'RentalState(requests: $requests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RentalStateImpl &&
            const DeepCollectionEquality().equals(other._requests, _requests));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_requests));

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RentalStateImplCopyWith<_$RentalStateImpl> get copyWith =>
      __$$RentalStateImplCopyWithImpl<_$RentalStateImpl>(this, _$identity);
}

abstract class _RentalState implements RentalState {
  const factory _RentalState(
          {required final List<RentalRequestWithRelations> requests}) =
      _$RentalStateImpl;

  @override
  List<RentalRequestWithRelations> get requests;

  /// Create a copy of RentalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RentalStateImplCopyWith<_$RentalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
