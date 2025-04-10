// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$guessResultHash() => r'a2edffb2fadd072af118ccedf6abc27905cc3ef6';

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

/// See also [guessResult].
@ProviderFor(guessResult)
const guessResultProvider = GuessResultFamily();

/// See also [guessResult].
class GuessResultFamily extends Family<AsyncValue<GuessResponses?>> {
  /// See also [guessResult].
  const GuessResultFamily();

  /// See also [guessResult].
  GuessResultProvider call(
    Stream<int> guesses,
  ) {
    return GuessResultProvider(
      guesses,
    );
  }

  @override
  GuessResultProvider getProviderOverride(
    covariant GuessResultProvider provider,
  ) {
    return call(
      provider.guesses,
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
  String? get name => r'guessResultProvider';
}

/// See also [guessResult].
class GuessResultProvider extends AutoDisposeStreamProvider<GuessResponses?> {
  /// See also [guessResult].
  GuessResultProvider(
    Stream<int> guesses,
  ) : this._internal(
          (ref) => guessResult(
            ref as GuessResultRef,
            guesses,
          ),
          from: guessResultProvider,
          name: r'guessResultProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$guessResultHash,
          dependencies: GuessResultFamily._dependencies,
          allTransitiveDependencies:
              GuessResultFamily._allTransitiveDependencies,
          guesses: guesses,
        );

  GuessResultProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.guesses,
  }) : super.internal();

  final Stream<int> guesses;

  @override
  Override overrideWith(
    Stream<GuessResponses?> Function(GuessResultRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GuessResultProvider._internal(
        (ref) => create(ref as GuessResultRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        guesses: guesses,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<GuessResponses?> createElement() {
    return _GuessResultProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuessResultProvider && other.guesses == guesses;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guesses.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GuessResultRef on AutoDisposeStreamProviderRef<GuessResponses?> {
  /// The parameter `guesses` of this provider.
  Stream<int> get guesses;
}

class _GuessResultProviderElement
    extends AutoDisposeStreamProviderElement<GuessResponses?>
    with GuessResultRef {
  _GuessResultProviderElement(super.provider);

  @override
  Stream<int> get guesses => (origin as GuessResultProvider).guesses;
}

String _$loadingGuessResultHash() =>
    r'b5f74ed1452661e65e3637f90cd45fa17fe774b0';

/// See also [loadingGuessResult].
@ProviderFor(loadingGuessResult)
final loadingGuessResultProvider =
    AutoDisposeProvider<ValueNotifier<bool>>.internal(
  loadingGuessResult,
  name: r'loadingGuessResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loadingGuessResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoadingGuessResultRef = AutoDisposeProviderRef<ValueNotifier<bool>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
