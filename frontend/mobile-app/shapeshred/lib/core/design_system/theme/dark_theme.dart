// ENHANCED DARK THEME
// Fully integrated with the new design system tokens

import 'package:flutter/material.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';

/// Premium Dark Theme
// Material Design 3 based with custom refinements
class AppDarkTheme {
  AppDarkTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // === COLOR SCHEME ===
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        error: AppColors.error,
        onError: AppColors.onError,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        shadow: AppColors.shadow,
        scrimColor: AppColors.shadow.withOpacity(0.5),
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
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        shadowColor: AppColors.shadow.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          disabledBackgroundColor: AppColors.onSurface.withOpacity(0.12),
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
          padding: EdgeInsets.symmetric(
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
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
          padding: EdgeInsets.symmetric(
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
        contentPadding: EdgeInsets.symmetric(
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
            color: AppColors.onSurface.withOpacity(0.12),
            width: AppBorderWidth.regular,
          ),
        ),
        isDense: true,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant.withOpacity(0.6),
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
        fillColor: MaterialStateProperty.all<Color>(AppColors.surface),
        side: MaterialStateBorderSide.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
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
        fillColor: MaterialStateProperty.all<Color>(AppColors.surface),
        overlayColor: MaterialStateProperty.all<Color>(
          AppColors.primary.withOpacity(0.12),
        ),
        splashRadius: 20,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary;
            }
            if (states.contains(MaterialState.disabled)) {
              return AppColors.onSurface.withOpacity(0.38);
            }
            return AppColors.surface;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.primary.withOpacity(0.36);
            }
            if (states.contains(MaterialState.disabled)) {
              return AppColors.onSurface.withOpacity(0.12);
            }
            return AppColors.onSurface.withOpacity(0.38);
          },
        ),
        trackOutlineColor: MaterialStateProperty.all<Color>(
          AppColors.outline,
        ),
        thumbIcon: MaterialStateProperty.resolveWith<IconSize>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return const Icon(Icons.check);
            }
            return null;
          },
        ),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.onSurface.withOpacity(0.12),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.12),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.onPrimary,
        ),
        thumbShape: const RoundSliderThumbShape(enabledRadius: 12.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
        showValueIndicator: ShowValueIndicator.onlyDiscrete,
      ),

      // TabBar
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelSmall,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
          insets: EdgeInsets.symmetric(
            horizontal: AppSpacing.layoutSm,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: AppDividerThickness.regular,
        space: APSpacing.layoutSm,
      ),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        elevation: 4,
        contentTextStyle: AppTypography.bodyLarge,
        titleTextStyle: AppTypography.titleLarge,
      ),

      // AlertDialog
      alertDialogTheme: AlertDialogTheme(
        backgroundColor: AppColors.surface,
        titleTextStyle: AppTypography.titleLarge,
        contentTextStyle: AppTypography.bodyLarge,
        actionsPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.all(APSpacing.contentMd),
      ),

      // SimpleDialog
      simpleDialogTheme: SimpleDialogTheme(
        backgroundColor: AppColors.surface,
        titleTextStyle: AppTypography.titleLarge,
        contentTextStyle: AppTypography.bodyLarge,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: AppTypography.labelMedium,
        padding: EdgeInsets.all(APSpacing.paddingSm),
        margin: EdgeInsets.all(APSpacing.marginSm),
        height: 36,
        verticalOffset: 24,
        preferBelow: false,
        showDuration: APDurations.tooltipShow,
        waitDuration: APDurations.tooltipHide,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTypography.bodyLarge,
        actionTextStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: EdgeInsets.all(APSpacing.marginLg),
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
    return (_, __, ___) => _CustomPageTransition();
  }

  static PageTransitionsBuilder _CupertinoPageTransitionBuilder() {
    return (_, __, ___) => _CupertinoPageTransition();
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
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.standard,
      ),
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.standard,
        ),
        child: child,
      ),
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
        curve: Curves.standard,
      )),
      child: child,
    );
  }
}