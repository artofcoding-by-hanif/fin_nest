// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportData {

 ExportMetadata get metadata; ExportSettings get settings; ExportDatabaseData get database;
/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDataCopyWith<ExportData> get copyWith => _$ExportDataCopyWithImpl<ExportData>(this as ExportData, _$identity);

  /// Serializes this ExportData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExportData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportData&&(identical(other.metadata, _this.metadata) || other.metadata == _this.metadata)&&(identical(other.settings, _this.settings) || other.settings == _this.settings)&&(identical(other.database, _this.database) || other.database == _this.database));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExportData;
  return Object.hash(runtimeType,_this.metadata,_this.settings,_this.database);
}

@override
String toString() {
  final _this = this as ExportData;
  return 'ExportData(metadata: ${_this.metadata}, settings: ${_this.settings}, database: ${_this.database})';
}


}

/// @nodoc
abstract mixin class $ExportDataCopyWith<$Res>  {
  factory $ExportDataCopyWith(ExportData value, $Res Function(ExportData) _then) = _$ExportDataCopyWithImpl;
@useResult
$Res call({
 ExportMetadata metadata, ExportSettings settings, ExportDatabaseData database
});


$ExportMetadataCopyWith<$Res> get metadata;$ExportSettingsCopyWith<$Res> get settings;$ExportDatabaseDataCopyWith<$Res> get database;

}
/// @nodoc
class _$ExportDataCopyWithImpl<$Res>
    implements $ExportDataCopyWith<$Res> {
  _$ExportDataCopyWithImpl(this._self, this._then);

  final ExportData _self;
  final $Res Function(ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = null,Object? settings = null,Object? database = null,}) {
  return _then(ExportData(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ExportMetadata,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ExportSettings,database: null == database ? _self.database : database // ignore: cast_nullable_to_non_nullable
as ExportDatabaseData,
  ));
}
/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportMetadataCopyWith<$Res> get metadata {
  
  return $ExportMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportSettingsCopyWith<$Res> get settings {
  
  return $ExportSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportDatabaseDataCopyWith<$Res> get database {
  
  return $ExportDatabaseDataCopyWith<$Res>(_self.database, (value) {
    return _then(_self.copyWith(database: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExportData].
extension ExportDataPatterns on ExportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportData value)  $default,){
final _that = this;
switch (_that) {
case _ExportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportData value)?  $default,){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExportMetadata metadata,  ExportSettings settings,  ExportDatabaseData database)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.metadata,_that.settings,_that.database);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExportMetadata metadata,  ExportSettings settings,  ExportDatabaseData database)  $default,) {final _that = this;
switch (_that) {
case _ExportData():
return $default(_that.metadata,_that.settings,_that.database);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExportMetadata metadata,  ExportSettings settings,  ExportDatabaseData database)?  $default,) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.metadata,_that.settings,_that.database);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportData implements ExportData {
  const _ExportData({required this.metadata, required this.settings, required this.database});
  factory _ExportData.fromJson(Map<String, dynamic> json) => _$ExportDataFromJson(json);

@override final  ExportMetadata metadata;
@override final  ExportSettings settings;
@override final  ExportDatabaseData database;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDataCopyWith<_ExportData> get copyWith => __$ExportDataCopyWithImpl<_ExportData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportData&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.database, database) || other.database == database));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,metadata,settings,database);
}

@override
String toString() {
    return 'ExportData(metadata: $metadata, settings: $settings, database: $database)';
}


}

/// @nodoc
abstract mixin class _$ExportDataCopyWith<$Res> implements $ExportDataCopyWith<$Res> {
  factory _$ExportDataCopyWith(_ExportData value, $Res Function(_ExportData) _then) = __$ExportDataCopyWithImpl;
@override @useResult
$Res call({
 ExportMetadata metadata, ExportSettings settings, ExportDatabaseData database
});


@override $ExportMetadataCopyWith<$Res> get metadata;@override $ExportSettingsCopyWith<$Res> get settings;@override $ExportDatabaseDataCopyWith<$Res> get database;

}
/// @nodoc
class __$ExportDataCopyWithImpl<$Res>
    implements _$ExportDataCopyWith<$Res> {
  __$ExportDataCopyWithImpl(this._self, this._then);

  final _ExportData _self;
  final $Res Function(_ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = null,Object? settings = null,Object? database = null,}) {
  return _then(_ExportData(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ExportMetadata,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as ExportSettings,database: null == database ? _self.database : database // ignore: cast_nullable_to_non_nullable
as ExportDatabaseData,
  ));
}

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportMetadataCopyWith<$Res> get metadata {
  
  return $ExportMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportSettingsCopyWith<$Res> get settings {
  
  return $ExportSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExportDatabaseDataCopyWith<$Res> get database {
  
  return $ExportDatabaseDataCopyWith<$Res>(_self.database, (value) {
    return _then(_self.copyWith(database: value));
  });
}
}


/// @nodoc
mixin _$ExportMetadata {

 String get version; String get appVersion; DateTime get exportDate; String get deviceInfo;
/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportMetadataCopyWith<ExportMetadata> get copyWith => _$ExportMetadataCopyWithImpl<ExportMetadata>(this as ExportMetadata, _$identity);

  /// Serializes this ExportMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExportMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportMetadata&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.exportDate, _this.exportDate) || other.exportDate == _this.exportDate)&&(identical(other.deviceInfo, _this.deviceInfo) || other.deviceInfo == _this.deviceInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExportMetadata;
  return Object.hash(runtimeType,_this.version,_this.appVersion,_this.exportDate,_this.deviceInfo);
}

@override
String toString() {
  final _this = this as ExportMetadata;
  return 'ExportMetadata(version: ${_this.version}, appVersion: ${_this.appVersion}, exportDate: ${_this.exportDate}, deviceInfo: ${_this.deviceInfo})';
}


}

