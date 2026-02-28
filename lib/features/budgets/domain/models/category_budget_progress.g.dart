// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_budget_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryBudgetProgressImpl _$$CategoryBudgetProgressImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryBudgetProgressImpl(
  categoryId: (json['categoryId'] as num).toInt(),
  categoryName: json['categoryName'] as String,
  categoryIcon: json['categoryIcon'] as String?,
  categoryColor: json['categoryColor'] as String?,
  budgetLimitInCents: (json['budgetLimitInCents'] as num?)?.toInt(),
  spentInCents: (json['spentInCents'] as num).toInt(),
  progressPercentage: (json['progressPercentage'] as num).toDouble(),
  status: $enumDecode(_$BudgetStatusEnumMap, json['status']),
  remainingInCents: (json['remainingInCents'] as num).toInt(),
);

Map<String, dynamic> _$$CategoryBudgetProgressImplToJson(
  _$CategoryBudgetProgressImpl instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'categoryIcon': instance.categoryIcon,
  'categoryColor': instance.categoryColor,
  'budgetLimitInCents': instance.budgetLimitInCents,
  'spentInCents': instance.spentInCents,
  'progressPercentage': instance.progressPercentage,
  'status': _$BudgetStatusEnumMap[instance.status]!,
  'remainingInCents': instance.remainingInCents,
};

const _$BudgetStatusEnumMap = {
  BudgetStatus.onTrack: 'onTrack',
  BudgetStatus.nearLimit: 'nearLimit',
  BudgetStatus.overBudget: 'overBudget',
  BudgetStatus.noBudget: 'noBudget',
};
