// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_budget_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryBudgetProgress {

/// Category ID
 int get categoryId;/// Category name
 String get categoryName;/// Category icon name
 String? get categoryIcon;/// Category color (hex code)
 String? get categoryColor;/// Budget limit in cents (null if no budget set)
 int? get budgetLimitInCents;/// Amount spent in cents for current month
 int get spentInCents;/// Progress percentage (0-100+)
 double get progressPercentage;/// Budget status
 BudgetStatus get status;/// Remaining amount in cents (can be negative if over budget)
 int get remainingInCents;
/// Create a copy of CategoryBudgetProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBudgetProgressCopyWith<CategoryBudgetProgress> get copyWith => _$CategoryBudgetProgressCopyWithImpl<CategoryBudgetProgress>(this as CategoryBudgetProgress, _$identity);

  /// Serializes this CategoryBudgetProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryBudgetProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBudgetProgress&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.categoryIcon, _this.categoryIcon) || other.categoryIcon == _this.categoryIcon)&&(identical(other.categoryColor, _this.categoryColor) || other.categoryColor == _this.categoryColor)&&(identical(other.budgetLimitInCents, _this.budgetLimitInCents) || other.budgetLimitInCents == _this.budgetLimitInCents)&&(identical(other.spentInCents, _this.spentInCents) || other.spentInCents == _this.spentInCents)&&(identical(other.progressPercentage, _this.progressPercentage) || other.progressPercentage == _this.progressPercentage)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.remainingInCents, _this.remainingInCents) || other.remainingInCents == _this.remainingInCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryBudgetProgress;
  return Object.hash(runtimeType,_this.categoryId,_this.categoryName,_this.categoryIcon,_this.categoryColor,_this.budgetLimitInCents,_this.spentInCents,_this.progressPercentage,_this.status,_this.remainingInCents);
}

@override
String toString() {
  final _this = this as CategoryBudgetProgress;
  return 'CategoryBudgetProgress(categoryId: ${_this.categoryId}, categoryName: ${_this.categoryName}, categoryIcon: ${_this.categoryIcon}, categoryColor: ${_this.categoryColor}, budgetLimitInCents: ${_this.budgetLimitInCents}, spentInCents: ${_this.spentInCents}, progressPercentage: ${_this.progressPercentage}, status: ${_this.status}, remainingInCents: ${_this.remainingInCents})';
}


}

