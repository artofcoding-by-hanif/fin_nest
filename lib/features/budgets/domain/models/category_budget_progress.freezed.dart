// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_budget_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryBudgetProgress _$CategoryBudgetProgressFromJson(
  Map<String, dynamic> json,
) {
  return _CategoryBudgetProgress.fromJson(json);
}

/// @nodoc
mixin _$CategoryBudgetProgress {
  /// Category ID
  int get categoryId => throw _privateConstructorUsedError;

  /// Category name
  String get categoryName => throw _privateConstructorUsedError;

  /// Category icon name
  String? get categoryIcon => throw _privateConstructorUsedError;

  /// Category color (hex code)
  String? get categoryColor => throw _privateConstructorUsedError;

  /// Budget limit in cents (null if no budget set)
  int? get budgetLimitInCents => throw _privateConstructorUsedError;

  /// Amount spent in cents for current month
  int get spentInCents => throw _privateConstructorUsedError;

  /// Progress percentage (0-100+)
  double get progressPercentage => throw _privateConstructorUsedError;

  /// Budget status
  BudgetStatus get status => throw _privateConstructorUsedError;

  /// Remaining amount in cents (can be negative if over budget)
  int get remainingInCents => throw _privateConstructorUsedError;

  /// Serializes this CategoryBudgetProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryBudgetProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryBudgetProgressCopyWith<CategoryBudgetProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryBudgetProgressCopyWith<$Res> {
  factory $CategoryBudgetProgressCopyWith(
    CategoryBudgetProgress value,
    $Res Function(CategoryBudgetProgress) then,
  ) = _$CategoryBudgetProgressCopyWithImpl<$Res, CategoryBudgetProgress>;
  @useResult
  $Res call({
    int categoryId,
    String categoryName,
    String? categoryIcon,
    String? categoryColor,
    int? budgetLimitInCents,
    int spentInCents,
    double progressPercentage,
    BudgetStatus status,
    int remainingInCents,
  });
}

/// @nodoc
class _$CategoryBudgetProgressCopyWithImpl<
  $Res,
  $Val extends CategoryBudgetProgress
