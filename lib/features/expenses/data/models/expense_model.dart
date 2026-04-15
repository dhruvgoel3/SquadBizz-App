import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

/// Immutable expense model with JSON serialization.
@freezed
abstract class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'created_by') required String createdBy,
    required String title,
    required double amount,
    @Default('INR') String currency,
    @JsonKey(name: 'split_type') @Default('equal') String splitType,
    String? note,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default([]) List<ExpenseParticipantModel> participants,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
}

/// A participant in an expense split.
@freezed
abstract class ExpenseParticipantModel with _$ExpenseParticipantModel {
  const factory ExpenseParticipantModel({
    required String id,
    @JsonKey(name: 'expense_id') required String expenseId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'amount_owed') @Default(0) double amountOwed,
    @JsonKey(name: 'is_paid') @Default(false) bool isPaid,
  }) = _ExpenseParticipantModel;

  factory ExpenseParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseParticipantModelFromJson(json);
}
