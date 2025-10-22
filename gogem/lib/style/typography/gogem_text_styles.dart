import 'package:flutter/material.dart';

class GogemTextStyles {
  // Base Styles
  static const TextStyle _openSans = TextStyle(fontFamily: 'OpenSans');

  static const TextStyle _roboto = TextStyle(fontFamily: 'Roboto');

  /// Display (Judul besar) pakai OpenSans
  static TextStyle displayLarge = _openSans.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -2,
  );

  static TextStyle displayMedium = _openSans.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.17,
    letterSpacing: -1,
  );

  static TextStyle displaySmall = _openSans.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -1,
  );

  /// Headline pakai OpenSans
  static TextStyle headlineLarge = _openSans.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -1,
  );

  static TextStyle headlineMedium = _openSans.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: -1,
  );

  static TextStyle headlineSmall = _openSans.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -1,
  );

  /// Title pakai OpenSans
  static TextStyle titleLarge = _openSans.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.8,
  );

  static TextStyle titleMedium = _openSans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.8,
  );

  static TextStyle titleSmall = _openSans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: 0.8,
  );

  /// Body pakai Roboto
  static TextStyle bodyLargeBold = _roboto.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.56,
  );

  static TextStyle bodyLargeMedium = _roboto.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.56,
  );

  static TextStyle bodyLargeRegular = _roboto.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.56,
  );

  /// Label pakai Roboto
  static TextStyle labelLarge = _roboto.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.71,
    letterSpacing: 1.2,
  );

  static TextStyle labelMedium = _roboto.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.4,
    letterSpacing: 1.2,
  );

  static TextStyle labelSmall = _roboto.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w200,
    height: 1.2,
    letterSpacing: 1.2,
  );
}
