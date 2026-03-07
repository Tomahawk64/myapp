// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_pooja.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpecialPooja {

 String get id; String get name; String get description; DateTime get date; String get location; double get price; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SpecialPooja
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialPoojaCopyWith<SpecialPooja> get copyWith => _$SpecialPoojaCopyWithImpl<SpecialPooja>(this as SpecialPooja, _$identity);

  /// Serializes this SpecialPooja to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialPooja&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location)&&(identical(other.price, price) || other.price == price)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,date,location,price,createdAt,updatedAt);

@override
String toString() {
  return 'SpecialPooja(id: $id, name: $name, description: $description, date: $date, location: $location, price: $price, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SpecialPoojaCopyWith<$Res>  {
  factory $SpecialPoojaCopyWith(SpecialPooja value, $Res Function(SpecialPooja) _then) = _$SpecialPoojaCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, DateTime date, String location, double price, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$SpecialPoojaCopyWithImpl<$Res>
    implements $SpecialPoojaCopyWith<$Res> {
  _$SpecialPoojaCopyWithImpl(this._self, this._then);

  final SpecialPooja _self;
  final $Res Function(SpecialPooja) _then;

/// Create a copy of SpecialPooja
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? date = null,Object? location = null,Object? price = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SpecialPooja].
extension SpecialPoojaPatterns on SpecialPooja {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpecialPooja value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpecialPooja() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpecialPooja value)  $default,){
final _that = this;
switch (_that) {
case _SpecialPooja():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpecialPooja value)?  $default,){
final _that = this;
switch (_that) {
case _SpecialPooja() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  DateTime date,  String location,  double price,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpecialPooja() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.date,_that.location,_that.price,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  DateTime date,  String location,  double price,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SpecialPooja():
return $default(_that.id,_that.name,_that.description,_that.date,_that.location,_that.price,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  DateTime date,  String location,  double price,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpecialPooja() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.date,_that.location,_that.price,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpecialPooja implements SpecialPooja {
  const _SpecialPooja({required this.id, required this.name, required this.description, required this.date, required this.location, required this.price, required this.createdAt, required this.updatedAt});
  factory _SpecialPooja.fromJson(Map<String, dynamic> json) => _$SpecialPoojaFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  DateTime date;
@override final  String location;
@override final  double price;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SpecialPooja
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpecialPoojaCopyWith<_SpecialPooja> get copyWith => __$SpecialPoojaCopyWithImpl<_SpecialPooja>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpecialPoojaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpecialPooja&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location)&&(identical(other.price, price) || other.price == price)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,date,location,price,createdAt,updatedAt);

@override
String toString() {
  return 'SpecialPooja(id: $id, name: $name, description: $description, date: $date, location: $location, price: $price, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SpecialPoojaCopyWith<$Res> implements $SpecialPoojaCopyWith<$Res> {
  factory _$SpecialPoojaCopyWith(_SpecialPooja value, $Res Function(_SpecialPooja) _then) = __$SpecialPoojaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, DateTime date, String location, double price, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$SpecialPoojaCopyWithImpl<$Res>
    implements _$SpecialPoojaCopyWith<$Res> {
  __$SpecialPoojaCopyWithImpl(this._self, this._then);

  final _SpecialPooja _self;
  final $Res Function(_SpecialPooja) _then;

/// Create a copy of SpecialPooja
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? date = null,Object? location = null,Object? price = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SpecialPooja(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
