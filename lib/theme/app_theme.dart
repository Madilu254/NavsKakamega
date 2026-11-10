import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ═══════════════════════════════════════════════════════════════
  // NAVSKACH PRIMARY IDENTITY
  // ═══════════════════════════════════════════════════════════════

  /// Primary warm cream/beige background
  static const Color primaryBg = Color(0xFFE0D4BC);

  /// Orange accent — CTAs, active indicators, highlights
  static const Color accent = Color(0xFFE36B2C);

  /// Foreground green — brand, navigation, identity
  static const Color primary = Color(0xFF008250);

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUND SHADES (for organic shapes & tonal variation)
  // ═══════════════════════════════════════════════════════════════
  static const Color bgLight = Color(0xFFEAE0CC);    // Lighter cream
  static const Color bgDark = Color(0xFFD4C8B0);     // Darker cream
  static const Color bgWarm = Color(0xFFE8DCC6);     // Warm mid-tone
  static const Color bgSoft = Color(0xFFF2ECE0);     // Very light cream

  // ═══════════════════════════════════════════════════════════════
  // SURFACE COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color surface = Colors.white;
  static const Color surfaceWarm = Color(0xFFFFF8F2); // Warm white for cards
  static const Color surfaceElevated = Color(0xFFFFFBF7); // Slightly warmer
  static const Color cardSurface = Colors.white;

  // ═══════════════════════════════════════════════════════════════
  // GREEN SHADES
  // ═══════════════════════════════════════════════════════════════
  static const Color primaryDark = Color(0xFF006B42);
  static const Color primaryLight = Color(0xFF00A86B);
  static const Color primarySoft = Color(0xFFE0F5EC);  // Very soft green bg
  static const Color primaryMuted = Color(0xFF4DA882);  // Muted green

  // ═══════════════════════════════════════════════════════════════
  // ORANGE SHADES
  // ═══════════════════════════════════════════════════════════════
  static const Color accentDark = Color(0xFFC85A22);
  static const Color accentLight = Color(0xFFF08752);
  static const Color accentSoft = Color(0xFFFDE8DC);  // Very soft orange bg
  static const Color accentMuted = Color(0xFFE8956A);

  // ═══════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFF2C2418);    // Deep warm charcoal
  static const Color textSecondary = Color(0xFF7A7060);  // Warm gray
  static const Color textMuted = Color(0xFFA99E8F);      // Muted warm
  static const Color textLight = Color(0xFFC4BAA9);      // Light muted
  static const Color textOnPrimary = Colors.white;
  static const Color textOnAccent = Colors.white;

  // ═══════════════════════════════════════════════════════════════
  // BORDER & DIVIDER
  // ═══════════════════════════════════════════════════════════════
  static const Color border = Color(0xFFD8CCBA);
  static const Color borderLight = Color(0xFFE8DDD0);
  static const Color darkBorder = Color(0xFFBEB3A3);       // Darker border variant
  static const Color divider = Color(0xFFE0D6C8);
  static const Color subtleBorder = Color(0x1A2C2418); // 10% dark

  /// Alias for primary background
  static const Color background = primaryBg;

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color success = Color(0xFF008250);       // Green
  static const Color error = Color(0xFFD14343);
  static const Color warning = Color(0xFFE5A32B);
  static const Color info = Color(0xFF4A90D9);

  static const Color successSoft = Color(0xFFE0F5EC);
  static const Color errorSoft = Color(0xFFFDE8E8);
  static const Color warningSoft = Color(0xFFFFF3D6);
  static const Color infoSoft = Color(0xFFE3F0FF);

  // ═══════════════════════════════════════════════════════════════
  // CHAT COLORS (Warm WhatsApp-inspired)
  // ═══════════════════════════════════════════════════════════════
  static const Color chatBg = Color(0xFFF2ECE0);
  static const Color outgoingBubble = Color(0xFFD9EFDA);
  static const Color incomingBubble = Colors.white;
  static const Color unreadBadge = Color(0xFF008250);
  static const Color checkmarkBlue = Color(0xFF389FD6);
  static const Color onlineGreen = Color(0xFF25D366);

  // ═══════════════════════════════════════════════════════════════
  // SPECIAL PURPOSE
  // ═══════════════════════════════════════════════════════════════
  static const Color staffGold = Color(0xFFE1AF38);
  static const Color overlay = Color(0x662C2418);     // 40% dark overlay

  // ═══════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════

  /// Hero gradient for hero cards & carousel
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF006B42), Color(0xFF00A86B)],
  );

  /// Accent gradient for CTAs & buttons
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFE36B2C), Color(0xFFF08752)],
  );

  /// Warm subtle gradient for page backgrounds
  static const LinearGradient warmBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF2ECE0), Color(0xFFE0D4BC)],
  );

  /// Dark overlay gradient for images
  static const LinearGradient imageOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  // ═══════════════════════════════════════════════════════════════
  // DESIGN TOKENS
  // ═══════════════════════════════════════════════════════════════

  // Border Radii
  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 999.0;

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Icon Sizes
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // Elevation / Shadow
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF2C2418).withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: const Color(0xFF2C2418).withValues(alpha: 0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: const Color(0xFF2C2418).withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get accentGlowShadow => [
    BoxShadow(
      color: accent.withValues(alpha: 0.30),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animCarousel = Duration(milliseconds: 400);

  // Animation Curves
  static const Curve curveDefault = Curves.easeOutCubic;
  static const Curve curveSnap = Curves.easeOutBack;
  static const Curve curveSmooth = Curves.easeInOutCubic;

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME COLORS
  // ═══════════════════════════════════════════════════════════════
  static const Color _darkBg = Color(0xFF1A1612);
  static const Color _darkSurface = Color(0xFF252018);
  static const Color _darkCard = Color(0xFF2E281E);
  static const Color _darkElevated = Color(0xFF363024);
  static const Color _darkBorder = Color(0xFF3E3628);
  static const Color _darkTextPrimary = Color(0xFFF2ECE0);
  static const Color _darkTextSecondary = Color(0xFFBDB4A4);
  static const Color _darkTextMuted = Color(0xFF8A8070);

  // ═══════════════════════════════════════════════════════════════
  // TYPOGRAPHY — Google Fonts Inter
  // ═══════════════════════════════════════════════════════════════

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        height: 1.25,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.3,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.3,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.3,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = _buildTextTheme(base.textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
        onPrimary: textOnPrimary,
        onSecondary: textOnAccent,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: primaryBg,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWarm,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceWarm,
        selectedColor: primary,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        side: const BorderSide(color: borderLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        elevation: 8,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: primary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textMuted,
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _buildTextTheme(base.textTheme).apply(
      bodyColor: _darkTextPrimary,
      displayColor: _darkTextPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primaryLight,
        secondary: accentLight,
        surface: _darkSurface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _darkTextPrimary,
      ),
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: _darkTextPrimary, size: 22),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: _darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        hintStyle: GoogleFonts.inter(color: _darkTextMuted, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: _darkTextSecondary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: const BorderSide(color: primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentLight,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _darkElevated,
        selectedColor: primaryLight,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        side: BorderSide(color: _darkBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: DividerThemeData(
        color: _darkBorder,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: primaryLight,
        unselectedItemColor: _darkTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkElevated,
        contentTextStyle: GoogleFonts.inter(color: _darkTextPrimary, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        titleTextStyle: GoogleFonts.inter(
          color: _darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: _darkCard,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        elevation: 8,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurface,
        indicatorColor: primaryDark.withValues(alpha: 0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: primaryLight,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _darkTextMuted,
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// NAVSKACH TEXT STYLES — Named convenience accessors
// ═══════════════════════════════════════════════════════════════

class NavskachTextStyles {
  static TextStyle get displayLg => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppTheme.textPrimary,
  );

  static TextStyle get displayMd => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppTheme.textPrimary,
  );

  static TextStyle get headingLg => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
    color: AppTheme.textPrimary,
  );

  static TextStyle get headingMd => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
    color: AppTheme.textPrimary,
  );

  static TextStyle get headingSm => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.4,
    color: AppTheme.textPrimary,
  );

  static TextStyle get bodyLg => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppTheme.textPrimary,
  );

  static TextStyle get bodyMd => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppTheme.textPrimary,
  );

  static TextStyle get bodySm => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppTheme.textSecondary,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.3,
    color: AppTheme.textMuted,
  );

  static TextStyle get label => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.3,
    color: AppTheme.textSecondary,
  );

  static TextStyle get labelBold => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppTheme.textPrimary,
  );

  static TextStyle get button => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static TextStyle get badge => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
    height: 1.0,
  );
}

