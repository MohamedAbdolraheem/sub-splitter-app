import 'package:flutter/material.dart';

/// App-wide color palette for consistent theming
class AppColors {
  // Primary Purple Colors (more vibrant and modern)
  static const Color primary = Color(0xFF7C4DFF); // Brighter purple
  static const Color primaryLight = Color(0xFFB085F5);
  static const Color primaryDark = Color(0xFF4A148C);

  // Secondary Colors (harmonious indigo)
  static const Color secondary = Color(0xFF3F51B5); // Modern indigo
  static const Color secondaryLight = Color(0xFF7986CB);
  static const Color secondaryDark = Color(0xFF1A237E);

  // Accent Colors (modern emerald)
  static const Color accent = Color(0xFF00C853); // Vibrant emerald
  static const Color accentLight = Color(0xFF69F0AE);
  static const Color accentDark = Color(0xFF1B5E20);

  // Status Colors (modern and accessible)
  static const Color success = Color(0xFF00C853); // Emerald green
  static const Color warning = Color(0xFFFF9800); // Vibrant orange
  static const Color error = Color(0xFFE53935); // Clear red
  static const Color info = Color(0xFF2196F3); // Material blue

  // Neutral Colors (modern grays)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA); // Slightly warmer
  static const Color background = Color(0xFFF5F7FA); // Cooler background
  static const Color onSurface = Color(0xFF212121); // Better contrast
  static const Color onSurfaceVariant = Color(0xFF424242);

  // Text Colors (better contrast and hierarchy)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF424242);
  static const Color textTertiary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Border Colors (more defined)
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFBDBDBD);

  // Shadow Colors (more subtle and modern)
  static const Color shadow = Color(0x1F000000); // 12% opacity
  static const Color shadowLight = Color(0x0F000000); // 6% opacity
  static const Color shadowDark = Color(0x3D000000); // 24% opacity

  // Group-specific Colors (harmonious palette)
  static const Color groupOwner = primary;
  static const Color groupMember = accent;
  static const Color groupPending = warning;
  static const Color groupInactive = textTertiary;

  // Cost/Financial Colors
  static const Color costTotal = primary;
  static const Color costUser = accent;
  static const Color costSavings = success;
  static const Color costOverdue = error;

  // Service Colors (using primary palette variations)
  static const Color serviceNetflix = Color(0xFFE50914);
  static const Color serviceSpotify = Color(0xFF1DB954);
  static const Color serviceAdobe = Color(0xFFFF0000);
  static const Color serviceDefault = primary;

  // Notification Colors
  static const Color notificationInfo = info;
  static const Color notificationSuccess = success;
  static const Color notificationWarning = warning;
  static const Color notificationError = error;

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = accent;
  static const Color buttonAccent = secondary;
  static const Color buttonDanger = error;
  static const Color buttonDisabled = textDisabled;

  // Card Colors
  static const Color cardBackground = surface;
  static const Color cardElevated = Color(0xFFFFFFFF);
  static const Color cardSelected = Color(0xFFF3E5F5); // Light purple tint

  // Divider Colors
  static const Color divider = border;
  static const Color dividerLight = borderLight;
  static const Color dividerDark = borderDark;

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xCC000000);

  // Modern Glass Effect Colors
  static const Color glassSurface = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x40FFFFFF);

  // Enhanced Status Colors with better accessibility
  static const Color successLight = Color(0xFFE8F5E8);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Modern Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  // Modern radial gradients
  static const RadialGradient primaryRadial = RadialGradient(
    colors: [primaryLight, primary],
    center: Alignment.topLeft,
    radius: 1.0,
  );

  // Status-specific gradients
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, Color(0xFFFFCDD2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  // Modern glassmorphism gradient
  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x80FFFFFF), Color(0x40FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