>
    implements $CategoryBudgetProgressCopyWith<$Res> {
  _$CategoryBudgetProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryBudgetProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? categoryColor = freezed,
    Object? budgetLimitInCents = freezed,
    Object? spentInCents = null,
    Object? progressPercentage = null,
    Object? status = null,
    Object? remainingInCents = null,
  }) {
    return _then(
      _value.copyWith(
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryIcon: freezed == categoryIcon
                ? _value.categoryIcon
                : categoryIcon // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryColor: freezed == categoryColor
                ? _value.categoryColor
                : categoryColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            budgetLimitInCents: freezed == budgetLimitInCents
                ? _value.budgetLimitInCents
                : budgetLimitInCents // ignore: cast_nullable_to_non_nullable
                      as int?,
            spentInCents: null == spentInCents
                ? _value.spentInCents
                : spentInCents // ignore: cast_nullable_to_non_nullable
                      as int,
            progressPercentage: null == progressPercentage
                ? _value.progressPercentage
                : progressPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BudgetStatus,
            remainingInCents: null == remainingInCents
                ? _value.remainingInCents
                : remainingInCents // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryBudgetProgressImplCopyWith<$Res>
    implements $CategoryBudgetProgressCopyWith<$Res> {
  factory _$$CategoryBudgetProgressImplCopyWith(
    _$CategoryBudgetProgressImpl value,
    $Res Function(_$CategoryBudgetProgressImpl) then,
  ) = __$$CategoryBudgetProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int categoryId,
    String categoryName,
    String? categoryIcon,
    String? categoryColor,
    int? budgetLimitInCents,
    int spentInCents,
    double progressPercentage,
    BudgetStatus status,
    int remainingInCents,
  });
}

/// @nodoc
class __$$CategoryBudgetProgressImplCopyWithImpl<$Res>
    extends
        _$CategoryBudgetProgressCopyWithImpl<$Res, _$CategoryBudgetProgressImpl>
    implements _$$CategoryBudgetProgressImplCopyWith<$Res> {
  __$$CategoryBudgetProgressImplCopyWithImpl(
    _$CategoryBudgetProgressImpl _value,
    $Res Function(_$CategoryBudgetProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryBudgetProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? categoryIcon = freezed,
    Object? categoryColor = freezed,
    Object? budgetLimitInCents = freezed,
    Object? spentInCents = null,
    Object? progressPercentage = null,
    Object? status = null,
    Object? remainingInCents = null,
  }) {
    return _then(
      _$CategoryBudgetProgressImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryIcon: freezed == categoryIcon
            ? _value.categoryIcon
            : categoryIcon // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryColor: freezed == categoryColor
            ? _value.categoryColor
            : categoryColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        budgetLimitInCents: freezed == budgetLimitInCents
            ? _value.budgetLimitInCents
            : budgetLimitInCents // ignore: cast_nullable_to_non_nullable
                  as int?,
        spentInCents: null == spentInCents
            ? _value.spentInCents
            : spentInCents // ignore: cast_nullable_to_non_nullable
                  as int,
        progressPercentage: null == progressPercentage
            ? _value.progressPercentage
            : progressPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BudgetStatus,
        remainingInCents: null == remainingInCents
            ? _value.remainingInCents
            : remainingInCents // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryBudgetProgressImpl extends _CategoryBudgetProgress {
  const _$CategoryBudgetProgressImpl({
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    this.budgetLimitInCents,
    required this.spentInCents,
    required this.progressPercentage,
    required this.status,
    required this.remainingInCents,
  }) : super._();

  factory _$CategoryBudgetProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryBudgetProgressImplFromJson(json);

  /// Category ID
  @override
  final int categoryId;

  /// Category name
  @override
  final String categoryName;

  /// Category icon name
  @override
  final String? categoryIcon;

  /// Category color (hex code)
  @override
  final String? categoryColor;

  /// Budget limit in cents (null if no budget set)
  @override
  final int? budgetLimitInCents;

  /// Amount spent in cents for current month
  @override
  final int spentInCents;

  /// Progress percentage (0-100+)
  @override
  final double progressPercentage;

  /// Budget status
  @override
  final BudgetStatus status;

  /// Remaining amount in cents (can be negative if over budget)
  @override
  final int remainingInCents;

  @override
  String toString() {
    return 'CategoryBudgetProgress(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, categoryColor: $categoryColor, budgetLimitInCents: $budgetLimitInCents, spentInCents: $spentInCents, progressPercentage: $progressPercentage, status: $status, remainingInCents: $remainingInCents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryBudgetProgressImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.categoryColor, categoryColor) ||
                other.categoryColor == categoryColor) &&
            (identical(other.budgetLimitInCents, budgetLimitInCents) ||
                other.budgetLimitInCents == budgetLimitInCents) &&
            (identical(other.spentInCents, spentInCents) ||
                other.spentInCents == spentInCents) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.remainingInCents, remainingInCents) ||
                other.remainingInCents == remainingInCents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    categoryName,
    categoryIcon,
    categoryColor,
    budgetLimitInCents,
    spentInCents,
    progressPercentage,
    status,
    remainingInCents,
  );

  /// Create a copy of CategoryBudgetProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryBudgetProgressImplCopyWith<_$CategoryBudgetProgressImpl>
  get copyWith =>
      __$$CategoryBudgetProgressImplCopyWithImpl<_$CategoryBudgetProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryBudgetProgressImplToJson(this);
  }
}

abstract class _CategoryBudgetProgress extends CategoryBudgetProgress {
  const factory _CategoryBudgetProgress({
    required final int categoryId,
    required final String categoryName,
    final String? categoryIcon,
    final String? categoryColor,
    final int? budgetLimitInCents,
    required final int spentInCents,
    required final double progressPercentage,
    required final BudgetStatus status,
    required final int remainingInCents,
  }) = _$CategoryBudgetProgressImpl;
  const _CategoryBudgetProgress._() : super._();

  factory _CategoryBudgetProgress.fromJson(Map<String, dynamic> json) =
      _$CategoryBudgetProgressImpl.fromJson;

  /// Category ID
  @override
  int get categoryId;

  /// Category name
  @override
  String get categoryName;

  /// Category icon name
  @override
  String? get categoryIcon;

  /// Category color (hex code)
  @override
  String? get categoryColor;

  /// Budget limit in cents (null if no budget set)
  @override
  int? get budgetLimitInCents;

  /// Amount spent in cents for current month
  @override
  int get spentInCents;

  /// Progress percentage (0-100+)
  @override
  double get progressPercentage;

  /// Budget status
  @override
  BudgetStatus get status;

  /// Remaining amount in cents (can be negative if over budget)
  @override
  int get remainingInCents;

  /// Create a copy of CategoryBudgetProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryBudgetProgressImplCopyWith<_$CategoryBudgetProgressImpl>
  get copyWith => throw _privateConstructorUsedError;
}
