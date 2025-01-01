import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wheels_up_v2/rental/rental_service.dart';

part 'rental_state.freezed.dart';

@freezed
class RentalState with _$RentalState {
  const factory RentalState({
    required List<RentalRequestWithRelations> requests,
  }) = _RentalState;
}