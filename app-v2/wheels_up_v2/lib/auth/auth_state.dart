import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wheels_up_v2/user/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
  }) = _AuthState;
}
