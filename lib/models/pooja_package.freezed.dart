// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pooja_package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoojaPackage {

 String get id; String get name; String get description; double get price; int get durationInMinutes; List<String> get languages; String get imageUrl; bool get isFeatured; DateTime get createdAt;
/// Create a copy of PoojaPackage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoojaPackageCopyWith<PoojaPackage> get copyWith => _$PoojaPackageCopyWithImpl<PoojaPackage>(this as PoojaPackage, _$identity);

  /// Serializes this PoojaPackage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoojaPackage&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,durationInMinutes,const DeepCollectionEquality().hash(languages),imageUrl,isFeatured,createdAt);

@override
String toString() {
  return 'PoojaPackage(id: $id, name: $name, description: $description, price: $price, durationInMinutes: $durationInMinutes, languages: $languages, imageUrl: $imageUrl, isFeatured: $isFeatured, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PoojaPackageCopyWith<$Res>  {
  factory $PoojaPackageCopyWith(PoojaPackage value, $Res Function(PoojaPackage) _then) = _$PoojaPackageCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, double price, int durationInMinutes, List<String> languages, String imageUrl, bool isFeatured, DateTime createdAt
});




}
/// @nodoc
class _$PoojaPackageCopyWithImpl<$Res>
    implements $PoojaPackageCopyWith<$Res> {
  _$PoojaPackageCopyWithImpl(this._self, this._then);

  final PoojaPackage _self;
  final $Res Function(PoojaPackage) _then;

/// Create a copy of PoojaPackage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? durationInMinutes = null,Object? languages = null,Object? imageUrl = null,Object? isFeatured = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PoojaPackage].
extension PoojaPackagePatterns on PoojaPackage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoojaPackage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoojaPackage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoojaPackage value)  $default,){
final _that = this;
switch (_that) {
case _PoojaPackage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoojaPackage value)?  $default,){
final _that = this;
switch (_that) {
case _PoojaPackage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  double price,  int durationInMinutes,  List<String> languages,  String imageUrl,  bool isFeatured,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoojaPackage() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.durationInMinutes,_that.languages,_that.imageUrl,_that.isFeatured,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  double price,  int durationInMinutes,  List<String> languages,  String imageUrl,  bool isFeatured,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PoojaPackage():
return $default(_that.id,_that.name,_that.description,_that.price,_that.durationInMinutes,_that.languages,_that.imageUrl,_that.isFeatured,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  double price,  int durationInMinutes,  List<String> languages,  String imageUrl,  bool isFeatured,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PoojaPackage() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.durationInMinutes,_that.languages,_that.imageUrl,_that.isFeatured,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoojaPackage implements PoojaPackage {
  const _PoojaPackage({required this.id, required this.name, required this.description, required this.price, required this.durationInMinutes, required final  List<String> languages, required this.imageUrl, required this.isFeatured, required this.createdAt}): _languages = languages;
  factory _PoojaPackage.fromJson(Map<String, dynamic> json) => _$PoojaPackageFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  double price;
@override final  int durationInMinutes;
 final  List<String> _languages;
@override List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  String imageUrl;
@override final  bool isFeatured;
@override final  DateTime createdAt;

/// Create a copy of PoojaPackage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoojaPackageCopyWith<_PoojaPackage> get copyWith => __$PoojaPackageCopyWithImpl<_PoojaPackage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoojaPackageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoojaPackage&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,durationInMinutes,const DeepCollectionEquality().hash(_languages),imageUrl,isFeatured,createdAt);

@override
String toString() {
  return 'PoojaPackage(id: $id, name: $name, description: $description, price: $price, durationInMinutes: $durationInMinutes, languages: $languages, imageUrl: $imageUrl, isFeatured: $isFeatured, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PoojaPackageCopyWith<$Res> implements $PoojaPackageCopyWith<$Res> {
  factory _$PoojaPackageCopyWith(_PoojaPackage value, $Res Function(_PoojaPackage) _then) = __$PoojaPackageCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, double price, int durationInMinutes, List<String> languages, String imageUrl, bool isFeatured, DateTime createdAt
});




}
/// @nodoc
class __$PoojaPackageCopyWithImpl<$Res>
    implements _$PoojaPackageCopyWith<$Res> {
  __$PoojaPackageCopyWithImpl(this._self, this._then);

  final _PoojaPackage _self;
  final $Res Function(_PoojaPackage) _then;

/// Create a copy of PoojaPackage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? durationInMinutes = null,Object? languages = null,Object? imageUrl = null,Object? isFeatured = null,Object? createdAt = null,}) {
  return _then(_PoojaPackage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
