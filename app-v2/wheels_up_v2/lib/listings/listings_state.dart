import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';

part 'listings_state.freezed.dart';

@freezed
class ListingsState with _$ListingsState {
  const factory ListingsState({
    ListingResponse? listings,
  }) = _ListingsState;
}