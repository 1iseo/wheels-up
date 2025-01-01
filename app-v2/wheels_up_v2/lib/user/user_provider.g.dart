// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateUserProfileHash() => r'23d12d6606b61f1438ca35d669599901a8a6b6d2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [updateUserProfile].
@ProviderFor(updateUserProfile)
const updateUserProfileProvider = UpdateUserProfileFamily();

/// See also [updateUserProfile].
class UpdateUserProfileFamily extends Family<AsyncValue<void>> {
  /// See also [updateUserProfile].
  const UpdateUserProfileFamily();

  /// See also [updateUserProfile].
  UpdateUserProfileProvider call(
    UpdateUser updateUser,
  ) {
    return UpdateUserProfileProvider(
      updateUser,
    );
  }

  @override
  UpdateUserProfileProvider getProviderOverride(
    covariant UpdateUserProfileProvider provider,
  ) {
    return call(
      provider.updateUser,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateUserProfileProvider';
}

/// See also [updateUserProfile].
class UpdateUserProfileProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateUserProfile].
  UpdateUserProfileProvider(
    UpdateUser updateUser,
  ) : this._internal(
          (ref) => updateUserProfile(
            ref as UpdateUserProfileRef,
            updateUser,
          ),
          from: updateUserProfileProvider,
          name: r'updateUserProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateUserProfileHash,
          dependencies: UpdateUserProfileFamily._dependencies,
          allTransitiveDependencies:
              UpdateUserProfileFamily._allTransitiveDependencies,
          updateUser: updateUser,
        );

  UpdateUserProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.updateUser,
  }) : super.internal();

  final UpdateUser updateUser;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateUserProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateUserProfileProvider._internal(
        (ref) => create(ref as UpdateUserProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        updateUser: updateUser,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateUserProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateUserProfileProvider && other.updateUser == updateUser;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, updateUser.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateUserProfileRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `updateUser` of this provider.
  UpdateUser get updateUser;
}

class _UpdateUserProfileProviderElement
    extends AutoDisposeFutureProviderElement<void> with UpdateUserProfileRef {
  _UpdateUserProfileProviderElement(super.provider);

  @override
  UpdateUser get updateUser => (origin as UpdateUserProfileProvider).updateUser;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
