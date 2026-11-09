import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'glass_tokens.dart';
import 'typography.dart';

export 'app_colors.dart';
export 'glass_tokens.dart';
export 'typography.dart';

/// "Aurora Glass" theme for FinNest.
///
/// Material components are themed to look like frosted glass out of the
/// box (translucent fills, hairline light borders, large radii), so plain
/// `Card`, `TextField`, `AlertDialog` etc. already fit. Richer pieces
/// (aurora background, blurred cards, glass icons, gradient buttons) live
/// in `core/widgets/glass/`.
class AppTheme {
  AppTheme._();

  static const double radiusS = 12;
  static const double radiusM = 18;
  static const double radiusL = 24;
  static const double radiusXL = 32;

  static ThemeData get darkTheme => _build(Brightness.dark);
  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final glass = isDark ? GlassTokens.dark : GlassTokens.light;
    final text = glass.textPrimary;
    final muted = glass.textMuted;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? const Color(0xFFA78BFA) : const Color(0xFF6D4AE8),
      onPrimary: Colors.white,
      primaryContainer:
          isDark ? const Color(0x406D5DFC) : const Color(0xFFE4DDFF),
      onPrimaryContainer: isDark ? const Color(0xFFE9E3FF) : const Color(0xFF22125E),
      secondary: isDark ? AppColors.cyan : const Color(0xFF0891B2),
      onSecondary: isDark ? const Color(0xFF00242C) : Colors.white,
      secondaryContainer:
          isDark ? const Color(0x3322D3EE) : const Color(0xFFD3F6FC),
      onSecondaryContainer:
          isDark ? const Color(0xFFCFF8FF) : const Color(0xFF003642),
      tertiary: isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
      onTertiary: Colors.white,
      tertiaryContainer:
          isDark ? const Color(0x33EC4899) : const Color(0xFFFFD9EA),
      onTertiaryContainer:
          isDark ? const Color(0xFFFFD9EA) : const Color(0xFF3E0021),
      error: isDark ? AppColors.expense : AppColors.expenseDeep,
      onError: Colors.white,
      errorContainer: isDark ? const Color(0x33FB7185) : const Color(0xFFFFE0E5),
      onErrorContainer: isDark ? const Color(0xFFFFD9DE) : const Color(0xFF5C0016),
      surface: isDark ? AppColors.darkBase2 : const Color(0xFFF8F7FF),
      onSurface: text,
      onSurfaceVariant: muted,
      surfaceContainerLowest:
          isDark ? const Color(0xFF080C20) : Colors.white,
      surfaceContainerLow:
          isDark ? const Color(0xFF111735) : const Color(0xFFF6F5FF),
      surfaceContainer:
          isDark ? const Color(0xFF151C3E) : const Color(0xFFF0EEFF),
      surfaceContainerHigh:
          isDark ? const Color(0xFF1A2248) : const Color(0xFFEAE7FF),
      surfaceContainerHighest:
          isDark ? const Color(0xFF202953) : const Color(0xFFE3E0FA),
      outline: isDark ? const Color(0x40FFFFFF) : const Color(0x335B6386),
      outlineVariant:
          isDark ? const Color(0x1FFFFFFF) : const Color(0x1F5B6386),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? AppColors.darkText : AppColors.lightText,
      onInverseSurface: isDark ? AppColors.darkBase : Colors.white,
      inversePrimary: isDark ? const Color(0xFF6D4AE8) : const Color(0xFFA78BFA),
      surfaceTint: Colors.transparent,
    );

    final textTheme = AppTypography.textTheme(text, muted);

    final glassFill = isDark ? const Color(0x14FFFFFF) : const Color(0x99FFFFFF);
    final glassBorder = BorderSide(color: glass.border, width: 1);
    final sheetColor =
        isDark ? const Color(0xF0121838) : const Color(0xF2F7F6FF);

    final roundedM = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.body,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: glass.baseBottom,
      canvasColor: glass.baseBottom,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      extensions: [glass],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // ── App bar: transparent, floats over the aurora ────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: text, size: 22),
        actionsIconTheme: IconThemeData(color: text, size: 22),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),

      // ── Cards: translucent glass panes ──────────────────────────────
      cardTheme: CardThemeData(
        color: glassFill,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
          side: glassBorder,
        ),
      ),

      // ── Inputs: frosted, rounded, glowing focus ─────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0x12FFFFFF) : const Color(0xB3FFFFFF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        labelStyle: textTheme.bodyMedium?.copyWith(color: muted),
        floatingLabelStyle: textTheme.labelLarge?.copyWith(
          color: scheme.primary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: muted.withValues(alpha: 0.7),
        ),
        helperStyle: textTheme.bodySmall,
        prefixIconColor: muted,
        suffixIconColor: muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: glassBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: glassBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
      ),

      // ── Buttons ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 15),
          shape: roundedM,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 15),
          shape: roundedM,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          backgroundColor: glassFill,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: glassBorder,
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 15),
          shape: roundedM,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          shape: roundedM,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: text),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(glassBorder),
          shape: WidgetStatePropertyAll(roundedM),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? scheme.primary.withValues(alpha: isDark ? 0.28 : 0.16)
                : glassFill,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? scheme.primary : text,
          ),
        ),
      ),

      // ── Chips ───────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        color: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: isDark ? 0.30 : 0.18)
              : glassFill,
        ),
        backgroundColor: glassFill,
        selectedColor: scheme.primary.withValues(alpha: isDark ? 0.30 : 0.18),
        disabledColor: glassFill,
        side: glassBorder,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        labelStyle: textTheme.labelLarge?.copyWith(color: text),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: scheme.primary,
        ),
        checkmarkColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        showCheckmark: false,
      ),

      // ── Sheets, dialogs, menus, snackbars ───────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: sheetColor,
        modalBackgroundColor: sheetColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: muted.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(radiusXL),
          ),
          side: glassBorder,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: sheetColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
          side: glassBorder,
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: sheetColor,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: glass.shadow,
        textStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
          side: glassBorder,
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(sheetColor),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusM),
              side: glassBorder,
            ),
          ),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(sheetColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusM),
              side: glassBorder,
            ),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? const Color(0xF2202953) : const Color(0xF20E1330),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        actionTextColor: AppColors.cyan,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xF2202953) : const Color(0xF20E1330),
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: textTheme.labelMedium?.copyWith(color: Colors.white),
      ),

      // ── Lists, toggles, progress ────────────────────────────────────
      listTileTheme: ListTileThemeData(
        iconColor: muted,
        textColor: text,
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: roundedM,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : glassFill,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.transparent
              : glass.border,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: muted, width: 1.4),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : muted,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: glassFill,
        thumbColor: Colors.white,
        overlayColor: scheme.primary.withValues(alpha: 0.15),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: isDark ? const Color(0x1AFFFFFF) : const Color(0x14000000),
        circularTrackColor: Colors.transparent,
        linearMinHeight: 8,
        borderRadius: BorderRadius.circular(8),
      ),
      dividerTheme: DividerThemeData(
        color: glass.border,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: text,
        unselectedLabelColor: muted,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: scheme.primary.withValues(alpha: isDark ? 0.28 : 0.16),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: 0.25),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: sheetColor,
        surfaceTintColor: Colors.transparent,
        headerHeadlineStyle: textTheme.headlineSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
          side: glassBorder,
        ),
        dayShape: const WidgetStatePropertyAll(CircleBorder()),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: sheetColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
          side: glassBorder,
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: text,
        collapsedIconColor: muted,
        shape: const Border(),
        collapsedShape: const Border(),
      ),
    );
  }
}
