import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF03A8A1);
const kGradientColor2 = Color(0xFF2CB892);
const kGradientColor3 = Color(0xFF4ECB84);

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kPrimaryColor, // Your primary color
  onPrimary: Colors.white, // Text color on primary
  primaryContainer:
      kPrimaryColor.withOpacity(0.2), // Lightened primary background
  onPrimaryContainer: kPrimaryColor, // Dark text on primary container
  primaryFixed: kPrimaryColor.withOpacity(0.8), // Less transparent primary
  primaryFixedDim: kPrimaryColor.withOpacity(0.6), // Dimmer primary
  onPrimaryFixed: Colors.white,
  onPrimaryFixedVariant: Colors.white,

  secondary: Colors.blue, // Secondary color, complementary to primary
  onSecondary: Colors.white, // Text color on secondary
  secondaryContainer: Colors.blue.withOpacity(0.2),
  onSecondaryContainer: Colors.blue,

  tertiary: Colors.purple, // Tertiary color
  onTertiary: Colors.white, // Text color on tertiary
  tertiaryContainer: Colors.purple.withOpacity(0.2),
  onTertiaryContainer: Colors.purple,

  error: Colors.red, // Error color
  onError: Colors.white, // Text color on error

  surface: const Color(0xFFEDFFF0), // Surface background color
  onSurface: Colors.black, // Text color on surface
  surfaceVariant: Colors.grey[200]!, // Light variant for surfaces
  onSurfaceVariant: Colors.black,

  background: Colors.white, // Background color
  onBackground: Colors.black, // Text color on background

  // Other optional colors
  outline: Colors.grey,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: kPrimaryColor, // Your primary color
  onPrimary: Colors.black, // Text color on primary
  primaryContainer:
      kPrimaryColor.withOpacity(0.3), // Lightened primary for dark background
  onPrimaryContainer: kPrimaryColor, // Dark text on primary container
  primaryFixed: kPrimaryColor.withOpacity(0.7), // Less transparent primary
  primaryFixedDim: kPrimaryColor.withOpacity(0.5), // Dimmer primary
  onPrimaryFixed: Colors.black,
  onPrimaryFixedVariant: Colors.black,

  secondary: Colors.blue, // Secondary color, complementary to primary
  onSecondary: Colors.black, // Text color on secondary
  secondaryContainer: Colors.blue.withOpacity(0.3),
  onSecondaryContainer: Colors.blue,

  tertiary: Colors.purple, // Tertiary color
  onTertiary: Colors.black, // Text color on tertiary
  tertiaryContainer: Colors.purple.withOpacity(0.3),
  onTertiaryContainer: Colors.purple,

  error: Colors.red, // Error color
  onError: Colors.black, // Text color on error

  surface: Colors.grey[850]!, // Dark surface color
  onSurface: Colors.white, // Text color on surface
  surfaceVariant: Colors.grey[800]!, // Dark variant for surfaces
  onSurfaceVariant: Colors.white,

  background: Colors.grey[900]!, // Dark background color
  onBackground: Colors.white, // Text color on background

  // Other optional colors
  outline: Colors.white70,
);
