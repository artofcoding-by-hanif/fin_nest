// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExportData _$ExportDataFromJson(Map<String, dynamic> json) {
  return _ExportData.fromJson(json);
}

/// @nodoc
mixin _$ExportData {
  ExportMetadata get metadata => throw _privateConstructorUsedError;
  ExportSettings get settings => throw _privateConstructorUsedError;
  ExportDatabaseData get database => throw _privateConstructorUsedError;

  /// Serializes this ExportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportDataCopyWith<ExportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportDataCopyWith<$Res> {
  factory $ExportDataCopyWith(
    ExportData value,
    $Res Function(ExportData) then,
  ) = _$ExportDataCopyWithImpl<$Res, ExportData>;
  @useResult
  $Res call({
    ExportMetadata metadata,
    ExportSettings settings,
    ExportDatabaseData database,
  });

  $ExportMetadataCopyWith<$Res> get metadata;
  $ExportSettingsCopyWith<$Res> get settings;
  $ExportDatabaseDataCopyWith<$Res> get database;
}

/// @nodoc
class _$ExportDataCopyWithImpl<$Res, $Val extends ExportData>
    implements $ExportDataCopyWith<$Res> {
  _$ExportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
    Object? settings = null,
    Object? database = null,
  }) {
    return _then(
      _value.copyWith(
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as ExportMetadata,
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as ExportSettings,
            database: null == database
                ? _value.database
                : database // ignore: cast_nullable_to_non_nullable
                      as ExportDatabaseData,
          )
          as $Val,
    );
  }

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExportMetadataCopyWith<$Res> get metadata {
    return $ExportMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExportSettingsCopyWith<$Res> get settings {
    return $ExportSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExportDatabaseDataCopyWith<$Res> get database {
    return $ExportDatabaseDataCopyWith<$Res>(_value.database, (value) {
      return _then(_value.copyWith(database: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExportDataImplCopyWith<$Res>
    implements $ExportDataCopyWith<$Res> {
  factory _$$ExportDataImplCopyWith(
    _$ExportDataImpl value,
    $Res Function(_$ExportDataImpl) then,
  ) = __$$ExportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ExportMetadata metadata,
    ExportSettings settings,
    ExportDatabaseData database,
  });

  @override
  $ExportMetadataCopyWith<$Res> get metadata;
  @override
  $ExportSettingsCopyWith<$Res> get settings;
  @override
  $ExportDatabaseDataCopyWith<$Res> get database;
}

/// @nodoc
class __$$ExportDataImplCopyWithImpl<$Res>
    extends _$ExportDataCopyWithImpl<$Res, _$ExportDataImpl>
    implements _$$ExportDataImplCopyWith<$Res> {
  __$$ExportDataImplCopyWithImpl(
    _$ExportDataImpl _value,
    $Res Function(_$ExportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metadata = null,
    Object? settings = null,
    Object? database = null,
  }) {
    return _then(
      _$ExportDataImpl(
        metadata: null == metadata
            ? _value.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as ExportMetadata,
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as ExportSettings,
        database: null == database
            ? _value.database
            : database // ignore: cast_nullable_to_non_nullable
                  as ExportDatabaseData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportDataImpl implements _ExportData {
  const _$ExportDataImpl({
    required this.metadata,
    required this.settings,
    required this.database,
  });

  factory _$ExportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportDataImplFromJson(json);

  @override
  final ExportMetadata metadata;
  @override
  final ExportSettings settings;
  @override
  final ExportDatabaseData database;

  @override
  String toString() {
    return 'ExportData(metadata: $metadata, settings: $settings, database: $database)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportDataImpl &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.database, database) ||
                other.database == database));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, metadata, settings, database);

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportDataImplCopyWith<_$ExportDataImpl> get copyWith =>
      __$$ExportDataImplCopyWithImpl<_$ExportDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportDataImplToJson(this);
  }
}

abstract class _ExportData implements ExportData {
  const factory _ExportData({
    required final ExportMetadata metadata,
    required final ExportSettings settings,
    required final ExportDatabaseData database,
  }) = _$ExportDataImpl;

  factory _ExportData.fromJson(Map<String, dynamic> json) =
      _$ExportDataImpl.fromJson;

  @override
  ExportMetadata get metadata;
  @override
  ExportSettings get settings;
  @override
  ExportDatabaseData get database;

  /// Create a copy of ExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportDataImplCopyWith<_$ExportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExportMetadata _$ExportMetadataFromJson(Map<String, dynamic> json) {
  return _ExportMetadata.fromJson(json);
}

/// @nodoc
mixin _$ExportMetadata {
  String get version => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  DateTime get exportDate => throw _privateConstructorUsedError;
  String get deviceInfo => throw _privateConstructorUsedError;

  /// Serializes this ExportMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExportMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportMetadataCopyWith<ExportMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportMetadataCopyWith<$Res> {
  factory $ExportMetadataCopyWith(
    ExportMetadata value,
    $Res Function(ExportMetadata) then,
  ) = _$ExportMetadataCopyWithImpl<$Res, ExportMetadata>;
  @useResult
  $Res call({
    String version,
    String appVersion,
    DateTime exportDate,
    String deviceInfo,
  });
}

/// @nodoc
class _$ExportMetadataCopyWithImpl<$Res, $Val extends ExportMetadata>
    implements $ExportMetadataCopyWith<$Res> {
  _$ExportMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? appVersion = null,
    Object? exportDate = null,
    Object? deviceInfo = null,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            appVersion: null == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            exportDate: null == exportDate
                ? _value.exportDate
                : exportDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deviceInfo: null == deviceInfo
                ? _value.deviceInfo
                : deviceInfo // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExportMetadataImplCopyWith<$Res>
    implements $ExportMetadataCopyWith<$Res> {
  factory _$$ExportMetadataImplCopyWith(
    _$ExportMetadataImpl value,
    $Res Function(_$ExportMetadataImpl) then,
  ) = __$$ExportMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    String appVersion,
    DateTime exportDate,
    String deviceInfo,
  });
}

/// @nodoc
class __$$ExportMetadataImplCopyWithImpl<$Res>
    extends _$ExportMetadataCopyWithImpl<$Res, _$ExportMetadataImpl>
    implements _$$ExportMetadataImplCopyWith<$Res> {
  __$$ExportMetadataImplCopyWithImpl(
    _$ExportMetadataImpl _value,
    $Res Function(_$ExportMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExportMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? appVersion = null,
    Object? exportDate = null,
    Object? deviceInfo = null,
  }) {
    return _then(
      _$ExportMetadataImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        appVersion: null == appVersion
            ? _value.appVersion
            : appVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        exportDate: null == exportDate
            ? _value.exportDate
            : exportDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deviceInfo: null == deviceInfo
            ? _value.deviceInfo
            : deviceInfo // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportMetadataImpl implements _ExportMetadata {
  const _$ExportMetadataImpl({
    required this.version,
    required this.appVersion,
    required this.exportDate,
    required this.deviceInfo,
  });

  factory _$ExportMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportMetadataImplFromJson(json);

  @override
  final String version;
  @override
  final String appVersion;
  @override
  final DateTime exportDate;
  @override
  final String deviceInfo;

  @override
  String toString() {
    return 'ExportMetadata(version: $version, appVersion: $appVersion, exportDate: $exportDate, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportMetadataImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.exportDate, exportDate) ||
                other.exportDate == exportDate) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, version, appVersion, exportDate, deviceInfo);

  /// Create a copy of ExportMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportMetadataImplCopyWith<_$ExportMetadataImpl> get copyWith =>
      __$$ExportMetadataImplCopyWithImpl<_$ExportMetadataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportMetadataImplToJson(this);
  }
}

abstract class _ExportMetadata implements ExportMetadata {
  const factory _ExportMetadata({
    required final String version,
    required final String appVersion,
    required final DateTime exportDate,
    required final String deviceInfo,
  }) = _$ExportMetadataImpl;

  factory _ExportMetadata.fromJson(Map<String, dynamic> json) =
      _$ExportMetadataImpl.fromJson;

  @override
  String get version;
  @override
  String get appVersion;
  @override
  DateTime get exportDate;
  @override
  String get deviceInfo;

  /// Create a copy of ExportMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportMetadataImplCopyWith<_$ExportMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExportSettings _$ExportSettingsFromJson(Map<String, dynamic> json) {
  return _ExportSettings.fromJson(json);
}

/// @nodoc
mixin _$ExportSettings {
  String get themeMode => throw _privateConstructorUsedError;
  String get currencyFormat => throw _privateConstructorUsedError;
  String get dateFormat => throw _privateConstructorUsedError;
  String get numberFormat => throw _privateConstructorUsedError;
  String get defaultCurrency => throw _privateConstructorUsedError;
  bool get biometricEnabled => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;

  /// Serializes this ExportSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExportSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportSettingsCopyWith<ExportSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportSettingsCopyWith<$Res> {
  factory $ExportSettingsCopyWith(
    ExportSettings value,
    $Res Function(ExportSettings) then,
  ) = _$ExportSettingsCopyWithImpl<$Res, ExportSettings>;
  @useResult
  $Res call({
    String themeMode,
    String currencyFormat,
    String dateFormat,
    String numberFormat,
    String defaultCurrency,
    bool biometricEnabled,
    bool notificationsEnabled,
  });
}

/// @nodoc
class _$ExportSettingsCopyWithImpl<$Res, $Val extends ExportSettings>
    implements $ExportSettingsCopyWith<$Res> {
  _$ExportSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? currencyFormat = null,
    Object? dateFormat = null,
    Object? numberFormat = null,
    Object? defaultCurrency = null,
    Object? biometricEnabled = null,
    Object? notificationsEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as String,
            currencyFormat: null == currencyFormat
                ? _value.currencyFormat
                : currencyFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            dateFormat: null == dateFormat
                ? _value.dateFormat
                : dateFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            numberFormat: null == numberFormat
                ? _value.numberFormat
                : numberFormat // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultCurrency: null == defaultCurrency
                ? _value.defaultCurrency
                : defaultCurrency // ignore: cast_nullable_to_non_nullable
                      as String,
            biometricEnabled: null == biometricEnabled
                ? _value.biometricEnabled
                : biometricEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            notificationsEnabled: null == notificationsEnabled
                ? _value.notificationsEnabled
                : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExportSettingsImplCopyWith<$Res>
    implements $ExportSettingsCopyWith<$Res> {
  factory _$$ExportSettingsImplCopyWith(
    _$ExportSettingsImpl value,
    $Res Function(_$ExportSettingsImpl) then,
  ) = __$$ExportSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String themeMode,
    String currencyFormat,
    String dateFormat,
    String numberFormat,
    String defaultCurrency,
    bool biometricEnabled,
    bool notificationsEnabled,
  });
}

/// @nodoc
class __$$ExportSettingsImplCopyWithImpl<$Res>
    extends _$ExportSettingsCopyWithImpl<$Res, _$ExportSettingsImpl>
    implements _$$ExportSettingsImplCopyWith<$Res> {
  __$$ExportSettingsImplCopyWithImpl(
    _$ExportSettingsImpl _value,
    $Res Function(_$ExportSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExportSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? currencyFormat = null,
    Object? dateFormat = null,
    Object? numberFormat = null,
    Object? defaultCurrency = null,
    Object? biometricEnabled = null,
    Object? notificationsEnabled = null,
  }) {
    return _then(
      _$ExportSettingsImpl(
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as String,
        currencyFormat: null == currencyFormat
            ? _value.currencyFormat
            : currencyFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        dateFormat: null == dateFormat
            ? _value.dateFormat
            : dateFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        numberFormat: null == numberFormat
            ? _value.numberFormat
            : numberFormat // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultCurrency: null == defaultCurrency
            ? _value.defaultCurrency
            : defaultCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        biometricEnabled: null == biometricEnabled
            ? _value.biometricEnabled
            : biometricEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        notificationsEnabled: null == notificationsEnabled
            ? _value.notificationsEnabled
            : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportSettingsImpl extends _ExportSettings {
  const _$ExportSettingsImpl({
    required this.themeMode,
    required this.currencyFormat,
    required this.dateFormat,
    required this.numberFormat,
    required this.defaultCurrency,
    required this.biometricEnabled,
    required this.notificationsEnabled,
  }) : super._();

  factory _$ExportSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportSettingsImplFromJson(json);

  @override
  final String themeMode;
  @override
  final String currencyFormat;
  @override
  final String dateFormat;
  @override
  final String numberFormat;
  @override
  final String defaultCurrency;
  @override
  final bool biometricEnabled;
  @override
  final bool notificationsEnabled;

  @override
  String toString() {
    return 'ExportSettings(themeMode: $themeMode, currencyFormat: $currencyFormat, dateFormat: $dateFormat, numberFormat: $numberFormat, defaultCurrency: $defaultCurrency, biometricEnabled: $biometricEnabled, notificationsEnabled: $notificationsEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.currencyFormat, currencyFormat) ||
                other.currencyFormat == currencyFormat) &&
            (identical(other.dateFormat, dateFormat) ||
                other.dateFormat == dateFormat) &&
            (identical(other.numberFormat, numberFormat) ||
                other.numberFormat == numberFormat) &&
            (identical(other.defaultCurrency, defaultCurrency) ||
                other.defaultCurrency == defaultCurrency) &&
            (identical(other.biometricEnabled, biometricEnabled) ||
                other.biometricEnabled == biometricEnabled) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    themeMode,
    currencyFormat,
    dateFormat,
    numberFormat,
    defaultCurrency,
    biometricEnabled,
    notificationsEnabled,
  );

  /// Create a copy of ExportSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportSettingsImplCopyWith<_$ExportSettingsImpl> get copyWith =>
      __$$ExportSettingsImplCopyWithImpl<_$ExportSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportSettingsImplToJson(this);
  }
}

abstract class _ExportSettings extends ExportSettings {
  const factory _ExportSettings({
    required final String themeMode,
    required final String currencyFormat,
    required final String dateFormat,
    required final String numberFormat,
    required final String defaultCurrency,
    required final bool biometricEnabled,
    required final bool notificationsEnabled,
  }) = _$ExportSettingsImpl;
  const _ExportSettings._() : super._();

  factory _ExportSettings.fromJson(Map<String, dynamic> json) =
      _$ExportSettingsImpl.fromJson;

  @override
  String get themeMode;
  @override
  String get currencyFormat;
  @override
  String get dateFormat;
  @override
  String get numberFormat;
  @override
  String get defaultCurrency;
  @override
  bool get biometricEnabled;
  @override
  bool get notificationsEnabled;

  /// Create a copy of ExportSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportSettingsImplCopyWith<_$ExportSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExportDatabaseData _$ExportDatabaseDataFromJson(Map<String, dynamic> json) {
  return _ExportDatabaseData.fromJson(json);
}

/// @nodoc
mixin _$ExportDatabaseData {
  List<Map<String, dynamic>> get users => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get accounts => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get categories =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get transactions =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get recurringTransactions =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get budgets => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get budgetCategories =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get goals => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get savings => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get savingsTransactions =>
      throw _privateConstructorUsedError;

  /// Serializes this ExportDatabaseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExportDatabaseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportDatabaseDataCopyWith<ExportDatabaseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportDatabaseDataCopyWith<$Res> {
  factory $ExportDatabaseDataCopyWith(
    ExportDatabaseData value,
    $Res Function(ExportDatabaseData) then,
  ) = _$ExportDatabaseDataCopyWithImpl<$Res, ExportDatabaseData>;
  @useResult
  $Res call({
    List<Map<String, dynamic>> users,
    List<Map<String, dynamic>> accounts,
    List<Map<String, dynamic>> categories,
    List<Map<String, dynamic>> transactions,
    List<Map<String, dynamic>> recurringTransactions,
    List<Map<String, dynamic>> budgets,
    List<Map<String, dynamic>> budgetCategories,
    List<Map<String, dynamic>> goals,
    List<Map<String, dynamic>> savings,
    List<Map<String, dynamic>> savingsTransactions,
  });
}

/// @nodoc
class _$ExportDatabaseDataCopyWithImpl<$Res, $Val extends ExportDatabaseData>
    implements $ExportDatabaseDataCopyWith<$Res> {
  _$ExportDatabaseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportDatabaseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? accounts = null,
    Object? categories = null,
    Object? transactions = null,
    Object? recurringTransactions = null,
    Object? budgets = null,
    Object? budgetCategories = null,
    Object? goals = null,
    Object? savings = null,
    Object? savingsTransactions = null,
  }) {
    return _then(
      _value.copyWith(
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            accounts: null == accounts
                ? _value.accounts
                : accounts // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            recurringTransactions: null == recurringTransactions
                ? _value.recurringTransactions
                : recurringTransactions // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            budgets: null == budgets
                ? _value.budgets
                : budgets // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            budgetCategories: null == budgetCategories
                ? _value.budgetCategories
                : budgetCategories // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            goals: null == goals
                ? _value.goals
                : goals // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            savings: null == savings
                ? _value.savings
                : savings // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            savingsTransactions: null == savingsTransactions
                ? _value.savingsTransactions
                : savingsTransactions // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExportDatabaseDataImplCopyWith<$Res>
    implements $ExportDatabaseDataCopyWith<$Res> {
  factory _$$ExportDatabaseDataImplCopyWith(
    _$ExportDatabaseDataImpl value,
    $Res Function(_$ExportDatabaseDataImpl) then,
  ) = __$$ExportDatabaseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Map<String, dynamic>> users,
    List<Map<String, dynamic>> accounts,
    List<Map<String, dynamic>> categories,
    List<Map<String, dynamic>> transactions,
    List<Map<String, dynamic>> recurringTransactions,
    List<Map<String, dynamic>> budgets,
    List<Map<String, dynamic>> budgetCategories,
    List<Map<String, dynamic>> goals,
    List<Map<String, dynamic>> savings,
    List<Map<String, dynamic>> savingsTransactions,
  });
}

/// @nodoc
class __$$ExportDatabaseDataImplCopyWithImpl<$Res>
    extends _$ExportDatabaseDataCopyWithImpl<$Res, _$ExportDatabaseDataImpl>
    implements _$$ExportDatabaseDataImplCopyWith<$Res> {
  __$$ExportDatabaseDataImplCopyWithImpl(
    _$ExportDatabaseDataImpl _value,
    $Res Function(_$ExportDatabaseDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExportDatabaseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? accounts = null,
    Object? categories = null,
    Object? transactions = null,
    Object? recurringTransactions = null,
    Object? budgets = null,
    Object? budgetCategories = null,
    Object? goals = null,
    Object? savings = null,
    Object? savingsTransactions = null,
  }) {
    return _then(
      _$ExportDatabaseDataImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        accounts: null == accounts
            ? _value._accounts
            : accounts // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        recurringTransactions: null == recurringTransactions
            ? _value._recurringTransactions
            : recurringTransactions // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        budgets: null == budgets
            ? _value._budgets
            : budgets // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        budgetCategories: null == budgetCategories
            ? _value._budgetCategories
            : budgetCategories // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        goals: null == goals
            ? _value._goals
            : goals // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        savings: null == savings
            ? _value._savings
            : savings // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        savingsTransactions: null == savingsTransactions
            ? _value._savingsTransactions
            : savingsTransactions // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExportDatabaseDataImpl implements _ExportDatabaseData {
  const _$ExportDatabaseDataImpl({
    required final List<Map<String, dynamic>> users,
    required final List<Map<String, dynamic>> accounts,
    required final List<Map<String, dynamic>> categories,
    required final List<Map<String, dynamic>> transactions,
    required final List<Map<String, dynamic>> recurringTransactions,
    required final List<Map<String, dynamic>> budgets,
    required final List<Map<String, dynamic>> budgetCategories,
    required final List<Map<String, dynamic>> goals,
    required final List<Map<String, dynamic>> savings,
    required final List<Map<String, dynamic>> savingsTransactions,
  }) : _users = users,
       _accounts = accounts,
       _categories = categories,
       _transactions = transactions,
       _recurringTransactions = recurringTransactions,
       _budgets = budgets,
       _budgetCategories = budgetCategories,
       _goals = goals,
       _savings = savings,
       _savingsTransactions = savingsTransactions;

  factory _$ExportDatabaseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExportDatabaseDataImplFromJson(json);

  final List<Map<String, dynamic>> _users;
  @override
  List<Map<String, dynamic>> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<Map<String, dynamic>> _accounts;
  @override
  List<Map<String, dynamic>> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  final List<Map<String, dynamic>> _categories;
  @override
  List<Map<String, dynamic>> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<Map<String, dynamic>> _transactions;
  @override
  List<Map<String, dynamic>> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  final List<Map<String, dynamic>> _recurringTransactions;
  @override
  List<Map<String, dynamic>> get recurringTransactions {
    if (_recurringTransactions is EqualUnmodifiableListView)
      return _recurringTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recurringTransactions);
  }

  final List<Map<String, dynamic>> _budgets;
  @override
  List<Map<String, dynamic>> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  final List<Map<String, dynamic>> _budgetCategories;
  @override
  List<Map<String, dynamic>> get budgetCategories {
    if (_budgetCategories is EqualUnmodifiableListView)
      return _budgetCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgetCategories);
  }

  final List<Map<String, dynamic>> _goals;
  @override
  List<Map<String, dynamic>> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  final List<Map<String, dynamic>> _savings;
  @override
  List<Map<String, dynamic>> get savings {
    if (_savings is EqualUnmodifiableListView) return _savings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savings);
  }

  final List<Map<String, dynamic>> _savingsTransactions;
  @override
  List<Map<String, dynamic>> get savingsTransactions {
    if (_savingsTransactions is EqualUnmodifiableListView)
      return _savingsTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_savingsTransactions);
  }

  @override
  String toString() {
    return 'ExportDatabaseData(users: $users, accounts: $accounts, categories: $categories, transactions: $transactions, recurringTransactions: $recurringTransactions, budgets: $budgets, budgetCategories: $budgetCategories, goals: $goals, savings: $savings, savingsTransactions: $savingsTransactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportDatabaseDataImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(other._accounts, _accounts) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ) &&
            const DeepCollectionEquality().equals(
              other._recurringTransactions,
              _recurringTransactions,
            ) &&
            const DeepCollectionEquality().equals(other._budgets, _budgets) &&
            const DeepCollectionEquality().equals(
              other._budgetCategories,
              _budgetCategories,
            ) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            const DeepCollectionEquality().equals(other._savings, _savings) &&
            const DeepCollectionEquality().equals(
              other._savingsTransactions,
              _savingsTransactions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    const DeepCollectionEquality().hash(_accounts),
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_transactions),
    const DeepCollectionEquality().hash(_recurringTransactions),
    const DeepCollectionEquality().hash(_budgets),
    const DeepCollectionEquality().hash(_budgetCategories),
    const DeepCollectionEquality().hash(_goals),
    const DeepCollectionEquality().hash(_savings),
    const DeepCollectionEquality().hash(_savingsTransactions),
  );

  /// Create a copy of ExportDatabaseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportDatabaseDataImplCopyWith<_$ExportDatabaseDataImpl> get copyWith =>
      __$$ExportDatabaseDataImplCopyWithImpl<_$ExportDatabaseDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExportDatabaseDataImplToJson(this);
  }
}

abstract class _ExportDatabaseData implements ExportDatabaseData {
  const factory _ExportDatabaseData({
    required final List<Map<String, dynamic>> users,
    required final List<Map<String, dynamic>> accounts,
    required final List<Map<String, dynamic>> categories,
    required final List<Map<String, dynamic>> transactions,
    required final List<Map<String, dynamic>> recurringTransactions,
    required final List<Map<String, dynamic>> budgets,
    required final List<Map<String, dynamic>> budgetCategories,
    required final List<Map<String, dynamic>> goals,
    required final List<Map<String, dynamic>> savings,
    required final List<Map<String, dynamic>> savingsTransactions,
  }) = _$ExportDatabaseDataImpl;

  factory _ExportDatabaseData.fromJson(Map<String, dynamic> json) =
      _$ExportDatabaseDataImpl.fromJson;

  @override
  List<Map<String, dynamic>> get users;
  @override
  List<Map<String, dynamic>> get accounts;
  @override
  List<Map<String, dynamic>> get categories;
  @override
  List<Map<String, dynamic>> get transactions;
  @override
  List<Map<String, dynamic>> get recurringTransactions;
  @override
  List<Map<String, dynamic>> get budgets;
  @override
  List<Map<String, dynamic>> get budgetCategories;
  @override
  List<Map<String, dynamic>> get goals;
  @override
  List<Map<String, dynamic>> get savings;
  @override
  List<Map<String, dynamic>> get savingsTransactions;

  /// Create a copy of ExportDatabaseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportDatabaseDataImplCopyWith<_$ExportDatabaseDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImportResult _$ImportResultFromJson(Map<String, dynamic> json) {
  return _ImportResult.fromJson(json);
}

/// @nodoc
mixin _$ImportResult {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  ImportStats get stats => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ImportResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportResultCopyWith<ImportResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportResultCopyWith<$Res> {
  factory $ImportResultCopyWith(
    ImportResult value,
    $Res Function(ImportResult) then,
  ) = _$ImportResultCopyWithImpl<$Res, ImportResult>;
  @useResult
  $Res call({bool success, String message, ImportStats stats, String? error});

  $ImportStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$ImportResultCopyWithImpl<$Res, $Val extends ImportResult>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? stats = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as ImportStats,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImportStatsCopyWith<$Res> get stats {
    return $ImportStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImportResultImplCopyWith<$Res>
    implements $ImportResultCopyWith<$Res> {
  factory _$$ImportResultImplCopyWith(
    _$ImportResultImpl value,
    $Res Function(_$ImportResultImpl) then,
  ) = __$$ImportResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, ImportStats stats, String? error});

  @override
  $ImportStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$ImportResultImplCopyWithImpl<$Res>
    extends _$ImportResultCopyWithImpl<$Res, _$ImportResultImpl>
    implements _$$ImportResultImplCopyWith<$Res> {
  __$$ImportResultImplCopyWithImpl(
    _$ImportResultImpl _value,
    $Res Function(_$ImportResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? stats = null,
    Object? error = freezed,
  }) {
    return _then(
      _$ImportResultImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as ImportStats,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportResultImpl implements _ImportResult {
  const _$ImportResultImpl({
    required this.success,
    required this.message,
    required this.stats,
    this.error,
  });

  factory _$ImportResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportResultImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final ImportStats stats;
  @override
  final String? error;

  @override
  String toString() {
    return 'ImportResult(success: $success, message: $message, stats: $stats, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, stats, error);

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      __$$ImportResultImplCopyWithImpl<_$ImportResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportResultImplToJson(this);
  }
}

abstract class _ImportResult implements ImportResult {
  const factory _ImportResult({
    required final bool success,
    required final String message,
    required final ImportStats stats,
    final String? error,
  }) = _$ImportResultImpl;

  factory _ImportResult.fromJson(Map<String, dynamic> json) =
      _$ImportResultImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  ImportStats get stats;
  @override
  String? get error;

  /// Create a copy of ImportResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportResultImplCopyWith<_$ImportResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImportStats _$ImportStatsFromJson(Map<String, dynamic> json) {
  return _ImportStats.fromJson(json);
}

/// @nodoc
mixin _$ImportStats {
  int get usersImported => throw _privateConstructorUsedError;
  int get accountsImported => throw _privateConstructorUsedError;
  int get categoriesImported => throw _privateConstructorUsedError;
  int get transactionsImported => throw _privateConstructorUsedError;
  int get recurringTransactionsImported => throw _privateConstructorUsedError;
  int get budgetsImported => throw _privateConstructorUsedError;
  int get budgetCategoriesImported => throw _privateConstructorUsedError;
  int get goalsImported => throw _privateConstructorUsedError;
  int get savingsImported => throw _privateConstructorUsedError;
  int get savingsTransactionsImported => throw _privateConstructorUsedError;
  bool get settingsImported => throw _privateConstructorUsedError;

  /// Serializes this ImportStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportStatsCopyWith<ImportStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportStatsCopyWith<$Res> {
  factory $ImportStatsCopyWith(
    ImportStats value,
    $Res Function(ImportStats) then,
  ) = _$ImportStatsCopyWithImpl<$Res, ImportStats>;
  @useResult
  $Res call({
    int usersImported,
    int accountsImported,
    int categoriesImported,
    int transactionsImported,
    int recurringTransactionsImported,
    int budgetsImported,
    int budgetCategoriesImported,
    int goalsImported,
    int savingsImported,
    int savingsTransactionsImported,
    bool settingsImported,
  });
}

/// @nodoc
class _$ImportStatsCopyWithImpl<$Res, $Val extends ImportStats>
    implements $ImportStatsCopyWith<$Res> {
  _$ImportStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usersImported = null,
    Object? accountsImported = null,
    Object? categoriesImported = null,
    Object? transactionsImported = null,
    Object? recurringTransactionsImported = null,
    Object? budgetsImported = null,
    Object? budgetCategoriesImported = null,
    Object? goalsImported = null,
    Object? savingsImported = null,
    Object? savingsTransactionsImported = null,
    Object? settingsImported = null,
  }) {
    return _then(
      _value.copyWith(
            usersImported: null == usersImported
                ? _value.usersImported
                : usersImported // ignore: cast_nullable_to_non_nullable
                      as int,
            accountsImported: null == accountsImported
                ? _value.accountsImported
                : accountsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            categoriesImported: null == categoriesImported
                ? _value.categoriesImported
                : categoriesImported // ignore: cast_nullable_to_non_nullable
                      as int,
            transactionsImported: null == transactionsImported
                ? _value.transactionsImported
                : transactionsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            recurringTransactionsImported: null == recurringTransactionsImported
                ? _value.recurringTransactionsImported
                : recurringTransactionsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            budgetsImported: null == budgetsImported
                ? _value.budgetsImported
                : budgetsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            budgetCategoriesImported: null == budgetCategoriesImported
                ? _value.budgetCategoriesImported
                : budgetCategoriesImported // ignore: cast_nullable_to_non_nullable
                      as int,
            goalsImported: null == goalsImported
                ? _value.goalsImported
                : goalsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            savingsImported: null == savingsImported
                ? _value.savingsImported
                : savingsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            savingsTransactionsImported: null == savingsTransactionsImported
                ? _value.savingsTransactionsImported
                : savingsTransactionsImported // ignore: cast_nullable_to_non_nullable
                      as int,
            settingsImported: null == settingsImported
                ? _value.settingsImported
                : settingsImported // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImportStatsImplCopyWith<$Res>
    implements $ImportStatsCopyWith<$Res> {
  factory _$$ImportStatsImplCopyWith(
    _$ImportStatsImpl value,
    $Res Function(_$ImportStatsImpl) then,
  ) = __$$ImportStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int usersImported,
    int accountsImported,
    int categoriesImported,
    int transactionsImported,
    int recurringTransactionsImported,
    int budgetsImported,
    int budgetCategoriesImported,
    int goalsImported,
    int savingsImported,
    int savingsTransactionsImported,
    bool settingsImported,
  });
}

/// @nodoc
class __$$ImportStatsImplCopyWithImpl<$Res>
    extends _$ImportStatsCopyWithImpl<$Res, _$ImportStatsImpl>
    implements _$$ImportStatsImplCopyWith<$Res> {
  __$$ImportStatsImplCopyWithImpl(
    _$ImportStatsImpl _value,
    $Res Function(_$ImportStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? usersImported = null,
    Object? accountsImported = null,
    Object? categoriesImported = null,
    Object? transactionsImported = null,
    Object? recurringTransactionsImported = null,
    Object? budgetsImported = null,
    Object? budgetCategoriesImported = null,
    Object? goalsImported = null,
    Object? savingsImported = null,
    Object? savingsTransactionsImported = null,
    Object? settingsImported = null,
  }) {
    return _then(
      _$ImportStatsImpl(
        usersImported: null == usersImported
            ? _value.usersImported
            : usersImported // ignore: cast_nullable_to_non_nullable
                  as int,
        accountsImported: null == accountsImported
            ? _value.accountsImported
            : accountsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        categoriesImported: null == categoriesImported
            ? _value.categoriesImported
            : categoriesImported // ignore: cast_nullable_to_non_nullable
                  as int,
        transactionsImported: null == transactionsImported
            ? _value.transactionsImported
            : transactionsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        recurringTransactionsImported: null == recurringTransactionsImported
            ? _value.recurringTransactionsImported
            : recurringTransactionsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        budgetsImported: null == budgetsImported
            ? _value.budgetsImported
            : budgetsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        budgetCategoriesImported: null == budgetCategoriesImported
            ? _value.budgetCategoriesImported
            : budgetCategoriesImported // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsImported: null == goalsImported
            ? _value.goalsImported
            : goalsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        savingsImported: null == savingsImported
            ? _value.savingsImported
            : savingsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        savingsTransactionsImported: null == savingsTransactionsImported
            ? _value.savingsTransactionsImported
            : savingsTransactionsImported // ignore: cast_nullable_to_non_nullable
                  as int,
        settingsImported: null == settingsImported
            ? _value.settingsImported
            : settingsImported // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportStatsImpl extends _ImportStats {
  const _$ImportStatsImpl({
    required this.usersImported,
    required this.accountsImported,
    required this.categoriesImported,
    required this.transactionsImported,
    required this.recurringTransactionsImported,
    required this.budgetsImported,
    required this.budgetCategoriesImported,
    required this.goalsImported,
    required this.savingsImported,
    required this.savingsTransactionsImported,
    required this.settingsImported,
  }) : super._();

  factory _$ImportStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportStatsImplFromJson(json);

  @override
  final int usersImported;
  @override
  final int accountsImported;
  @override
  final int categoriesImported;
  @override
  final int transactionsImported;
  @override
  final int recurringTransactionsImported;
  @override
  final int budgetsImported;
  @override
  final int budgetCategoriesImported;
  @override
  final int goalsImported;
  @override
  final int savingsImported;
  @override
  final int savingsTransactionsImported;
  @override
  final bool settingsImported;

  @override
  String toString() {
    return 'ImportStats(usersImported: $usersImported, accountsImported: $accountsImported, categoriesImported: $categoriesImported, transactionsImported: $transactionsImported, recurringTransactionsImported: $recurringTransactionsImported, budgetsImported: $budgetsImported, budgetCategoriesImported: $budgetCategoriesImported, goalsImported: $goalsImported, savingsImported: $savingsImported, savingsTransactionsImported: $savingsTransactionsImported, settingsImported: $settingsImported)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportStatsImpl &&
            (identical(other.usersImported, usersImported) ||
                other.usersImported == usersImported) &&
            (identical(other.accountsImported, accountsImported) ||
                other.accountsImported == accountsImported) &&
            (identical(other.categoriesImported, categoriesImported) ||
                other.categoriesImported == categoriesImported) &&
            (identical(other.transactionsImported, transactionsImported) ||
                other.transactionsImported == transactionsImported) &&
            (identical(
                  other.recurringTransactionsImported,
                  recurringTransactionsImported,
                ) ||
                other.recurringTransactionsImported ==
                    recurringTransactionsImported) &&
            (identical(other.budgetsImported, budgetsImported) ||
                other.budgetsImported == budgetsImported) &&
            (identical(
                  other.budgetCategoriesImported,
                  budgetCategoriesImported,
                ) ||
                other.budgetCategoriesImported == budgetCategoriesImported) &&
            (identical(other.goalsImported, goalsImported) ||
                other.goalsImported == goalsImported) &&
            (identical(other.savingsImported, savingsImported) ||
                other.savingsImported == savingsImported) &&
            (identical(
                  other.savingsTransactionsImported,
                  savingsTransactionsImported,
                ) ||
                other.savingsTransactionsImported ==
                    savingsTransactionsImported) &&
            (identical(other.settingsImported, settingsImported) ||
                other.settingsImported == settingsImported));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    usersImported,
    accountsImported,
    categoriesImported,
    transactionsImported,
    recurringTransactionsImported,
    budgetsImported,
    budgetCategoriesImported,
    goalsImported,
    savingsImported,
    savingsTransactionsImported,
    settingsImported,
  );

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportStatsImplCopyWith<_$ImportStatsImpl> get copyWith =>
      __$$ImportStatsImplCopyWithImpl<_$ImportStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportStatsImplToJson(this);
  }
}

abstract class _ImportStats extends ImportStats {
  const factory _ImportStats({
    required final int usersImported,
    required final int accountsImported,
    required final int categoriesImported,
    required final int transactionsImported,
    required final int recurringTransactionsImported,
    required final int budgetsImported,
    required final int budgetCategoriesImported,
    required final int goalsImported,
    required final int savingsImported,
    required final int savingsTransactionsImported,
    required final bool settingsImported,
  }) = _$ImportStatsImpl;
  const _ImportStats._() : super._();

  factory _ImportStats.fromJson(Map<String, dynamic> json) =
      _$ImportStatsImpl.fromJson;

  @override
  int get usersImported;
  @override
  int get accountsImported;
  @override
  int get categoriesImported;
  @override
  int get transactionsImported;
  @override
  int get recurringTransactionsImported;
  @override
  int get budgetsImported;
  @override
  int get budgetCategoriesImported;
  @override
  int get goalsImported;
  @override
  int get savingsImported;
  @override
  int get savingsTransactionsImported;
  @override
  bool get settingsImported;

  /// Create a copy of ImportStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportStatsImplCopyWith<_$ImportStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
