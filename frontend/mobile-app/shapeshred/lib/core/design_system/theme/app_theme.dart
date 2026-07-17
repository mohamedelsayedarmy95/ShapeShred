// ENHANCED LIGHT THEME
// Fully integrated with the new design system tokens

import 'package:flutter/material.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';

/// Premium Light Theme
// Material Design 3 based with custom refinements
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // === COLOR SCHEME ===
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        shadow: AppColors.shadow,
      ),

      // === TYPOGRAPHY ===
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // === COMPONENT THEMES ===

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.lg),
            bottomRight: Radius.circular(AppRadius.lg),
          ),
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: AppIconSize.l,
        ),
        iconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: AppIconSize.l,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelSmall,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        shadowColor: AppColors.shadow.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          disabledBackgroundColor: AppColors.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.38),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.38),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal * 0.75,
            vertical: AppSpacing.buttonPaddingVertical * 0.75,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // OutlineButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.outline,
            width: AppBorderWidth.regular,
          ),
          disabledForegroundColor: AppColors.onSurface.withValues(alpha: 0.38),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      // Input fields (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingHorizontal,
          vertical: AppSpacing.inputPaddingVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.outline,
            width: AppBorderWidth.regular,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.outline,
            width: AppBorderWidth.regular,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppBorderWidth.regular * 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppBorderWidth.regular,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppBorderWidth.regular * 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.onSurface.withValues(alpha: 0.12),
            width: AppBorderWidth.regular,
          ),
        ),
        isDense: true,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        suffixIconColor: AppColors.onSurfaceVariant,
        prefixIconColor: AppColors.onSurfaceVariant,
        errorStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.error,
        ),
        helperStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all<Color>(AppColors.surface),
        side: WidgetStateBorderSide.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return BorderSide(
                color: AppColors.primary,
                width: 2.0,
              );
            }
            return BorderSide(
              color: AppColors.outline,
              width: 1.5,
            );
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(AppColors.surface),
        overlayColor: WidgetStateProperty.all<Color>(
          AppColors.primary.withValues(alpha: 0.12),
        ),
        splashRadius: 20,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            if (states.contains(WidgetState.disabled)) {
              return AppColors.onSurface.withValues(alpha: 0.38);
            }
            return AppColors.surface;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.36);
            }
            if (states.contains(WidgetState.disabled)) {
              return AppColors.onSurface.withValues(alpha: 0.12);
            }
            return AppColors.onSurface.withValues(alpha: 0.38);
          },
        ),
        trackOutlineColor: WidgetStateProperty.all<Color>(
          AppColors.outline,
        ),
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const Icon(Icons.check);
            }
            return null;
          },
        ),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.onSurface.withValues(alpha: 0.12),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.onPrimary,
        ),
        thumbShape: const RoundSliderThumbShape(),
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        // valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
        // showValueIndicator: ShowValueIndicator.onlyDiscrete,
      ),

      // TabBar
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelSmall,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
          insets: const EdgeInsets.symmetric(
            horizontal: AppSpacing.componentSm,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: AppSpacing.dividerThicknessThin,
        space: AppSpacing.layoutSm,
      ),

      // Dialog (also styles AlertDialog and SimpleDialog)
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        elevation: 4,
        contentTextStyle: AppTypography.bodyLarge,
        titleTextStyle: AppTypography.titleLarge,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.all(AppSpacing.componentMd),
        margin: const EdgeInsets.all(AppSpacing.xsmall),
        verticalOffset: 24,
        preferBelow: false,
        showDuration: AppDurations.slow,
        waitDuration: AppDurations.standard,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTypography.bodyLarge,
        actionTextColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        insetPadding: const EdgeInsets.all(AppSpacing.layoutLg),
      ),

      // Animated theme transitions (custom)
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _CustomPageTransitionBuilder(),
          TargetPlatform.iOS: _CupertinoPageTransitionBuilder(),
          TargetPlatform.fuchsia: _CustomPageTransitionBuilder(),
          TargetPlatform.linux: _CustomPageTransitionBuilder(),
          TargetPlatform.macOS: _CustomPageTransitionBuilder(),
          TargetPlatform.windows: _CustomPageTransitionBuilder(),
        },
      ),
    );
  }

  // Custom page transition builder (would use our motion system)
  static PageTransitionsBuilder _CustomPageTransitionBuilder() {
    return _CustomPageTransition();
  }

  static PageTransitionsBuilder _CupertinoPageTransitionBuilder() {
    return _CupertinoPageTransition();
  }
}

// Custom transition using our motion system
class _CustomPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<dynamic> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: AppCurves.standard),
      child: child,
    );
  }
}

// Cupertino-style transition for iOS
class _CupertinoPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<dynamic> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppCurves.standard,
      )),
      child: child,
    );
  }
}
