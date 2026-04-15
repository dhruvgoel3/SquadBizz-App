// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollModel {

 String get id;@JsonKey(name: 'room_id') String get roomId;@JsonKey(name: 'created_by') String get createdBy; String get question;@JsonKey(name: 'poll_type') String get pollType;@JsonKey(name: 'is_anonymous') bool get isAnonymous;@JsonKey(name: 'expires_at') DateTime? get expiresAt;@JsonKey(name: 'created_at') DateTime? get createdAt; List<PollOptionModel> get options;
/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollModelCopyWith<PollModel> get copyWith => _$PollModelCopyWithImpl<PollModel>(this as PollModel, _$identity);

  /// Serializes this PollModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.question, question) || other.question == question)&&(identical(other.pollType, pollType) || other.pollType == pollType)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,createdBy,question,pollType,isAnonymous,expiresAt,createdAt,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'PollModel(id: $id, roomId: $roomId, createdBy: $createdBy, question: $question, pollType: $pollType, isAnonymous: $isAnonymous, expiresAt: $expiresAt, createdAt: $createdAt, options: $options)';
}


}

/// @nodoc
abstract mixin class $PollModelCopyWith<$Res>  {
  factory $PollModelCopyWith(PollModel value, $Res Function(PollModel) _then) = _$PollModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'created_by') String createdBy, String question,@JsonKey(name: 'poll_type') String pollType,@JsonKey(name: 'is_anonymous') bool isAnonymous,@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'created_at') DateTime? createdAt, List<PollOptionModel> options
});




}
/// @nodoc
class _$PollModelCopyWithImpl<$Res>
    implements $PollModelCopyWith<$Res> {
  _$PollModelCopyWithImpl(this._self, this._then);

  final PollModel _self;
  final $Res Function(PollModel) _then;

/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? createdBy = null,Object? question = null,Object? pollType = null,Object? isAnonymous = null,Object? expiresAt = freezed,Object? createdAt = freezed,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<PollOptionModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PollModel].
extension PollModelPatterns on PollModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollModel value)  $default,){
final _that = this;
switch (_that) {
case _PollModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollModel value)?  $default,){
final _that = this;
switch (_that) {
case _PollModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'created_by')  String createdBy,  String question, @JsonKey(name: 'poll_type')  String pollType, @JsonKey(name: 'is_anonymous')  bool isAnonymous, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<PollOptionModel> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollModel() when $default != null:
return $default(_that.id,_that.roomId,_that.createdBy,_that.question,_that.pollType,_that.isAnonymous,_that.expiresAt,_that.createdAt,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'created_by')  String createdBy,  String question, @JsonKey(name: 'poll_type')  String pollType, @JsonKey(name: 'is_anonymous')  bool isAnonymous, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<PollOptionModel> options)  $default,) {final _that = this;
switch (_that) {
case _PollModel():
return $default(_that.id,_that.roomId,_that.createdBy,_that.question,_that.pollType,_that.isAnonymous,_that.expiresAt,_that.createdAt,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'created_by')  String createdBy,  String question, @JsonKey(name: 'poll_type')  String pollType, @JsonKey(name: 'is_anonymous')  bool isAnonymous, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'created_at')  DateTime? createdAt,  List<PollOptionModel> options)?  $default,) {final _that = this;
switch (_that) {
case _PollModel() when $default != null:
return $default(_that.id,_that.roomId,_that.createdBy,_that.question,_that.pollType,_that.isAnonymous,_that.expiresAt,_that.createdAt,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollModel implements PollModel {
  const _PollModel({required this.id, @JsonKey(name: 'room_id') required this.roomId, @JsonKey(name: 'created_by') required this.createdBy, required this.question, @JsonKey(name: 'poll_type') this.pollType = 'single', @JsonKey(name: 'is_anonymous') this.isAnonymous = false, @JsonKey(name: 'expires_at') this.expiresAt, @JsonKey(name: 'created_at') this.createdAt, final  List<PollOptionModel> options = const []}): _options = options;
  factory _PollModel.fromJson(Map<String, dynamic> json) => _$PollModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'room_id') final  String roomId;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override final  String question;
@override@JsonKey(name: 'poll_type') final  String pollType;
@override@JsonKey(name: 'is_anonymous') final  bool isAnonymous;
@override@JsonKey(name: 'expires_at') final  DateTime? expiresAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
 final  List<PollOptionModel> _options;
@override@JsonKey() List<PollOptionModel> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollModelCopyWith<_PollModel> get copyWith => __$PollModelCopyWithImpl<_PollModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.question, question) || other.question == question)&&(identical(other.pollType, pollType) || other.pollType == pollType)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,createdBy,question,pollType,isAnonymous,expiresAt,createdAt,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PollModel(id: $id, roomId: $roomId, createdBy: $createdBy, question: $question, pollType: $pollType, isAnonymous: $isAnonymous, expiresAt: $expiresAt, createdAt: $createdAt, options: $options)';
}


}

/// @nodoc
abstract mixin class _$PollModelCopyWith<$Res> implements $PollModelCopyWith<$Res> {
  factory _$PollModelCopyWith(_PollModel value, $Res Function(_PollModel) _then) = __$PollModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'created_by') String createdBy, String question,@JsonKey(name: 'poll_type') String pollType,@JsonKey(name: 'is_anonymous') bool isAnonymous,@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'created_at') DateTime? createdAt, List<PollOptionModel> options
});




}
/// @nodoc
class __$PollModelCopyWithImpl<$Res>
    implements _$PollModelCopyWith<$Res> {
  __$PollModelCopyWithImpl(this._self, this._then);

  final _PollModel _self;
  final $Res Function(_PollModel) _then;

/// Create a copy of PollModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? createdBy = null,Object? question = null,Object? pollType = null,Object? isAnonymous = null,Object? expiresAt = freezed,Object? createdAt = freezed,Object? options = null,}) {
  return _then(_PollModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PollOptionModel>,
  ));
}


}