/// @nodoc
abstract mixin class $ExportMetadataCopyWith<$Res>  {
  factory $ExportMetadataCopyWith(ExportMetadata value, $Res Function(ExportMetadata) _then) = _$ExportMetadataCopyWithImpl;
@useResult
$Res call({
 String version, String appVersion, DateTime exportDate, String deviceInfo
});




}
/// @nodoc
class _$ExportMetadataCopyWithImpl<$Res>
    implements $ExportMetadataCopyWith<$Res> {
  _$ExportMetadataCopyWithImpl(this._self, this._then);

  final ExportMetadata _self;
  final $Res Function(ExportMetadata) _then;

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? appVersion = null,Object? exportDate = null,Object? deviceInfo = null,}) {
  return _then(ExportMetadata(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,exportDate: null == exportDate ? _self.exportDate : exportDate // ignore: cast_nullable_to_non_nullable
as DateTime,deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportMetadata].
extension ExportMetadataPatterns on ExportMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ExportMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String appVersion,  DateTime exportDate,  String deviceInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
return $default(_that.version,_that.appVersion,_that.exportDate,_that.deviceInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String appVersion,  DateTime exportDate,  String deviceInfo)  $default,) {final _that = this;
switch (_that) {
case _ExportMetadata():
return $default(_that.version,_that.appVersion,_that.exportDate,_that.deviceInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String appVersion,  DateTime exportDate,  String deviceInfo)?  $default,) {final _that = this;
switch (_that) {
case _ExportMetadata() when $default != null:
return $default(_that.version,_that.appVersion,_that.exportDate,_that.deviceInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportMetadata implements ExportMetadata {
  const _ExportMetadata({required this.version, required this.appVersion, required this.exportDate, required this.deviceInfo});
  factory _ExportMetadata.fromJson(Map<String, dynamic> json) => _$ExportMetadataFromJson(json);

@override final  String version;
@override final  String appVersion;
@override final  DateTime exportDate;
@override final  String deviceInfo;

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportMetadataCopyWith<_ExportMetadata> get copyWith => __$ExportMetadataCopyWithImpl<_ExportMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportMetadata&&(identical(other.version, version) || other.version == version)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.exportDate, exportDate) || other.exportDate == exportDate)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,appVersion,exportDate,deviceInfo);
}

@override
String toString() {
    return 'ExportMetadata(version: $version, appVersion: $appVersion, exportDate: $exportDate, deviceInfo: $deviceInfo)';
}


}

/// @nodoc
abstract mixin class _$ExportMetadataCopyWith<$Res> implements $ExportMetadataCopyWith<$Res> {
  factory _$ExportMetadataCopyWith(_ExportMetadata value, $Res Function(_ExportMetadata) _then) = __$ExportMetadataCopyWithImpl;
@override @useResult
$Res call({
 String version, String appVersion, DateTime exportDate, String deviceInfo
});




}
/// @nodoc
class __$ExportMetadataCopyWithImpl<$Res>
    implements _$ExportMetadataCopyWith<$Res> {
  __$ExportMetadataCopyWithImpl(this._self, this._then);

  final _ExportMetadata _self;
  final $Res Function(_ExportMetadata) _then;

/// Create a copy of ExportMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? appVersion = null,Object? exportDate = null,Object? deviceInfo = null,}) {
  return _then(_ExportMetadata(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,exportDate: null == exportDate ? _self.exportDate : exportDate // ignore: cast_nullable_to_non_nullable
as DateTime,deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExportSettings {

 String get themeMode; String get currencyFormat; String get dateFormat; String get numberFormat; String get defaultCurrency; bool get biometricEnabled; bool get notificationsEnabled;
/// Create a copy of ExportSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportSettingsCopyWith<ExportSettings> get copyWith => _$ExportSettingsCopyWithImpl<ExportSettings>(this as ExportSettings, _$identity);

  /// Serializes this ExportSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExportSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportSettings&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.currencyFormat, _this.currencyFormat) || other.currencyFormat == _this.currencyFormat)&&(identical(other.dateFormat, _this.dateFormat) || other.dateFormat == _this.dateFormat)&&(identical(other.numberFormat, _this.numberFormat) || other.numberFormat == _this.numberFormat)&&(identical(other.defaultCurrency, _this.defaultCurrency) || other.defaultCurrency == _this.defaultCurrency)&&(identical(other.biometricEnabled, _this.biometricEnabled) || other.biometricEnabled == _this.biometricEnabled)&&(identical(other.notificationsEnabled, _this.notificationsEnabled) || other.notificationsEnabled == _this.notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExportSettings;
  return Object.hash(runtimeType,_this.themeMode,_this.currencyFormat,_this.dateFormat,_this.numberFormat,_this.defaultCurrency,_this.biometricEnabled,_this.notificationsEnabled);
}

@override
String toString() {
  final _this = this as ExportSettings;
  return 'ExportSettings(themeMode: ${_this.themeMode}, currencyFormat: ${_this.currencyFormat}, dateFormat: ${_this.dateFormat}, numberFormat: ${_this.numberFormat}, defaultCurrency: ${_this.defaultCurrency}, biometricEnabled: ${_this.biometricEnabled}, notificationsEnabled: ${_this.notificationsEnabled})';
}


}

/// @nodoc
abstract mixin class $ExportSettingsCopyWith<$Res>  {
  factory $ExportSettingsCopyWith(ExportSettings value, $Res Function(ExportSettings) _then) = _$ExportSettingsCopyWithImpl;
@useResult
$Res call({
 String themeMode, String currencyFormat, String dateFormat, String numberFormat, String defaultCurrency, bool biometricEnabled, bool notificationsEnabled
});




}
/// @nodoc
class _$ExportSettingsCopyWithImpl<$Res>
    implements $ExportSettingsCopyWith<$Res> {
  _$ExportSettingsCopyWithImpl(this._self, this._then);

  final ExportSettings _self;
  final $Res Function(ExportSettings) _then;

/// Create a copy of ExportSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? currencyFormat = null,Object? dateFormat = null,Object? numberFormat = null,Object? defaultCurrency = null,Object? biometricEnabled = null,Object? notificationsEnabled = null,}) {
  return _then(ExportSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,currencyFormat: null == currencyFormat ? _self.currencyFormat : currencyFormat // ignore: cast_nullable_to_non_nullable
as String,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,numberFormat: null == numberFormat ? _self.numberFormat : numberFormat // ignore: cast_nullable_to_non_nullable
as String,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportSettings].
extension ExportSettingsPatterns on ExportSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportSettings value)  $default,){
final _that = this;
switch (_that) {
case _ExportSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ExportSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String themeMode,  String currencyFormat,  String dateFormat,  String numberFormat,  String defaultCurrency,  bool biometricEnabled,  bool notificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportSettings() when $default != null:
return $default(_that.themeMode,_that.currencyFormat,_that.dateFormat,_that.numberFormat,_that.defaultCurrency,_that.biometricEnabled,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String themeMode,  String currencyFormat,  String dateFormat,  String numberFormat,  String defaultCurrency,  bool biometricEnabled,  bool notificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _ExportSettings():
return $default(_that.themeMode,_that.currencyFormat,_that.dateFormat,_that.numberFormat,_that.defaultCurrency,_that.biometricEnabled,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String themeMode,  String currencyFormat,  String dateFormat,  String numberFormat,  String defaultCurrency,  bool biometricEnabled,  bool notificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ExportSettings() when $default != null:
return $default(_that.themeMode,_that.currencyFormat,_that.dateFormat,_that.numberFormat,_that.defaultCurrency,_that.biometricEnabled,_that.notificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportSettings extends ExportSettings {
  const _ExportSettings({required this.themeMode, required this.currencyFormat, required this.dateFormat, required this.numberFormat, required this.defaultCurrency, required this.biometricEnabled, required this.notificationsEnabled}): super._();
  factory _ExportSettings.fromJson(Map<String, dynamic> json) => _$ExportSettingsFromJson(json);

@override final  String themeMode;
@override final  String currencyFormat;
@override final  String dateFormat;
@override final  String numberFormat;
@override final  String defaultCurrency;
@override final  bool biometricEnabled;
@override final  bool notificationsEnabled;

/// Create a copy of ExportSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportSettingsCopyWith<_ExportSettings> get copyWith => __$ExportSettingsCopyWithImpl<_ExportSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.currencyFormat, currencyFormat) || other.currencyFormat == currencyFormat)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.numberFormat, numberFormat) || other.numberFormat == numberFormat)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,themeMode,currencyFormat,dateFormat,numberFormat,defaultCurrency,biometricEnabled,notificationsEnabled);
}

@override
String toString() {
    return 'ExportSettings(themeMode: $themeMode, currencyFormat: $currencyFormat, dateFormat: $dateFormat, numberFormat: $numberFormat, defaultCurrency: $defaultCurrency, biometricEnabled: $biometricEnabled, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$ExportSettingsCopyWith<$Res> implements $ExportSettingsCopyWith<$Res> {
  factory _$ExportSettingsCopyWith(_ExportSettings value, $Res Function(_ExportSettings) _then) = __$ExportSettingsCopyWithImpl;
@override @useResult
$Res call({
 String themeMode, String currencyFormat, String dateFormat, String numberFormat, String defaultCurrency, bool biometricEnabled, bool notificationsEnabled
});




}
/// @nodoc
class __$ExportSettingsCopyWithImpl<$Res>
    implements _$ExportSettingsCopyWith<$Res> {
  __$ExportSettingsCopyWithImpl(this._self, this._then);

  final _ExportSettings _self;
  final $Res Function(_ExportSettings) _then;

/// Create a copy of ExportSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? currencyFormat = null,Object? dateFormat = null,Object? numberFormat = null,Object? defaultCurrency = null,Object? biometricEnabled = null,Object? notificationsEnabled = null,}) {
  return _then(_ExportSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,currencyFormat: null == currencyFormat ? _self.currencyFormat : currencyFormat // ignore: cast_nullable_to_non_nullable
as String,dateFormat: null == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String,numberFormat: null == numberFormat ? _self.numberFormat : numberFormat // ignore: cast_nullable_to_non_nullable
as String,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ExportDatabaseData {

 List<Map<String, dynamic>> get users; List<Map<String, dynamic>> get accounts; List<Map<String, dynamic>> get categories; List<Map<String, dynamic>> get transactions; List<Map<String, dynamic>> get recurringTransactions; List<Map<String, dynamic>> get budgets; List<Map<String, dynamic>> get budgetCategories; List<Map<String, dynamic>> get goals; List<Map<String, dynamic>> get savings; List<Map<String, dynamic>> get savingsTransactions;
/// Create a copy of ExportDatabaseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDatabaseDataCopyWith<ExportDatabaseData> get copyWith => _$ExportDatabaseDataCopyWithImpl<ExportDatabaseData>(this as ExportDatabaseData, _$identity);

  /// Serializes this ExportDatabaseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExportDatabaseData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportDatabaseData&&const DeepCollectionEquality().equals(other.users, _this.users)&&const DeepCollectionEquality().equals(other.accounts, _this.accounts)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&const DeepCollectionEquality().equals(other.recurringTransactions, _this.recurringTransactions)&&const DeepCollectionEquality().equals(other.budgets, _this.budgets)&&const DeepCollectionEquality().equals(other.budgetCategories, _this.budgetCategories)&&const DeepCollectionEquality().equals(other.goals, _this.goals)&&const DeepCollectionEquality().equals(other.savings, _this.savings)&&const DeepCollectionEquality().equals(other.savingsTransactions, _this.savingsTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExportDatabaseData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.users),const DeepCollectionEquality().hash(_this.accounts),const DeepCollectionEquality().hash(_this.categories),const DeepCollectionEquality().hash(_this.transactions),const DeepCollectionEquality().hash(_this.recurringTransactions),const DeepCollectionEquality().hash(_this.budgets),const DeepCollectionEquality().hash(_this.budgetCategories),const DeepCollectionEquality().hash(_this.goals),const DeepCollectionEquality().hash(_this.savings),const DeepCollectionEquality().hash(_this.savingsTransactions));
}

@override
String toString() {
  final _this = this as ExportDatabaseData;
  return 'ExportDatabaseData(users: ${_this.users}, accounts: ${_this.accounts}, categories: ${_this.categories}, transactions: ${_this.transactions}, recurringTransactions: ${_this.recurringTransactions}, budgets: ${_this.budgets}, budgetCategories: ${_this.budgetCategories}, goals: ${_this.goals}, savings: ${_this.savings}, savingsTransactions: ${_this.savingsTransactions})';
}


}

/// @nodoc
abstract mixin class $ExportDatabaseDataCopyWith<$Res>  {
  factory $ExportDatabaseDataCopyWith(ExportDatabaseData value, $Res Function(ExportDatabaseData) _then) = _$ExportDatabaseDataCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> users, List<Map<String, dynamic>> accounts, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> transactions, List<Map<String, dynamic>> recurringTransactions, List<Map<String, dynamic>> budgets, List<Map<String, dynamic>> budgetCategories, List<Map<String, dynamic>> goals, List<Map<String, dynamic>> savings, List<Map<String, dynamic>> savingsTransactions
});




}
/// @nodoc
class _$ExportDatabaseDataCopyWithImpl<$Res>
    implements $ExportDatabaseDataCopyWith<$Res> {
  _$ExportDatabaseDataCopyWithImpl(this._self, this._then);

  final ExportDatabaseData _self;
  final $Res Function(ExportDatabaseData) _then;

/// Create a copy of ExportDatabaseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? accounts = null,Object? categories = null,Object? transactions = null,Object? recurringTransactions = null,Object? budgets = null,Object? budgetCategories = null,Object? goals = null,Object? savings = null,Object? savingsTransactions = null,}) {
  return _then(ExportDatabaseData(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,recurringTransactions: null == recurringTransactions ? _self.recurringTransactions : recurringTransactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,budgetCategories: null == budgetCategories ? _self.budgetCategories : budgetCategories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,savings: null == savings ? _self.savings : savings // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,savingsTransactions: null == savingsTransactions ? _self.savingsTransactions : savingsTransactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportDatabaseData].
extension ExportDatabaseDataPatterns on ExportDatabaseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportDatabaseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportDatabaseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportDatabaseData value)  $default,){
final _that = this;
switch (_that) {
case _ExportDatabaseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportDatabaseData value)?  $default,){
final _that = this;
switch (_that) {
case _ExportDatabaseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> users,  List<Map<String, dynamic>> accounts,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> transactions,  List<Map<String, dynamic>> recurringTransactions,  List<Map<String, dynamic>> budgets,  List<Map<String, dynamic>> budgetCategories,  List<Map<String, dynamic>> goals,  List<Map<String, dynamic>> savings,  List<Map<String, dynamic>> savingsTransactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportDatabaseData() when $default != null:
return $default(_that.users,_that.accounts,_that.categories,_that.transactions,_that.recurringTransactions,_that.budgets,_that.budgetCategories,_that.goals,_that.savings,_that.savingsTransactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Map<String, dynamic>> users,  List<Map<String, dynamic>> accounts,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> transactions,  List<Map<String, dynamic>> recurringTransactions,  List<Map<String, dynamic>> budgets,  List<Map<String, dynamic>> budgetCategories,  List<Map<String, dynamic>> goals,  List<Map<String, dynamic>> savings,  List<Map<String, dynamic>> savingsTransactions)  $default,) {final _that = this;
switch (_that) {
case _ExportDatabaseData():
return $default(_that.users,_that.accounts,_that.categories,_that.transactions,_that.recurringTransactions,_that.budgets,_that.budgetCategories,_that.goals,_that.savings,_that.savingsTransactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Map<String, dynamic>> users,  List<Map<String, dynamic>> accounts,  List<Map<String, dynamic>> categories,  List<Map<String, dynamic>> transactions,  List<Map<String, dynamic>> recurringTransactions,  List<Map<String, dynamic>> budgets,  List<Map<String, dynamic>> budgetCategories,  List<Map<String, dynamic>> goals,  List<Map<String, dynamic>> savings,  List<Map<String, dynamic>> savingsTransactions)?  $default,) {final _that = this;
switch (_that) {
case _ExportDatabaseData() when $default != null:
return $default(_that.users,_that.accounts,_that.categories,_that.transactions,_that.recurringTransactions,_that.budgets,_that.budgetCategories,_that.goals,_that.savings,_that.savingsTransactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportDatabaseData implements ExportDatabaseData {
  const _ExportDatabaseData({required  List<Map<String, dynamic>> users, required  List<Map<String, dynamic>> accounts, required  List<Map<String, dynamic>> categories, required  List<Map<String, dynamic>> transactions, required  List<Map<String, dynamic>> recurringTransactions, required  List<Map<String, dynamic>> budgets, required  List<Map<String, dynamic>> budgetCategories, required  List<Map<String, dynamic>> goals, required  List<Map<String, dynamic>> savings, required  List<Map<String, dynamic>> savingsTransactions}): _users = users,_accounts = accounts,_categories = categories,_transactions = transactions,_recurringTransactions = recurringTransactions,_budgets = budgets,_budgetCategories = budgetCategories,_goals = goals,_savings = savings,_savingsTransactions = savingsTransactions;
  factory _ExportDatabaseData.fromJson(Map<String, dynamic> json) => _$ExportDatabaseDataFromJson(json);

 final  List<Map<String, dynamic>> _users;
@override List<Map<String, dynamic>> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

 final  List<Map<String, dynamic>> _accounts;
@override List<Map<String, dynamic>> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

 final  List<Map<String, dynamic>> _categories;
@override List<Map<String, dynamic>> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<Map<String, dynamic>> _transactions;
@override List<Map<String, dynamic>> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<Map<String, dynamic>> _recurringTransactions;
@override List<Map<String, dynamic>> get recurringTransactions {
  if (_recurringTransactions is EqualUnmodifiableListView) return _recurringTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recurringTransactions);
}

 final  List<Map<String, dynamic>> _budgets;
@override List<Map<String, dynamic>> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}

 final  List<Map<String, dynamic>> _budgetCategories;
@override List<Map<String, dynamic>> get budgetCategories {
  if (_budgetCategories is EqualUnmodifiableListView) return _budgetCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgetCategories);
}

 final  List<Map<String, dynamic>> _goals;
@override List<Map<String, dynamic>> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}

 final  List<Map<String, dynamic>> _savings;
@override List<Map<String, dynamic>> get savings {
  if (_savings is EqualUnmodifiableListView) return _savings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savings);
}

 final  List<Map<String, dynamic>> _savingsTransactions;
@override List<Map<String, dynamic>> get savingsTransactions {
  if (_savingsTransactions is EqualUnmodifiableListView) return _savingsTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savingsTransactions);
}


/// Create a copy of ExportDatabaseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDatabaseDataCopyWith<_ExportDatabaseData> get copyWith => __$ExportDatabaseDataCopyWithImpl<_ExportDatabaseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportDatabaseDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportDatabaseData&&const DeepCollectionEquality().equals(other.users, _users)&&const DeepCollectionEquality().equals(other.accounts, _accounts)&&const DeepCollectionEquality().equals(other.categories, _categories)&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&const DeepCollectionEquality().equals(other.recurringTransactions, _recurringTransactions)&&const DeepCollectionEquality().equals(other.budgets, _budgets)&&const DeepCollectionEquality().equals(other.budgetCategories, _budgetCategories)&&const DeepCollectionEquality().equals(other.goals, _goals)&&const DeepCollectionEquality().equals(other.savings, _savings)&&const DeepCollectionEquality().equals(other.savingsTransactions, _savingsTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),const DeepCollectionEquality().hash(_accounts),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_recurringTransactions),const DeepCollectionEquality().hash(_budgets),const DeepCollectionEquality().hash(_budgetCategories),const DeepCollectionEquality().hash(_goals),const DeepCollectionEquality().hash(_savings),const DeepCollectionEquality().hash(_savingsTransactions));
}

@override
String toString() {
    return 'ExportDatabaseData(users: $users, accounts: $accounts, categories: $categories, transactions: $transactions, recurringTransactions: $recurringTransactions, budgets: $budgets, budgetCategories: $budgetCategories, goals: $goals, savings: $savings, savingsTransactions: $savingsTransactions)';
}


}

/// @nodoc
abstract mixin class _$ExportDatabaseDataCopyWith<$Res> implements $ExportDatabaseDataCopyWith<$Res> {
  factory _$ExportDatabaseDataCopyWith(_ExportDatabaseData value, $Res Function(_ExportDatabaseData) _then) = __$ExportDatabaseDataCopyWithImpl;
@override @useResult
$Res call({
 List<Map<String, dynamic>> users, List<Map<String, dynamic>> accounts, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> transactions, List<Map<String, dynamic>> recurringTransactions, List<Map<String, dynamic>> budgets, List<Map<String, dynamic>> budgetCategories, List<Map<String, dynamic>> goals, List<Map<String, dynamic>> savings, List<Map<String, dynamic>> savingsTransactions
});




}
/// @nodoc
class __$ExportDatabaseDataCopyWithImpl<$Res>
    implements _$ExportDatabaseDataCopyWith<$Res> {
  __$ExportDatabaseDataCopyWithImpl(this._self, this._then);

  final _ExportDatabaseData _self;
  final $Res Function(_ExportDatabaseData) _then;

/// Create a copy of ExportDatabaseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? accounts = null,Object? categories = null,Object? transactions = null,Object? recurringTransactions = null,Object? budgets = null,Object? budgetCategories = null,Object? goals = null,Object? savings = null,Object? savingsTransactions = null,}) {
  return _then(_ExportDatabaseData(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,recurringTransactions: null == recurringTransactions ? _self._recurringTransactions : recurringTransactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,budgetCategories: null == budgetCategories ? _self._budgetCategories : budgetCategories // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,savings: null == savings ? _self._savings : savings // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,savingsTransactions: null == savingsTransactions ? _self._savingsTransactions : savingsTransactions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}


/// @nodoc
mixin _$ImportResult {

 bool get success; String get message; ImportStats get stats; String? get error;
/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportResultCopyWith<ImportResult> get copyWith => _$ImportResultCopyWithImpl<ImportResult>(this as ImportResult, _$identity);

  /// Serializes this ImportResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ImportResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportResult&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.stats, _this.stats) || other.stats == _this.stats)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ImportResult;
  return Object.hash(runtimeType,_this.success,_this.message,_this.stats,_this.error);
}

@override
String toString() {
  final _this = this as ImportResult;
  return 'ImportResult(success: ${_this.success}, message: ${_this.message}, stats: ${_this.stats}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ImportResultCopyWith<$Res>  {
  factory $ImportResultCopyWith(ImportResult value, $Res Function(ImportResult) _then) = _$ImportResultCopyWithImpl;
@useResult
$Res call({
 bool success, String message, ImportStats stats, String? error
});


$ImportStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$ImportResultCopyWithImpl<$Res>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._self, this._then);

  final ImportResult _self;
  final $Res Function(ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? stats = null,Object? error = freezed,}) {
  return _then(ImportResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ImportStats,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportStatsCopyWith<$Res> get stats {
  
  return $ImportStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImportResult].
extension ImportResultPatterns on ImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportResult value)  $default,){
final _that = this;
switch (_that) {
case _ImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  ImportStats stats,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.success,_that.message,_that.stats,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  ImportStats stats,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ImportResult():
return $default(_that.success,_that.message,_that.stats,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  ImportStats stats,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.success,_that.message,_that.stats,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportResult implements ImportResult {
  const _ImportResult({required this.success, required this.message, required this.stats, this.error});
  factory _ImportResult.fromJson(Map<String, dynamic> json) => _$ImportResultFromJson(json);

@override final  bool success;
@override final  String message;
@override final  ImportStats stats;
@override final  String? error;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportResultCopyWith<_ImportResult> get copyWith => __$ImportResultCopyWithImpl<_ImportResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportResult&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,message,stats,error);
}

@override
String toString() {
    return 'ImportResult(success: $success, message: $message, stats: $stats, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ImportResultCopyWith<$Res> implements $ImportResultCopyWith<$Res> {
  factory _$ImportResultCopyWith(_ImportResult value, $Res Function(_ImportResult) _then) = __$ImportResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, ImportStats stats, String? error
});


@override $ImportStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$ImportResultCopyWithImpl<$Res>
    implements _$ImportResultCopyWith<$Res> {
  __$ImportResultCopyWithImpl(this._self, this._then);

  final _ImportResult _self;
  final $Res Function(_ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? stats = null,Object? error = freezed,}) {
  return _then(_ImportResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ImportStats,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportStatsCopyWith<$Res> get stats {
  
  return $ImportStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$ImportStats {

 int get usersImported; int get accountsImported; int get categoriesImported; int get transactionsImported; int get recurringTransactionsImported; int get budgetsImported; int get budgetCategoriesImported; int get goalsImported; int get savingsImported; int get savingsTransactionsImported; bool get settingsImported;
/// Create a copy of ImportStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportStatsCopyWith<ImportStats> get copyWith => _$ImportStatsCopyWithImpl<ImportStats>(this as ImportStats, _$identity);

  /// Serializes this ImportStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ImportStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportStats&&(identical(other.usersImported, _this.usersImported) || other.usersImported == _this.usersImported)&&(identical(other.accountsImported, _this.accountsImported) || other.accountsImported == _this.accountsImported)&&(identical(other.categoriesImported, _this.categoriesImported) || other.categoriesImported == _this.categoriesImported)&&(identical(other.transactionsImported, _this.transactionsImported) || other.transactionsImported == _this.transactionsImported)&&(identical(other.recurringTransactionsImported, _this.recurringTransactionsImported) || other.recurringTransactionsImported == _this.recurringTransactionsImported)&&(identical(other.budgetsImported, _this.budgetsImported) || other.budgetsImported == _this.budgetsImported)&&(identical(other.budgetCategoriesImported, _this.budgetCategoriesImported) || other.budgetCategoriesImported == _this.budgetCategoriesImported)&&(identical(other.goalsImported, _this.goalsImported) || other.goalsImported == _this.goalsImported)&&(identical(other.savingsImported, _this.savingsImported) || other.savingsImported == _this.savingsImported)&&(identical(other.savingsTransactionsImported, _this.savingsTransactionsImported) || other.savingsTransactionsImported == _this.savingsTransactionsImported)&&(identical(other.settingsImported, _this.settingsImported) || other.settingsImported == _this.settingsImported));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ImportStats;
  return Object.hash(runtimeType,_this.usersImported,_this.accountsImported,_this.categoriesImported,_this.transactionsImported,_this.recurringTransactionsImported,_this.budgetsImported,_this.budgetCategoriesImported,_this.goalsImported,_this.savingsImported,_this.savingsTransactionsImported,_this.settingsImported);
}

@override
String toString() {
  final _this = this as ImportStats;
  return 'ImportStats(usersImported: ${_this.usersImported}, accountsImported: ${_this.accountsImported}, categoriesImported: ${_this.categoriesImported}, transactionsImported: ${_this.transactionsImported}, recurringTransactionsImported: ${_this.recurringTransactionsImported}, budgetsImported: ${_this.budgetsImported}, budgetCategoriesImported: ${_this.budgetCategoriesImported}, goalsImported: ${_this.goalsImported}, savingsImported: ${_this.savingsImported}, savingsTransactionsImported: ${_this.savingsTransactionsImported}, settingsImported: ${_this.settingsImported})';
}


}

/// @nodoc
abstract mixin class $ImportStatsCopyWith<$Res>  {
  factory $ImportStatsCopyWith(ImportStats value, $Res Function(ImportStats) _then) = _$ImportStatsCopyWithImpl;
@useResult
$Res call({
 int usersImported, int accountsImported, int categoriesImported, int transactionsImported, int recurringTransactionsImported, int budgetsImported, int budgetCategoriesImported, int goalsImported, int savingsImported, int savingsTransactionsImported, bool settingsImported
});




}
/// @nodoc
class _$ImportStatsCopyWithImpl<$Res>
    implements $ImportStatsCopyWith<$Res> {
  _$ImportStatsCopyWithImpl(this._self, this._then);

  final ImportStats _self;
  final $Res Function(ImportStats) _then;

/// Create a copy of ImportStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usersImported = null,Object? accountsImported = null,Object? categoriesImported = null,Object? transactionsImported = null,Object? recurringTransactionsImported = null,Object? budgetsImported = null,Object? budgetCategoriesImported = null,Object? goalsImported = null,Object? savingsImported = null,Object? savingsTransactionsImported = null,Object? settingsImported = null,}) {
  return _then(ImportStats(
usersImported: null == usersImported ? _self.usersImported : usersImported // ignore: cast_nullable_to_non_nullable
as int,accountsImported: null == accountsImported ? _self.accountsImported : accountsImported // ignore: cast_nullable_to_non_nullable
as int,categoriesImported: null == categoriesImported ? _self.categoriesImported : categoriesImported // ignore: cast_nullable_to_non_nullable
as int,transactionsImported: null == transactionsImported ? _self.transactionsImported : transactionsImported // ignore: cast_nullable_to_non_nullable
as int,recurringTransactionsImported: null == recurringTransactionsImported ? _self.recurringTransactionsImported : recurringTransactionsImported // ignore: cast_nullable_to_non_nullable
as int,budgetsImported: null == budgetsImported ? _self.budgetsImported : budgetsImported // ignore: cast_nullable_to_non_nullable
as int,budgetCategoriesImported: null == budgetCategoriesImported ? _self.budgetCategoriesImported : budgetCategoriesImported // ignore: cast_nullable_to_non_nullable
as int,goalsImported: null == goalsImported ? _self.goalsImported : goalsImported // ignore: cast_nullable_to_non_nullable
as int,savingsImported: null == savingsImported ? _self.savingsImported : savingsImported // ignore: cast_nullable_to_non_nullable
as int,savingsTransactionsImported: null == savingsTransactionsImported ? _self.savingsTransactionsImported : savingsTransactionsImported // ignore: cast_nullable_to_non_nullable
as int,settingsImported: null == settingsImported ? _self.settingsImported : settingsImported // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportStats].
extension ImportStatsPatterns on ImportStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportStats value)  $default,){
final _that = this;
switch (_that) {
case _ImportStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportStats value)?  $default,){
final _that = this;
switch (_that) {
case _ImportStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int usersImported,  int accountsImported,  int categoriesImported,  int transactionsImported,  int recurringTransactionsImported,  int budgetsImported,  int budgetCategoriesImported,  int goalsImported,  int savingsImported,  int savingsTransactionsImported,  bool settingsImported)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportStats() when $default != null:
return $default(_that.usersImported,_that.accountsImported,_that.categoriesImported,_that.transactionsImported,_that.recurringTransactionsImported,_that.budgetsImported,_that.budgetCategoriesImported,_that.goalsImported,_that.savingsImported,_that.savingsTransactionsImported,_that.settingsImported);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int usersImported,  int accountsImported,  int categoriesImported,  int transactionsImported,  int recurringTransactionsImported,  int budgetsImported,  int budgetCategoriesImported,  int goalsImported,  int savingsImported,  int savingsTransactionsImported,  bool settingsImported)  $default,) {final _that = this;
switch (_that) {
case _ImportStats():
return $default(_that.usersImported,_that.accountsImported,_that.categoriesImported,_that.transactionsImported,_that.recurringTransactionsImported,_that.budgetsImported,_that.budgetCategoriesImported,_that.goalsImported,_that.savingsImported,_that.savingsTransactionsImported,_that.settingsImported);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int usersImported,  int accountsImported,  int categoriesImported,  int transactionsImported,  int recurringTransactionsImported,  int budgetsImported,  int budgetCategoriesImported,  int goalsImported,  int savingsImported,  int savingsTransactionsImported,  bool settingsImported)?  $default,) {final _that = this;
switch (_that) {
case _ImportStats() when $default != null:
return $default(_that.usersImported,_that.accountsImported,_that.categoriesImported,_that.transactionsImported,_that.recurringTransactionsImported,_that.budgetsImported,_that.budgetCategoriesImported,_that.goalsImported,_that.savingsImported,_that.savingsTransactionsImported,_that.settingsImported);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImportStats extends ImportStats {
  const _ImportStats({required this.usersImported, required this.accountsImported, required this.categoriesImported, required this.transactionsImported, required this.recurringTransactionsImported, required this.budgetsImported, required this.budgetCategoriesImported, required this.goalsImported, required this.savingsImported, required this.savingsTransactionsImported, required this.settingsImported}): super._();
  factory _ImportStats.fromJson(Map<String, dynamic> json) => _$ImportStatsFromJson(json);

@override final  int usersImported;
@override final  int accountsImported;
@override final  int categoriesImported;
@override final  int transactionsImported;
@override final  int recurringTransactionsImported;
@override final  int budgetsImported;
@override final  int budgetCategoriesImported;
@override final  int goalsImported;
@override final  int savingsImported;
@override final  int savingsTransactionsImported;
@override final  bool settingsImported;

/// Create a copy of ImportStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportStatsCopyWith<_ImportStats> get copyWith => __$ImportStatsCopyWithImpl<_ImportStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportStats&&(identical(other.usersImported, usersImported) || other.usersImported == usersImported)&&(identical(other.accountsImported, accountsImported) || other.accountsImported == accountsImported)&&(identical(other.categoriesImported, categoriesImported) || other.categoriesImported == categoriesImported)&&(identical(other.transactionsImported, transactionsImported) || other.transactionsImported == transactionsImported)&&(identical(other.recurringTransactionsImported, recurringTransactionsImported) || other.recurringTransactionsImported == recurringTransactionsImported)&&(identical(other.budgetsImported, budgetsImported) || other.budgetsImported == budgetsImported)&&(identical(other.budgetCategoriesImported, budgetCategoriesImported) || other.budgetCategoriesImported == budgetCategoriesImported)&&(identical(other.goalsImported, goalsImported) || other.goalsImported == goalsImported)&&(identical(other.savingsImported, savingsImported) || other.savingsImported == savingsImported)&&(identical(other.savingsTransactionsImported, savingsTransactionsImported) || other.savingsTransactionsImported == savingsTransactionsImported)&&(identical(other.settingsImported, settingsImported) || other.settingsImported == settingsImported));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,usersImported,accountsImported,categoriesImported,transactionsImported,recurringTransactionsImported,budgetsImported,budgetCategoriesImported,goalsImported,savingsImported,savingsTransactionsImported,settingsImported);
}

@override
String toString() {
    return 'ImportStats(usersImported: $usersImported, accountsImported: $accountsImported, categoriesImported: $categoriesImported, transactionsImported: $transactionsImported, recurringTransactionsImported: $recurringTransactionsImported, budgetsImported: $budgetsImported, budgetCategoriesImported: $budgetCategoriesImported, goalsImported: $goalsImported, savingsImported: $savingsImported, savingsTransactionsImported: $savingsTransactionsImported, settingsImported: $settingsImported)';
}


}

/// @nodoc
abstract mixin class _$ImportStatsCopyWith<$Res> implements $ImportStatsCopyWith<$Res> {
  factory _$ImportStatsCopyWith(_ImportStats value, $Res Function(_ImportStats) _then) = __$ImportStatsCopyWithImpl;
@override @useResult
$Res call({
 int usersImported, int accountsImported, int categoriesImported, int transactionsImported, int recurringTransactionsImported, int budgetsImported, int budgetCategoriesImported, int goalsImported, int savingsImported, int savingsTransactionsImported, bool settingsImported
});




}
/// @nodoc
class __$ImportStatsCopyWithImpl<$Res>
    implements _$ImportStatsCopyWith<$Res> {
  __$ImportStatsCopyWithImpl(this._self, this._then);

  final _ImportStats _self;
  final $Res Function(_ImportStats) _then;

/// Create a copy of ImportStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usersImported = null,Object? accountsImported = null,Object? categoriesImported = null,Object? transactionsImported = null,Object? recurringTransactionsImported = null,Object? budgetsImported = null,Object? budgetCategoriesImported = null,Object? goalsImported = null,Object? savingsImported = null,Object? savingsTransactionsImported = null,Object? settingsImported = null,}) {
  return _then(_ImportStats(
usersImported: null == usersImported ? _self.usersImported : usersImported // ignore: cast_nullable_to_non_nullable
as int,accountsImported: null == accountsImported ? _self.accountsImported : accountsImported // ignore: cast_nullable_to_non_nullable
as int,categoriesImported: null == categoriesImported ? _self.categoriesImported : categoriesImported // ignore: cast_nullable_to_non_nullable
as int,transactionsImported: null == transactionsImported ? _self.transactionsImported : transactionsImported // ignore: cast_nullable_to_non_nullable
as int,recurringTransactionsImported: null == recurringTransactionsImported ? _self.recurringTransactionsImported : recurringTransactionsImported // ignore: cast_nullable_to_non_nullable
as int,budgetsImported: null == budgetsImported ? _self.budgetsImported : budgetsImported // ignore: cast_nullable_to_non_nullable
as int,budgetCategoriesImported: null == budgetCategoriesImported ? _self.budgetCategoriesImported : budgetCategoriesImported // ignore: cast_nullable_to_non_nullable
as int,goalsImported: null == goalsImported ? _self.goalsImported : goalsImported // ignore: cast_nullable_to_non_nullable
as int,savingsImported: null == savingsImported ? _self.savingsImported : savingsImported // ignore: cast_nullable_to_non_nullable
as int,savingsTransactionsImported: null == savingsTransactionsImported ? _self.savingsTransactionsImported : savingsTransactionsImported // ignore: cast_nullable_to_non_nullable
as int,settingsImported: null == settingsImported ? _self.settingsImported : settingsImported // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
