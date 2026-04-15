// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) =>
    _ExpenseModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      createdBy: json['created_by'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      splitType: json['split_type'] as String? ?? 'equal',
      note: json['note'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ExpenseParticipantModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ExpenseModelToJson(_ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'created_by': instance.createdBy,
      'title': instance.title,
      'amount': instance.amount,
      'currency': instance.currency,
      'split_type': instance.splitType,
      'note': instance.note,
      'created_at': instance.createdAt?.toIso8601String(),
      'participants': instance.participants,
    };

_ExpenseParticipantModel _$ExpenseParticipantModelFromJson(
  Map<String, dynamic> json,
) => _ExpenseParticipantModel(
  id: json['id'] as String,
  expenseId: json['expense_id'] as String,
  userId: json['user_id'] as String,
  amountOwed: (json['amount_owed'] as num?)?.toDouble() ?? 0,
  isPaid: json['is_paid'] as bool? ?? false,
);

Map<String, dynamic> _$ExpenseParticipantModelToJson(
  _ExpenseParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'expense_id': instance.expenseId,
  'user_id': instance.userId,
  'amount_owed': instance.amountOwed,
  'is_paid': instance.isPaid,
};
