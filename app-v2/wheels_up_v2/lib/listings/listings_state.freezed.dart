// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ListingsState {
  ListingResponse? get listings => throw _privateConstructorUsedError;

  /// Create a copy of ListingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingsStateCopyWith<ListingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingsStateCopyWith<$Res> {
  factory $ListingsStateCopyWith(
          ListingsState value, $Res Function(ListingsState) then) =
      _$ListingsStateCopyWithImpl<$Res, ListingsState>;
  @useResult
  $Res call({ListingResponse? listings});
}

/// @nodoc
class _$ListingsStateCopyWithImpl<$Res, $Val extends ListingsState>
    implements $ListingsStateCopyWith<$Res> {
  _$ListingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listings = freezed,
  }) {
    return _then(_value.copyWith(
      listings: freezed == listings
          ? _value.listings
          : listings // ignore: cast_nullable_to_non_nullable
              as ListingResponse?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingsStateImplCopyWith<$Res>
    implements $ListingsStateCopyWith<$Res> {
  factory _$$ListingsStateImplCopyWith(
          _$ListingsStateImpl value, $Res Function(_$ListingsStateImpl) then) =
      __$$ListingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ListingResponse? listings});
}

/// @nodoc
class __$$ListingsStateImplCopyWithImpl<$Res>
    extends _$ListingsStateCopyWithImpl<$Res, _$ListingsStateImpl>
    implements _$$ListingsStateImplCopyWith<$Res> {
  __$$ListingsStateImplCopyWithImpl(
      _$ListingsStateImpl _value, $Res Function(_$ListingsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listings = freezed,
  }) {
    return _then(_$ListingsStateImpl(
      listings: freezed == listings
          ? _value.listings
          : listings // ignore: cast_nullable_to_non_nullable
              as ListingResponse?,
    ));
  }
}

/// @nodoc

class _$ListingsStateImpl implements _ListingsState {
  const _$ListingsStateImpl({this.listings});

  @override
  final ListingResponse? listings;

  @override
  String toString() {
    return 'ListingsState(listings: $listings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingsStateImpl &&
            (identical(other.listings, listings) ||
                other.listings == listings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, listings);

  /// Create a copy of ListingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingsStateImplCopyWith<_$ListingsStateImpl> get copyWith =>
      __$$ListingsStateImplCopyWithImpl<_$ListingsStateImpl>(this, _$identity);
}

abstract class _ListingsState implements ListingsState {
  const factory _ListingsState({final ListingResponse? listings}) =
      _$ListingsStateImpl;

  @override
  ListingResponse? get listings;

  /// Create a copy of ListingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingsStateImplCopyWith<_$ListingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
