// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseModel {

 String get id;@JsonKey(name: 'room_id') String get roomId;@JsonKey(name: 'created_by') String get createdBy; String get title; double get amount; String get currency;@JsonKey(name: 'split_type') String get splitType; String? get note;@JsonKey(name: 'created_at') DateTime? get createdAt; List<ExpenseParticipantModel> get participants;
/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseModelCopyWith<ExpenseModel> get copyWith => _$ExpenseModelCopyWithImpl<ExpenseModel>(this as ExpenseModel, _$identity);

  /// Serializes this ExpenseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.participants, participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,createdBy,title,amount,currency,splitType,note,createdAt,const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'ExpenseModel(id: $id, roomId: $roomId, createdBy: $createdBy, title: $title, amount: $amount, currency: $currency, splitType: $splitType, note: $note, createdAt: $createdAt, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $ExpenseModelCopyWith<$Res>  {
  factory $ExpenseModelCopyWith(ExpenseModel value, $Res Function(ExpenseModel) _then) = _$ExpenseModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'created_by') String createdBy, String title, double amount, String currency,@JsonKey(name: 'split_type') String splitType, String? note,@JsonKey(name: 'created_at') DateTime? createdAt, List<ExpenseParticipantModel> participants
});




}
/// @nodoc
class _$ExpenseModelCopyWithImpl<$Res>
    implements $ExpenseModelCopyWith<$Res> {
  _$ExpenseModelCopyWithImpl(this._self, this._then);

  final ExpenseModel _self;
  final $Res Function(ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? createdBy = null,Object? title = null,Object? amount = null,Object? currency = null,Object? splitType = null,Object? note = freezed,Object? createdAt = freezed,Object? participants = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ExpenseParticipantModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseModel].
extension ExpenseModelPatterns on ExpenseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'created_by')  String createdBy,  String title,  double amount,  String currency, @JsonKey(name: 'split_type')  String splitType,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<ExpenseParticipantModel> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.id,_that.roomId,_that.createdBy,_that.title,_that.amount,_that.currency,_that.splitType,_that.note,_that.createdAt,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'created_by')  String createdBy,  String title,  double amount,  String currency, @JsonKey(name: 'split_type')  String splitType,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<ExpenseParticipantModel> participants)  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel():
return $default(_that.id,_that.roomId,_that.createdBy,_that.title,_that.amount,_that.currency,_that.splitType,_that.note,_that.createdAt,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'created_by')  String createdBy,  String title,  double amount,  String currency, @JsonKey(name: 'split_type')  String splitType,  String? note, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<ExpenseParticipantModel> participants)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseModel() when $default != null:
return $default(_that.id,_that.roomId,_that.createdBy,_that.title,_that.amount,_that.currency,_that.splitType,_that.note,_that.createdAt,_that.participants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseModel implements ExpenseModel {
  const _ExpenseModel({required this.id, @JsonKey(name: 'room_id') required this.roomId, @JsonKey(name: 'created_by') required this.createdBy, required this.title, required this.amount, this.currency = 'INR', @JsonKey(name: 'split_type') this.splitType = 'equal', this.note, @JsonKey(name: 'created_at') this.createdAt, final  List<ExpenseParticipantModel> participants = const []}): _participants = participants;
  factory _ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'room_id') final  String roomId;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override final  String title;
@override final  double amount;
@override@JsonKey() final  String currency;
@override@JsonKey(name: 'split_type') final  String splitType;
@override final  String? note;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
 final  List<ExpenseParticipantModel> _participants;
@override@JsonKey() List<ExpenseParticipantModel> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseModelCopyWith<_ExpenseModel> get copyWith => __$ExpenseModelCopyWithImpl<_ExpenseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.splitType, splitType) || other.splitType == splitType)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._participants, _participants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,createdBy,title,amount,currency,splitType,note,createdAt,const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'ExpenseModel(id: $id, roomId: $roomId, createdBy: $createdBy, title: $title, amount: $amount, currency: $currency, splitType: $splitType, note: $note, createdAt: $createdAt, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$ExpenseModelCopyWith<$Res> implements $ExpenseModelCopyWith<$Res> {
  factory _$ExpenseModelCopyWith(_ExpenseModel value, $Res Function(_ExpenseModel) _then) = __$ExpenseModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'created_by') String createdBy, String title, double amount, String currency,@JsonKey(name: 'split_type') String splitType, String? note,@JsonKey(name: 'created_at') DateTime? createdAt, List<ExpenseParticipantModel> participants
});




}
/// @nodoc
class __$ExpenseModelCopyWithImpl<$Res>
    implements _$ExpenseModelCopyWith<$Res> {
  __$ExpenseModelCopyWithImpl(this._self, this._then);

  final _ExpenseModel _self;
  final $Res Function(_ExpenseModel) _then;

/// Create a copy of ExpenseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? createdBy = null,Object? title = null,Object? amount = null,Object? currency = null,Object? splitType = null,Object? note = freezed,Object? createdAt = freezed,Object? participants = null,}) {
  return _then(_ExpenseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,splitType: null == splitType ? _self.splitType : splitType // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ExpenseParticipantModel>,
  ));
}


}