/// @nodoc
abstract mixin class $CategoryBudgetProgressCopyWith<$Res>  {
  factory $CategoryBudgetProgressCopyWith(CategoryBudgetProgress value, $Res Function(CategoryBudgetProgress) _then) = _$CategoryBudgetProgressCopyWithImpl;
@useResult
$Res call({
 int categoryId, String categoryName, String? categoryIcon, String? categoryColor, int? budgetLimitInCents, int spentInCents, double progressPercentage, BudgetStatus status, int remainingInCents
});




}
/// @nodoc
class _$CategoryBudgetProgressCopyWithImpl<$Res>
    implements $CategoryBudgetProgressCopyWith<$Res> {
  _$CategoryBudgetProgressCopyWithImpl(this._self, this._then);

  final CategoryBudgetProgress _self;
  final $Res Function(CategoryBudgetProgress) _then;

/// Create a copy of CategoryBudgetProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? categoryIcon = freezed,Object? categoryColor = freezed,Object? budgetLimitInCents = freezed,Object? spentInCents = null,Object? progressPercentage = null,Object? status = null,Object? remainingInCents = null,}) {
  return _then(CategoryBudgetProgress(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,categoryColor: freezed == categoryColor ? _self.categoryColor : categoryColor // ignore: cast_nullable_to_non_nullable
as String?,budgetLimitInCents: freezed == budgetLimitInCents ? _self.budgetLimitInCents : budgetLimitInCents // ignore: cast_nullable_to_non_nullable
as int?,spentInCents: null == spentInCents ? _self.spentInCents : spentInCents // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,remainingInCents: null == remainingInCents ? _self.remainingInCents : remainingInCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBudgetProgress].
extension CategoryBudgetProgressPatterns on CategoryBudgetProgress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBudgetProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBudgetProgress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBudgetProgress value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBudgetProgress():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBudgetProgress value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBudgetProgress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int categoryId,  String categoryName,  String? categoryIcon,  String? categoryColor,  int? budgetLimitInCents,  int spentInCents,  double progressPercentage,  BudgetStatus status,  int remainingInCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBudgetProgress() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.categoryIcon,_that.categoryColor,_that.budgetLimitInCents,_that.spentInCents,_that.progressPercentage,_that.status,_that.remainingInCents);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int categoryId,  String categoryName,  String? categoryIcon,  String? categoryColor,  int? budgetLimitInCents,  int spentInCents,  double progressPercentage,  BudgetStatus status,  int remainingInCents)  $default,) {final _that = this;
switch (_that) {
case _CategoryBudgetProgress():
return $default(_that.categoryId,_that.categoryName,_that.categoryIcon,_that.categoryColor,_that.budgetLimitInCents,_that.spentInCents,_that.progressPercentage,_that.status,_that.remainingInCents);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int categoryId,  String categoryName,  String? categoryIcon,  String? categoryColor,  int? budgetLimitInCents,  int spentInCents,  double progressPercentage,  BudgetStatus status,  int remainingInCents)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBudgetProgress() when $default != null:
return $default(_that.categoryId,_that.categoryName,_that.categoryIcon,_that.categoryColor,_that.budgetLimitInCents,_that.spentInCents,_that.progressPercentage,_that.status,_that.remainingInCents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBudgetProgress extends CategoryBudgetProgress {
  const _CategoryBudgetProgress({required this.categoryId, required this.categoryName, this.categoryIcon, this.categoryColor, this.budgetLimitInCents, required this.spentInCents, required this.progressPercentage, required this.status, required this.remainingInCents}): super._();
  factory _CategoryBudgetProgress.fromJson(Map<String, dynamic> json) => _$CategoryBudgetProgressFromJson(json);

/// Category ID
@override final  int categoryId;
/// Category name
@override final  String categoryName;
/// Category icon name
@override final  String? categoryIcon;
/// Category color (hex code)
@override final  String? categoryColor;
/// Budget limit in cents (null if no budget set)
@override final  int? budgetLimitInCents;
/// Amount spent in cents for current month
@override final  int spentInCents;
/// Progress percentage (0-100+)
@override final  double progressPercentage;
/// Budget status
@override final  BudgetStatus status;
/// Remaining amount in cents (can be negative if over budget)
@override final  int remainingInCents;

/// Create a copy of CategoryBudgetProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBudgetProgressCopyWith<_CategoryBudgetProgress> get copyWith => __$CategoryBudgetProgressCopyWithImpl<_CategoryBudgetProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBudgetProgressToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBudgetProgress&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.categoryIcon, categoryIcon) || other.categoryIcon == categoryIcon)&&(identical(other.categoryColor, categoryColor) || other.categoryColor == categoryColor)&&(identical(other.budgetLimitInCents, budgetLimitInCents) || other.budgetLimitInCents == budgetLimitInCents)&&(identical(other.spentInCents, spentInCents) || other.spentInCents == spentInCents)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.status, status) || other.status == status)&&(identical(other.remainingInCents, remainingInCents) || other.remainingInCents == remainingInCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,categoryId,categoryName,categoryIcon,categoryColor,budgetLimitInCents,spentInCents,progressPercentage,status,remainingInCents);
}

@override
String toString() {
    return 'CategoryBudgetProgress(categoryId: $categoryId, categoryName: $categoryName, categoryIcon: $categoryIcon, categoryColor: $categoryColor, budgetLimitInCents: $budgetLimitInCents, spentInCents: $spentInCents, progressPercentage: $progressPercentage, status: $status, remainingInCents: $remainingInCents)';
}


}

/// @nodoc
abstract mixin class _$CategoryBudgetProgressCopyWith<$Res> implements $CategoryBudgetProgressCopyWith<$Res> {
  factory _$CategoryBudgetProgressCopyWith(_CategoryBudgetProgress value, $Res Function(_CategoryBudgetProgress) _then) = __$CategoryBudgetProgressCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String categoryName, String? categoryIcon, String? categoryColor, int? budgetLimitInCents, int spentInCents, double progressPercentage, BudgetStatus status, int remainingInCents
});




}
/// @nodoc
class __$CategoryBudgetProgressCopyWithImpl<$Res>
    implements _$CategoryBudgetProgressCopyWith<$Res> {
  __$CategoryBudgetProgressCopyWithImpl(this._self, this._then);

  final _CategoryBudgetProgress _self;
  final $Res Function(_CategoryBudgetProgress) _then;

/// Create a copy of CategoryBudgetProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? categoryIcon = freezed,Object? categoryColor = freezed,Object? budgetLimitInCents = freezed,Object? spentInCents = null,Object? progressPercentage = null,Object? status = null,Object? remainingInCents = null,}) {
  return _then(_CategoryBudgetProgress(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,categoryIcon: freezed == categoryIcon ? _self.categoryIcon : categoryIcon // ignore: cast_nullable_to_non_nullable
as String?,categoryColor: freezed == categoryColor ? _self.categoryColor : categoryColor // ignore: cast_nullable_to_non_nullable
as String?,budgetLimitInCents: freezed == budgetLimitInCents ? _self.budgetLimitInCents : budgetLimitInCents // ignore: cast_nullable_to_non_nullable
as int?,spentInCents: null == spentInCents ? _self.spentInCents : spentInCents // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,remainingInCents: null == remainingInCents ? _self.remainingInCents : remainingInCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