/// @nodoc
mixin _$PollOptionModel {

 String get id;@JsonKey(name: 'poll_id') String get pollId; String get text;@JsonKey(name: 'sort_order') int get sortOrder; int get voteCount; List<String> get voterIds;
/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollOptionModelCopyWith<PollOptionModel> get copyWith => _$PollOptionModelCopyWithImpl<PollOptionModel>(this as PollOptionModel, _$identity);

  /// Serializes this PollOptionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollOptionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.text, text) || other.text == text)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&const DeepCollectionEquality().equals(other.voterIds, voterIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pollId,text,sortOrder,voteCount,const DeepCollectionEquality().hash(voterIds));

@override
String toString() {
  return 'PollOptionModel(id: $id, pollId: $pollId, text: $text, sortOrder: $sortOrder, voteCount: $voteCount, voterIds: $voterIds)';
}


}

/// @nodoc
abstract mixin class $PollOptionModelCopyWith<$Res>  {
  factory $PollOptionModelCopyWith(PollOptionModel value, $Res Function(PollOptionModel) _then) = _$PollOptionModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'poll_id') String pollId, String text,@JsonKey(name: 'sort_order') int sortOrder, int voteCount, List<String> voterIds
});




}
/// @nodoc
class _$PollOptionModelCopyWithImpl<$Res>
    implements $PollOptionModelCopyWith<$Res> {
  _$PollOptionModelCopyWithImpl(this._self, this._then);

  final PollOptionModel _self;
  final $Res Function(PollOptionModel) _then;

/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pollId = null,Object? text = null,Object? sortOrder = null,Object? voteCount = null,Object? voterIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,voterIds: null == voterIds ? _self.voterIds : voterIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PollOptionModel].
extension PollOptionModelPatterns on PollOptionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollOptionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollOptionModel value)  $default,){
final _that = this;
switch (_that) {
case _PollOptionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollOptionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'poll_id')  String pollId,  String text, @JsonKey(name: 'sort_order')  int sortOrder,  int voteCount,  List<String> voterIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
return $default(_that.id,_that.pollId,_that.text,_that.sortOrder,_that.voteCount,_that.voterIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'poll_id')  String pollId,  String text, @JsonKey(name: 'sort_order')  int sortOrder,  int voteCount,  List<String> voterIds)  $default,) {final _that = this;
switch (_that) {
case _PollOptionModel():
return $default(_that.id,_that.pollId,_that.text,_that.sortOrder,_that.voteCount,_that.voterIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'poll_id')  String pollId,  String text, @JsonKey(name: 'sort_order')  int sortOrder,  int voteCount,  List<String> voterIds)?  $default,) {final _that = this;
switch (_that) {
case _PollOptionModel() when $default != null:
return $default(_that.id,_that.pollId,_that.text,_that.sortOrder,_that.voteCount,_that.voterIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollOptionModel implements PollOptionModel {
  const _PollOptionModel({required this.id, @JsonKey(name: 'poll_id') required this.pollId, required this.text, @JsonKey(name: 'sort_order') this.sortOrder = 0, this.voteCount = 0, final  List<String> voterIds = const []}): _voterIds = voterIds;
  factory _PollOptionModel.fromJson(Map<String, dynamic> json) => _$PollOptionModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'poll_id') final  String pollId;
@override final  String text;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey() final  int voteCount;
 final  List<String> _voterIds;
@override@JsonKey() List<String> get voterIds {
  if (_voterIds is EqualUnmodifiableListView) return _voterIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voterIds);
}


/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollOptionModelCopyWith<_PollOptionModel> get copyWith => __$PollOptionModelCopyWithImpl<_PollOptionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollOptionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollOptionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.text, text) || other.text == text)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&const DeepCollectionEquality().equals(other._voterIds, _voterIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pollId,text,sortOrder,voteCount,const DeepCollectionEquality().hash(_voterIds));

@override
String toString() {
  return 'PollOptionModel(id: $id, pollId: $pollId, text: $text, sortOrder: $sortOrder, voteCount: $voteCount, voterIds: $voterIds)';
}


}

/// @nodoc
abstract mixin class _$PollOptionModelCopyWith<$Res> implements $PollOptionModelCopyWith<$Res> {
  factory _$PollOptionModelCopyWith(_PollOptionModel value, $Res Function(_PollOptionModel) _then) = __$PollOptionModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'poll_id') String pollId, String text,@JsonKey(name: 'sort_order') int sortOrder, int voteCount, List<String> voterIds
});




}
/// @nodoc
class __$PollOptionModelCopyWithImpl<$Res>
    implements _$PollOptionModelCopyWith<$Res> {
  __$PollOptionModelCopyWithImpl(this._self, this._then);

  final _PollOptionModel _self;
  final $Res Function(_PollOptionModel) _then;

/// Create a copy of PollOptionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pollId = null,Object? text = null,Object? sortOrder = null,Object? voteCount = null,Object? voterIds = null,}) {
  return _then(_PollOptionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,voterIds: null == voterIds ? _self._voterIds : voterIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
