

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/rental/rental_state.dart';

part 'rental_provider.g.dart';


@riverpod
class SentRentalNotifier extends _$SentRentalNotifier {
  @override
  Future<RentalState> build() async {
    final rentalProvider = ref.read(rentalRequestServiceProvider);
    final authState = ref.read(authNotifierProvider);
    final requests = await rentalProvider.getUserRentalRequestsSent(authState.requireValue.user!.id);
    return RentalState(requests: requests);
  }
}

@riverpod
class ReceivedRentalNotifier extends _$ReceivedRentalNotifier {
  @override
  Future<RentalState> build() async {
    final rentalProvider = ref.read(rentalRequestServiceProvider);
    final authState = ref.read(authNotifierProvider);
    final requests = await rentalProvider.getUserRentalRequestsReceived(authState.requireValue.user!.id);
    return RentalState(requests: requests);
  }
}