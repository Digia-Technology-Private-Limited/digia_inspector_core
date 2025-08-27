import 'package:flutter/foundation.dart';

/// Environment utilities for controlling inspector inclusion in builds.
class DigiaEnvironment {
  /// Whether the Digia Inspector should be enabled in the current build.
  ///
  /// This checks the `DIGIA_INSPECTOR` environment variable first, then
  /// falls back to `kDebugMode`. This allows forcing inspector inclusion
  /// in release builds for dashboard and preview apps while excluding it
  /// from other production apps.
  ///
  /// To enable in release builds, compile with:
  /// `--dart-define=DIGIA_INSPECTOR=true`
  static const bool kDigiaInspectorEnabled = bool.fromEnvironment(
    'DIGIA_INSPECTOR',
    defaultValue: kDebugMode,
  );

  /// Returns true if the inspector should be included in the current build.
  ///
  /// This is a convenience getter for [kDigiaInspectorEnabled].
  static bool get isInspectorEnabled => kDigiaInspectorEnabled;

  /// Returns true if running in debug mode.
  static bool get isDebugMode => kDebugMode;

  /// Returns true if running in release mode.
  static bool get isReleaseMode => kReleaseMode;

  /// Returns true if running in profile mode.
  static bool get isProfileMode => kProfileMode;
}