/// @nodoc
mixin _$ExpenseParticipantModel {

 String get id;@JsonKey(name: 'expense_id') String get expenseId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'amount_owed') double get amountOwed;@JsonKey(name: 'is_paid') bool get isPaid;
/// Create a copy of ExpenseParticipantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseParticipantModelCopyWith<ExpenseParticipantModel> get copyWith => _$ExpenseParticipantModelCopyWithImpl<ExpenseParticipantModel>(this as ExpenseParticipantModel, _$identity);

  /// Serializes this ExpenseParticipantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountOwed, amountOwed) || other.amountOwed == amountOwed)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expenseId,userId,amountOwed,isPaid);

@override
String toString() {
  return 'ExpenseParticipantModel(id: $id, expenseId: $expenseId, userId: $userId, amountOwed: $amountOwed, isPaid: $isPaid)';
}


}

/// @nodoc
abstract mixin class $ExpenseParticipantModelCopyWith<$Res>  {
  factory $ExpenseParticipantModelCopyWith(ExpenseParticipantModel value, $Res Function(ExpenseParticipantModel) _then) = _$ExpenseParticipantModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'amount_owed') double amountOwed,@JsonKey(name: 'is_paid') bool isPaid
});




}
/// @nodoc
class _$ExpenseParticipantModelCopyWithImpl<$Res>
    implements $ExpenseParticipantModelCopyWith<$Res> {
  _$ExpenseParticipantModelCopyWithImpl(this._self, this._then);

  final ExpenseParticipantModel _self;
  final $Res Function(ExpenseParticipantModel) _then;

/// Create a copy of ExpenseParticipantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expenseId = null,Object? userId = null,Object? amountOwed = null,Object? isPaid = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountOwed: null == amountOwed ? _self.amountOwed : amountOwed // ignore: cast_nullable_to_non_nullable
as double,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseParticipantModel].
extension ExpenseParticipantModelPatterns on ExpenseParticipantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseParticipantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseParticipantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseParticipantModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseParticipantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseParticipantModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseParticipantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'amount_owed')  double amountOwed, @JsonKey(name: 'is_paid')  bool isPaid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseParticipantModel() when $default != null:
return $default(_that.id,_that.expenseId,_that.userId,_that.amountOwed,_that.isPaid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'amount_owed')  double amountOwed, @JsonKey(name: 'is_paid')  bool isPaid)  $default,) {final _that = this;
switch (_that) {
case _ExpenseParticipantModel():
return $default(_that.id,_that.expenseId,_that.userId,_that.amountOwed,_that.isPaid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'expense_id')  String expenseId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'amount_owed')  double amountOwed, @JsonKey(name: 'is_paid')  bool isPaid)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseParticipantModel() when $default != null:
return $default(_that.id,_that.expenseId,_that.userId,_that.amountOwed,_that.isPaid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseParticipantModel implements ExpenseParticipantModel {
  const _ExpenseParticipantModel({required this.id, @JsonKey(name: 'expense_id') required this.expenseId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'amount_owed') this.amountOwed = 0, @JsonKey(name: 'is_paid') this.isPaid = false});
  factory _ExpenseParticipantModel.fromJson(Map<String, dynamic> json) => _$ExpenseParticipantModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'expense_id') final  String expenseId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'amount_owed') final  double amountOwed;
@override@JsonKey(name: 'is_paid') final  bool isPaid;

/// Create a copy of ExpenseParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseParticipantModelCopyWith<_ExpenseParticipantModel> get copyWith => __$ExpenseParticipantModelCopyWithImpl<_ExpenseParticipantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseParticipantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountOwed, amountOwed) || other.amountOwed == amountOwed)&&(identical(other.isPaid, isPaid) || other.isPaid == isPaid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expenseId,userId,amountOwed,isPaid);

@override
String toString() {
  return 'ExpenseParticipantModel(id: $id, expenseId: $expenseId, userId: $userId, amountOwed: $amountOwed, isPaid: $isPaid)';
}


}

/// @nodoc
abstract mixin class _$ExpenseParticipantModelCopyWith<$Res> implements $ExpenseParticipantModelCopyWith<$Res> {
  factory _$ExpenseParticipantModelCopyWith(_ExpenseParticipantModel value, $Res Function(_ExpenseParticipantModel) _then) = __$ExpenseParticipantModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'expense_id') String expenseId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'amount_owed') double amountOwed,@JsonKey(name: 'is_paid') bool isPaid
});




}
/// @nodoc
class __$ExpenseParticipantModelCopyWithImpl<$Res>
    implements _$ExpenseParticipantModelCopyWith<$Res> {
  __$ExpenseParticipantModelCopyWithImpl(this._self, this._then);

  final _ExpenseParticipantModel _self;
  final $Res Function(_ExpenseParticipantModel) _then;

/// Create a copy of ExpenseParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expenseId = null,Object? userId = null,Object? amountOwed = null,Object? isPaid = null,}) {
  return _then(_ExpenseParticipantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expenseId: null == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountOwed: null == amountOwed ? _self.amountOwed : amountOwed // ignore: cast_nullable_to_non_nullable
as double,isPaid: null == isPaid ? _self.isPaid : isPaid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