// ═══════════════════════════════════════════════════════════════
// NAVSKACH DECORATIONS — Reusable decoration presets
// ═══════════════════════════════════════════════════════════════

class NavskachDecorations {
  /// Standard white card with subtle shadow
  static BoxDecoration get card => BoxDecoration(
    color: AppTheme.cardSurface,
    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
    boxShadow: AppTheme.cardShadow,
  );

  /// Elevated card with stronger shadow
  static BoxDecoration get elevatedCard => BoxDecoration(
    color: AppTheme.cardSurface,
    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
    boxShadow: AppTheme.elevatedShadow,
  );

  /// Subtle card with minimal shadow
  static BoxDecoration get subtleCard => BoxDecoration(
    color: AppTheme.cardSurface,
    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
    boxShadow: AppTheme.subtleShadow,
  );

  /// Warm-tinted card
  static BoxDecoration get warmCard => BoxDecoration(
    color: AppTheme.surfaceWarm,
    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
    boxShadow: AppTheme.cardShadow,
  );

  /// Soft green-tinted container
  static BoxDecoration get primarySoftContainer => BoxDecoration(
    color: AppTheme.primarySoft,
    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
  );

  /// Soft orange-tinted container
  static BoxDecoration get accentSoftContainer => BoxDecoration(
    color: AppTheme.accentSoft,
    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
  );

  /// Hero card with green gradient
  static BoxDecoration get heroCard => BoxDecoration(
    gradient: AppTheme.heroGradient,
    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
    boxShadow: AppTheme.glowShadow,
  );

  /// Small rounded pill (badges, tags)
  static BoxDecoration pill(Color bg) => BoxDecoration(
    color: bg,
    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
  );

  /// Circular icon container
  static BoxDecoration iconCircle(Color bg) => BoxDecoration(
    color: bg,
    shape: BoxShape.circle,
  );

  /// Bottom nav container decoration
  static BoxDecoration get bottomNav => BoxDecoration(
    color: AppTheme.surface,
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF2C2418).withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, -4),
      ),
    ],
  );

  /// Input field container
  static BoxDecoration get inputField => BoxDecoration(
    color: AppTheme.surfaceWarm,
    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
    border: Border.all(color: AppTheme.borderLight, width: 1),
  );
}
