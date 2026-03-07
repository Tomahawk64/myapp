// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pandit_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PanditProfile {

 String get id;// Corresponds to the AppUser ID
 String get bio; List<String> get specialities; int get experience;// Years of experience
 List<String> get languages; String get location; bool get isVerified; double? get rating; DateTime get createdAt;
/// Create a copy of PanditProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanditProfileCopyWith<PanditProfile> get copyWith => _$PanditProfileCopyWithImpl<PanditProfile>(this as PanditProfile, _$identity);

  /// Serializes this PanditProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanditProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.specialities, specialities)&&(identical(other.experience, experience) || other.experience == experience)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.location, location) || other.location == location)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bio,const DeepCollectionEquality().hash(specialities),experience,const DeepCollectionEquality().hash(languages),location,isVerified,rating,createdAt);

@override
String toString() {
  return 'PanditProfile(id: $id, bio: $bio, specialities: $specialities, experience: $experience, languages: $languages, location: $location, isVerified: $isVerified, rating: $rating, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PanditProfileCopyWith<$Res>  {
  factory $PanditProfileCopyWith(PanditProfile value, $Res Function(PanditProfile) _then) = _$PanditProfileCopyWithImpl;
@useResult
$Res call({
 String id, String bio, List<String> specialities, int experience, List<String> languages, String location, bool isVerified, double? rating, DateTime createdAt
});




}
/// @nodoc
class _$PanditProfileCopyWithImpl<$Res>
    implements $PanditProfileCopyWith<$Res> {
  _$PanditProfileCopyWithImpl(this._self, this._then);

  final PanditProfile _self;
  final $Res Function(PanditProfile) _then;

/// Create a copy of PanditProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bio = null,Object? specialities = null,Object? experience = null,Object? languages = null,Object? location = null,Object? isVerified = null,Object? rating = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,specialities: null == specialities ? _self.specialities : specialities // ignore: cast_nullable_to_non_nullable
as List<String>,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as int,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PanditProfile].
extension PanditProfilePatterns on PanditProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanditProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanditProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanditProfile value)  $default,){
final _that = this;
switch (_that) {
case _PanditProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanditProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PanditProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bio,  List<String> specialities,  int experience,  List<String> languages,  String location,  bool isVerified,  double? rating,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanditProfile() when $default != null:
return $default(_that.id,_that.bio,_that.specialities,_that.experience,_that.languages,_that.location,_that.isVerified,_that.rating,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bio,  List<String> specialities,  int experience,  List<String> languages,  String location,  bool isVerified,  double? rating,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PanditProfile():
return $default(_that.id,_that.bio,_that.specialities,_that.experience,_that.languages,_that.location,_that.isVerified,_that.rating,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bio,  List<String> specialities,  int experience,  List<String> languages,  String location,  bool isVerified,  double? rating,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PanditProfile() when $default != null:
return $default(_that.id,_that.bio,_that.specialities,_that.experience,_that.languages,_that.location,_that.isVerified,_that.rating,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanditProfile implements PanditProfile {
  const _PanditProfile({required this.id, required this.bio, required final  List<String> specialities, required this.experience, required final  List<String> languages, required this.location, required this.isVerified, this.rating, required this.createdAt}): _specialities = specialities,_languages = languages;
  factory _PanditProfile.fromJson(Map<String, dynamic> json) => _$PanditProfileFromJson(json);

@override final  String id;
// Corresponds to the AppUser ID
@override final  String bio;
 final  List<String> _specialities;
@override List<String> get specialities {
  if (_specialities is EqualUnmodifiableListView) return _specialities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialities);
}

@override final  int experience;
// Years of experience
 final  List<String> _languages;
// Years of experience
@override List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  String location;
@override final  bool isVerified;
@override final  double? rating;
@override final  DateTime createdAt;

/// Create a copy of PanditProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanditProfileCopyWith<_PanditProfile> get copyWith => __$PanditProfileCopyWithImpl<_PanditProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanditProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanditProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._specialities, _specialities)&&(identical(other.experience, experience) || other.experience == experience)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.location, location) || other.location == location)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bio,const DeepCollectionEquality().hash(_specialities),experience,const DeepCollectionEquality().hash(_languages),location,isVerified,rating,createdAt);

@override
String toString() {
  return 'PanditProfile(id: $id, bio: $bio, specialities: $specialities, experience: $experience, languages: $languages, location: $location, isVerified: $isVerified, rating: $rating, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PanditProfileCopyWith<$Res> implements $PanditProfileCopyWith<$Res> {
  factory _$PanditProfileCopyWith(_PanditProfile value, $Res Function(_PanditProfile) _then) = __$PanditProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String bio, List<String> specialities, int experience, List<String> languages, String location, bool isVerified, double? rating, DateTime createdAt
});




}
/// @nodoc
class __$PanditProfileCopyWithImpl<$Res>
    implements _$PanditProfileCopyWith<$Res> {
  __$PanditProfileCopyWithImpl(this._self, this._then);

  final _PanditProfile _self;
  final $Res Function(_PanditProfile) _then;

/// Create a copy of PanditProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bio = null,Object? specialities = null,Object? experience = null,Object? languages = null,Object? location = null,Object? isVerified = null,Object? rating = freezed,Object? createdAt = null,}) {
  return _then(_PanditProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,specialities: null == specialities ? _self._specialities : specialities // ignore: cast_nullable_to_non_nullable
as List<String>,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as int,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
