// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _biometricEnabledMeta = const VerificationMeta(
    'biometricEnabled',
  );
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
    'biometric_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uid,
    email,
    displayName,
    phoneNumber,
    photoUrl,
    currency,
    language,
    biometricEnabled,
    notificationsEnabled,
    timezone,
    createdAt,
    updatedAt,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
        _biometricEnabledMeta,
        biometricEnabled.isAcceptableOrUnknown(
          data['biometric_enabled']!,
          _biometricEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      biometricEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_enabled'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  /// Primary key
  final int id;

  /// User's unique identifier (from auth provider)
  final String uid;

  /// User's email address
  final String email;

  /// User's display name
  final String? displayName;

  /// User's phone number
  final String? phoneNumber;

  /// User's profile photo URL
  final String? photoUrl;

  /// User's preferred currency
  final String currency;

  /// User's preferred language
  final String language;

  /// Whether biometric authentication is enabled
  final bool biometricEnabled;

  /// Whether notifications are enabled
  final bool notificationsEnabled;

  /// User's timezone
  final String? timezone;

  /// When the user was created
  final DateTime createdAt;

  /// When the user was last updated
  final DateTime updatedAt;

  /// When the user last synced
  final DateTime? lastSyncedAt;
  const UserEntity({
    required this.id,
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    required this.currency,
    required this.language,
    required this.biometricEnabled,
    required this.notificationsEnabled,
    this.timezone,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['currency'] = Variable<String>(currency);
    map['language'] = Variable<String>(language);
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    if (!nullToAbsent || timezone != null) {
      map['timezone'] = Variable<String>(timezone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      uid: Value(uid),
      email: Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      currency: Value(currency),
      language: Value(language),
      biometricEnabled: Value(biometricEnabled),
      notificationsEnabled: Value(notificationsEnabled),
      timezone: timezone == null && nullToAbsent
          ? const Value.absent()
          : Value(timezone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory UserEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      currency: serializer.fromJson<String>(json['currency']),
      language: serializer.fromJson<String>(json['language']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      timezone: serializer.fromJson<String?>(json['timezone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'currency': serializer.toJson<String>(currency),
      'language': serializer.toJson<String>(language),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'timezone': serializer.toJson<String?>(timezone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  UserEntity copyWith({
    int? id,
    String? uid,
    String? email,
    Value<String?> displayName = const Value.absent(),
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    String? currency,
    String? language,
    bool? biometricEnabled,
    bool? notificationsEnabled,
    Value<String?> timezone = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => UserEntity(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    email: email ?? this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    currency: currency ?? this.currency,
    language: language ?? this.language,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    timezone: timezone.present ? timezone.value : this.timezone,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      currency: data.currency.present ? data.currency.value : this.currency,
      language: data.language.present ? data.language.value : this.language,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('currency: $currency, ')
          ..write('language: $language, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uid,
    email,
    displayName,
    phoneNumber,
    photoUrl,
    currency,
    language,
    biometricEnabled,
    notificationsEnabled,
    timezone,
    createdAt,
    updatedAt,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.phoneNumber == this.phoneNumber &&
          other.photoUrl == this.photoUrl &&
          other.currency == this.currency &&
          other.language == this.language &&
          other.biometricEnabled == this.biometricEnabled &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.timezone == this.timezone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> email;
  final Value<String?> displayName;
  final Value<String?> phoneNumber;
  final Value<String?> photoUrl;
  final Value<String> currency;
  final Value<String> language;
  final Value<bool> biometricEnabled;
  final Value<bool> notificationsEnabled;
  final Value<String?> timezone;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.currency = const Value.absent(),
    this.language = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.timezone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String email,
    this.displayName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.currency = const Value.absent(),
    this.language = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.timezone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : uid = Value(uid),
       email = Value(email);
  static Insertable<UserEntity> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? phoneNumber,
    Expression<String>? photoUrl,
    Expression<String>? currency,
    Expression<String>? language,
    Expression<bool>? biometricEnabled,
    Expression<bool>? notificationsEnabled,
    Expression<String>? timezone,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (currency != null) 'currency': currency,
      if (language != null) 'language': language,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (timezone != null) 'timezone': timezone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? uid,
    Value<String>? email,
    Value<String?>? displayName,
    Value<String?>? phoneNumber,
    Value<String?>? photoUrl,
    Value<String>? currency,
    Value<String>? language,
    Value<bool>? biometricEnabled,
    Value<bool>? notificationsEnabled,
    Value<String?>? timezone,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('currency: $currency, ')
          ..write('language: $language, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('timezone: $timezone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _balanceInCentsMeta = const VerificationMeta(
    'balanceInCents',
  );
  @override
  late final GeneratedColumn<int> balanceInCents = GeneratedColumn<int>(
    'balance_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _includeInTotalMeta = const VerificationMeta(
    'includeInTotal',
  );
  @override
  late final GeneratedColumn<bool> includeInTotal = GeneratedColumn<bool>(
    'include_in_total',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("include_in_total" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    type,
    balanceInCents,
    currency,
    color,
    icon,
    accountNumber,
    bankName,
    isDefault,
    isActive,
    includeInTotal,
    notes,
    createdAt,
    updatedAt,
    displayOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance_in_cents')) {
      context.handle(
        _balanceInCentsMeta,
        balanceInCents.isAcceptableOrUnknown(
          data['balance_in_cents']!,
          _balanceInCentsMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('include_in_total')) {
      context.handle(
        _includeInTotalMeta,
        includeInTotal.isAcceptableOrUnknown(
          data['include_in_total']!,
          _includeInTotalMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      balanceInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      ),
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      includeInTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_in_total'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, int, int> $convertertype =
      const EnumIndexConverter<AccountType>(AccountType.values);
}

class AccountEntity extends DataClass implements Insertable<AccountEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Account name
  final String name;

  /// Account type
  final AccountType type;

  /// Account balance in cents (to avoid floating point issues)
  final int balanceInCents;

  /// Currency code (ISO 4217)
  final String currency;

  /// Account color (hex code)
  final String? color;

  /// Account icon name
  final String? icon;

  /// Account number (masked)
  final String? accountNumber;

  /// Bank name
  final String? bankName;

  /// Whether this is the default account
  final bool isDefault;

  /// Whether this account is active
  final bool isActive;

  /// Whether to include in total balance
  final bool includeInTotal;

  /// Notes about the account
  final String? notes;

  /// When the account was created
  final DateTime createdAt;

  /// When the account was last updated
  final DateTime updatedAt;

  /// Display order
  final int displayOrder;
  const AccountEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balanceInCents,
    required this.currency,
    this.color,
    this.icon,
    this.accountNumber,
    this.bankName,
    required this.isDefault,
    required this.isActive,
    required this.includeInTotal,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.displayOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($AccountsTable.$convertertype.toSql(type));
    }
    map['balance_in_cents'] = Variable<int>(balanceInCents);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['is_active'] = Variable<bool>(isActive);
    map['include_in_total'] = Variable<bool>(includeInTotal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      type: Value(type),
      balanceInCents: Value(balanceInCents),
      currency: Value(currency),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      isDefault: Value(isDefault),
      isActive: Value(isActive),
      includeInTotal: Value(includeInTotal),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      displayOrder: Value(displayOrder),
    );
  }

  factory AccountEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      balanceInCents: serializer.fromJson<int>(json['balanceInCents']),
      currency: serializer.fromJson<String>(json['currency']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      includeInTotal: serializer.fromJson<bool>(json['includeInTotal']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $AccountsTable.$convertertype.toJson(type),
      ),
      'balanceInCents': serializer.toJson<int>(balanceInCents),
      'currency': serializer.toJson<String>(currency),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'bankName': serializer.toJson<String?>(bankName),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isActive': serializer.toJson<bool>(isActive),
      'includeInTotal': serializer.toJson<bool>(includeInTotal),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  AccountEntity copyWith({
    int? id,
    int? userId,
    String? name,
    AccountType? type,
    int? balanceInCents,
    String? currency,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
    Value<String?> bankName = const Value.absent(),
    bool? isDefault,
    bool? isActive,
    bool? includeInTotal,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? displayOrder,
  }) => AccountEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    type: type ?? this.type,
    balanceInCents: balanceInCents ?? this.balanceInCents,
    currency: currency ?? this.currency,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    accountNumber: accountNumber.present
        ? accountNumber.value
        : this.accountNumber,
    bankName: bankName.present ? bankName.value : this.bankName,
    isDefault: isDefault ?? this.isDefault,
    isActive: isActive ?? this.isActive,
    includeInTotal: includeInTotal ?? this.includeInTotal,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    displayOrder: displayOrder ?? this.displayOrder,
  );
  AccountEntity copyWithCompanion(AccountsCompanion data) {
    return AccountEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      balanceInCents: data.balanceInCents.present
          ? data.balanceInCents.value
          : this.balanceInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      includeInTotal: data.includeInTotal.present
          ? data.includeInTotal.value
          : this.includeInTotal,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balanceInCents: $balanceInCents, ')
          ..write('currency: $currency, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('includeInTotal: $includeInTotal, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    type,
    balanceInCents,
    currency,
    color,
    icon,
    accountNumber,
    bankName,
    isDefault,
    isActive,
    includeInTotal,
    notes,
    createdAt,
    updatedAt,
    displayOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.type == this.type &&
          other.balanceInCents == this.balanceInCents &&
          other.currency == this.currency &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.accountNumber == this.accountNumber &&
          other.bankName == this.bankName &&
          other.isDefault == this.isDefault &&
          other.isActive == this.isActive &&
          other.includeInTotal == this.includeInTotal &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.displayOrder == this.displayOrder);
}

class AccountsCompanion extends UpdateCompanion<AccountEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<int> balanceInCents;
  final Value<String> currency;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<String?> accountNumber;
  final Value<String?> bankName;
  final Value<bool> isDefault;
  final Value<bool> isActive;
  final Value<bool> includeInTotal;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> displayOrder;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.balanceInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.includeInTotal = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    required AccountType type,
    this.balanceInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.bankName = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.includeInTotal = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.displayOrder = const Value.absent(),
  }) : userId = Value(userId),
       name = Value(name),
       type = Value(type);
  static Insertable<AccountEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? balanceInCents,
    Expression<String>? currency,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<String>? accountNumber,
    Expression<String>? bankName,
    Expression<bool>? isDefault,
    Expression<bool>? isActive,
    Expression<bool>? includeInTotal,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (balanceInCents != null) 'balance_in_cents': balanceInCents,
      if (currency != null) 'currency': currency,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (accountNumber != null) 'account_number': accountNumber,
      if (bankName != null) 'bank_name': bankName,
      if (isDefault != null) 'is_default': isDefault,
      if (isActive != null) 'is_active': isActive,
      if (includeInTotal != null) 'include_in_total': includeInTotal,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? name,
    Value<AccountType>? type,
    Value<int>? balanceInCents,
    Value<String>? currency,
    Value<String?>? color,
    Value<String?>? icon,
    Value<String?>? accountNumber,
    Value<String?>? bankName,
    Value<bool>? isDefault,
    Value<bool>? isActive,
    Value<bool>? includeInTotal,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? displayOrder,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balanceInCents: balanceInCents ?? this.balanceInCents,
      currency: currency ?? this.currency,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      includeInTotal: includeInTotal ?? this.includeInTotal,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $AccountsTable.$convertertype.toSql(type.value),
      );
    }
    if (balanceInCents.present) {
      map['balance_in_cents'] = Variable<int>(balanceInCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (includeInTotal.present) {
      map['include_in_total'] = Variable<bool>(includeInTotal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balanceInCents: $balanceInCents, ')
          ..write('currency: $currency, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('bankName: $bankName, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('includeInTotal: $includeInTotal, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CategoryType>($CategoriesTable.$convertertype);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetLimitInCentsMeta =
      const VerificationMeta('budgetLimitInCents');
  @override
  late final GeneratedColumn<int> budgetLimitInCents = GeneratedColumn<int>(
    'budget_limit_in_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    type,
    parentId,
    color,
    icon,
    budgetLimitInCents,
    isSystem,
    isActive,
    displayOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('budget_limit_in_cents')) {
      context.handle(
        _budgetLimitInCentsMeta,
        budgetLimitInCents.isAcceptableOrUnknown(
          data['budget_limit_in_cents']!,
          _budgetLimitInCentsMeta,
        ),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $CategoriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      budgetLimitInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_limit_in_cents'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryType, int, int> $convertertype =
      const EnumIndexConverter<CategoryType>(CategoryType.values);
}

class CategoryEntity extends DataClass implements Insertable<CategoryEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Category name
  final String name;

  /// Category type (income or expense)
  final CategoryType type;

  /// Parent category ID (for subcategories)
  final int? parentId;

  /// Category color (hex code)
  final String? color;

  /// Category icon name
  final String? icon;

  /// Monthly budget limit in cents
  final int? budgetLimitInCents;

  /// Whether this is a system category (cannot be deleted)
  final bool isSystem;

  /// Whether this category is active
  final bool isActive;

  /// Display order
  final int displayOrder;

  /// When the category was created
  final DateTime createdAt;

  /// When the category was last updated
  final DateTime updatedAt;
  const CategoryEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.parentId,
    this.color,
    this.icon,
    this.budgetLimitInCents,
    required this.isSystem,
    required this.isActive,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($CategoriesTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || budgetLimitInCents != null) {
      map['budget_limit_in_cents'] = Variable<int>(budgetLimitInCents);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['is_active'] = Variable<bool>(isActive);
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      type: Value(type),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      budgetLimitInCents: budgetLimitInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetLimitInCents),
      isSystem: Value(isSystem),
      isActive: Value(isActive),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      type: $CategoriesTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      parentId: serializer.fromJson<int?>(json['parentId']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      budgetLimitInCents: serializer.fromJson<int?>(json['budgetLimitInCents']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(
        $CategoriesTable.$convertertype.toJson(type),
      ),
      'parentId': serializer.toJson<int?>(parentId),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'budgetLimitInCents': serializer.toJson<int?>(budgetLimitInCents),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isActive': serializer.toJson<bool>(isActive),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryEntity copyWith({
    int? id,
    int? userId,
    String? name,
    CategoryType? type,
    Value<int?> parentId = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<int?> budgetLimitInCents = const Value.absent(),
    bool? isSystem,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoryEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    type: type ?? this.type,
    parentId: parentId.present ? parentId.value : this.parentId,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    budgetLimitInCents: budgetLimitInCents.present
        ? budgetLimitInCents.value
        : this.budgetLimitInCents,
    isSystem: isSystem ?? this.isSystem,
    isActive: isActive ?? this.isActive,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryEntity copyWithCompanion(CategoriesCompanion data) {
    return CategoryEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      budgetLimitInCents: data.budgetLimitInCents.present
          ? data.budgetLimitInCents.value
          : this.budgetLimitInCents,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('budgetLimitInCents: $budgetLimitInCents, ')
          ..write('isSystem: $isSystem, ')
          ..write('isActive: $isActive, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    type,
    parentId,
    color,
    icon,
    budgetLimitInCents,
    isSystem,
    isActive,
    displayOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.type == this.type &&
          other.parentId == this.parentId &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.budgetLimitInCents == this.budgetLimitInCents &&
          other.isSystem == this.isSystem &&
          other.isActive == this.isActive &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<CategoryType> type;
  final Value<int?> parentId;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<int?> budgetLimitInCents;
  final Value<bool> isSystem;
  final Value<bool> isActive;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.budgetLimitInCents = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isActive = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    required CategoryType type,
    this.parentId = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.budgetLimitInCents = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isActive = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       name = Value(name),
       type = Value(type);
  static Insertable<CategoryEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? parentId,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? budgetLimitInCents,
    Expression<bool>? isSystem,
    Expression<bool>? isActive,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (parentId != null) 'parent_id': parentId,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (budgetLimitInCents != null)
        'budget_limit_in_cents': budgetLimitInCents,
      if (isSystem != null) 'is_system': isSystem,
      if (isActive != null) 'is_active': isActive,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? name,
    Value<CategoryType>? type,
    Value<int?>? parentId,
    Value<String?>? color,
    Value<String?>? icon,
    Value<int?>? budgetLimitInCents,
    Value<bool>? isSystem,
    Value<bool>? isActive,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      budgetLimitInCents: budgetLimitInCents ?? this.budgetLimitInCents,
      isSystem: isSystem ?? this.isSystem,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $CategoriesTable.$convertertype.toSql(type.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (budgetLimitInCents.present) {
      map['budget_limit_in_cents'] = Variable<int>(budgetLimitInCents.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('budgetLimitInCents: $budgetLimitInCents, ')
          ..write('isSystem: $isSystem, ')
          ..write('isActive: $isActive, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TransactionType>($TransactionsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      ).withConverter<TransactionStatus>($TransactionsTable.$converterstatus);
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentUrlMeta = const VerificationMeta(
    'attachmentUrl',
  );
  @override
  late final GeneratedColumn<String> attachmentUrl = GeneratedColumn<String>(
    'attachment_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurringTransactionIdMeta =
      const VerificationMeta('recurringTransactionId');
  @override
  late final GeneratedColumn<int> recurringTransactionId = GeneratedColumn<int>(
    'recurring_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    accountId,
    categoryId,
    type,
    status,
    amountInCents,
    currency,
    description,
    notes,
    transactionDate,
    payee,
    location,
    tags,
    attachmentUrl,
    toAccountId,
    isRecurring,
    recurringTransactionId,
    externalId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('attachment_url')) {
      context.handle(
        _attachmentUrlMeta,
        attachmentUrl.isAcceptableOrUnknown(
          data['attachment_url']!,
          _attachmentUrlMeta,
        ),
      );
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('recurring_transaction_id')) {
      context.handle(
        _recurringTransactionIdMeta,
        recurringTransactionId.isAcceptableOrUnknown(
          data['recurring_transaction_id']!,
          _recurringTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $TransactionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      attachmentUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_url'],
      ),
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_account_id'],
      ),
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      recurringTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurring_transaction_id'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, int, int> $convertertype =
      const EnumIndexConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionStatus, int, int> $converterstatus =
      const EnumIndexConverter<TransactionStatus>(TransactionStatus.values);
}

class TransactionEntity extends DataClass
    implements Insertable<TransactionEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Account ID (foreign key)
  final int accountId;

  /// Category ID (foreign key)
  final int? categoryId;

  /// Transaction type
  final TransactionType type;

  /// Transaction status
  final TransactionStatus status;

  /// Amount in cents
  final int amountInCents;

  /// Currency code
  final String currency;

  /// Transaction description
  final String description;

  /// Additional notes
  final String? notes;

  /// Transaction date
  final DateTime transactionDate;

  /// Payee/Payer name
  final String? payee;

  /// Location where transaction occurred
  final String? location;

  /// Tags (comma-separated)
  final String? tags;

  /// Receipt/attachment URL
  final String? attachmentUrl;

  /// For transfers: destination account ID
  final int? toAccountId;

  /// Whether this is a recurring transaction
  final bool isRecurring;

  /// Recurring transaction ID (if this is part of a recurring series)
  final int? recurringTransactionId;

  /// External transaction ID (from bank sync)
  final String? externalId;

  /// When the transaction was created
  final DateTime createdAt;

  /// When the transaction was last updated
  final DateTime updatedAt;
  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.accountId,
    this.categoryId,
    required this.type,
    required this.status,
    required this.amountInCents,
    required this.currency,
    required this.description,
    this.notes,
    required this.transactionDate,
    this.payee,
    this.location,
    this.tags,
    this.attachmentUrl,
    this.toAccountId,
    required this.isRecurring,
    this.recurringTransactionId,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    {
      map['type'] = Variable<int>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<int>(
        $TransactionsTable.$converterstatus.toSql(status),
      );
    }
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['currency'] = Variable<String>(currency);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || attachmentUrl != null) {
      map['attachment_url'] = Variable<String>(attachmentUrl);
    }
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<int>(toAccountId);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringTransactionId != null) {
      map['recurring_transaction_id'] = Variable<int>(recurringTransactionId);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      type: Value(type),
      status: Value(status),
      amountInCents: Value(amountInCents),
      currency: Value(currency),
      description: Value(description),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      transactionDate: Value(transactionDate),
      payee: payee == null && nullToAbsent
          ? const Value.absent()
          : Value(payee),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      attachmentUrl: attachmentUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentUrl),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      isRecurring: Value(isRecurring),
      recurringTransactionId: recurringTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringTransactionId),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      status: $TransactionsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      currency: serializer.fromJson<String>(json['currency']),
      description: serializer.fromJson<String>(json['description']),
      notes: serializer.fromJson<String?>(json['notes']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      payee: serializer.fromJson<String?>(json['payee']),
      location: serializer.fromJson<String?>(json['location']),
      tags: serializer.fromJson<String?>(json['tags']),
      attachmentUrl: serializer.fromJson<String?>(json['attachmentUrl']),
      toAccountId: serializer.fromJson<int?>(json['toAccountId']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringTransactionId: serializer.fromJson<int?>(
        json['recurringTransactionId'],
      ),
      externalId: serializer.fromJson<String?>(json['externalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'type': serializer.toJson<int>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<int>(
        $TransactionsTable.$converterstatus.toJson(status),
      ),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'currency': serializer.toJson<String>(currency),
      'description': serializer.toJson<String>(description),
      'notes': serializer.toJson<String?>(notes),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'payee': serializer.toJson<String?>(payee),
      'location': serializer.toJson<String?>(location),
      'tags': serializer.toJson<String?>(tags),
      'attachmentUrl': serializer.toJson<String?>(attachmentUrl),
      'toAccountId': serializer.toJson<int?>(toAccountId),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringTransactionId': serializer.toJson<int?>(recurringTransactionId),
      'externalId': serializer.toJson<String?>(externalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionEntity copyWith({
    int? id,
    int? userId,
    int? accountId,
    Value<int?> categoryId = const Value.absent(),
    TransactionType? type,
    TransactionStatus? status,
    int? amountInCents,
    String? currency,
    String? description,
    Value<String?> notes = const Value.absent(),
    DateTime? transactionDate,
    Value<String?> payee = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> attachmentUrl = const Value.absent(),
    Value<int?> toAccountId = const Value.absent(),
    bool? isRecurring,
    Value<int?> recurringTransactionId = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransactionEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    type: type ?? this.type,
    status: status ?? this.status,
    amountInCents: amountInCents ?? this.amountInCents,
    currency: currency ?? this.currency,
    description: description ?? this.description,
    notes: notes.present ? notes.value : this.notes,
    transactionDate: transactionDate ?? this.transactionDate,
    payee: payee.present ? payee.value : this.payee,
    location: location.present ? location.value : this.location,
    tags: tags.present ? tags.value : this.tags,
    attachmentUrl: attachmentUrl.present
        ? attachmentUrl.value
        : this.attachmentUrl,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    isRecurring: isRecurring ?? this.isRecurring,
    recurringTransactionId: recurringTransactionId.present
        ? recurringTransactionId.value
        : this.recurringTransactionId,
    externalId: externalId.present ? externalId.value : this.externalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionEntity copyWithCompanion(TransactionsCompanion data) {
    return TransactionEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      description: data.description.present
          ? data.description.value
          : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      payee: data.payee.present ? data.payee.value : this.payee,
      location: data.location.present ? data.location.value : this.location,
      tags: data.tags.present ? data.tags.value : this.tags,
      attachmentUrl: data.attachmentUrl.present
          ? data.attachmentUrl.value
          : this.attachmentUrl,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      recurringTransactionId: data.recurringTransactionId.present
          ? data.recurringTransactionId.value
          : this.recurringTransactionId,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('payee: $payee, ')
          ..write('location: $location, ')
          ..write('tags: $tags, ')
          ..write('attachmentUrl: $attachmentUrl, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringTransactionId: $recurringTransactionId, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    accountId,
    categoryId,
    type,
    status,
    amountInCents,
    currency,
    description,
    notes,
    transactionDate,
    payee,
    location,
    tags,
    attachmentUrl,
    toAccountId,
    isRecurring,
    recurringTransactionId,
    externalId,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.type == this.type &&
          other.status == this.status &&
          other.amountInCents == this.amountInCents &&
          other.currency == this.currency &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.transactionDate == this.transactionDate &&
          other.payee == this.payee &&
          other.location == this.location &&
          other.tags == this.tags &&
          other.attachmentUrl == this.attachmentUrl &&
          other.toAccountId == this.toAccountId &&
          other.isRecurring == this.isRecurring &&
          other.recurringTransactionId == this.recurringTransactionId &&
          other.externalId == this.externalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<TransactionType> type;
  final Value<TransactionStatus> status;
  final Value<int> amountInCents;
  final Value<String> currency;
  final Value<String> description;
  final Value<String?> notes;
  final Value<DateTime> transactionDate;
  final Value<String?> payee;
  final Value<String?> location;
  final Value<String?> tags;
  final Value<String?> attachmentUrl;
  final Value<int?> toAccountId;
  final Value<bool> isRecurring;
  final Value<int?> recurringTransactionId;
  final Value<String?> externalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.payee = const Value.absent(),
    this.location = const Value.absent(),
    this.tags = const Value.absent(),
    this.attachmentUrl = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringTransactionId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int accountId,
    this.categoryId = const Value.absent(),
    required TransactionType type,
    this.status = const Value.absent(),
    required int amountInCents,
    this.currency = const Value.absent(),
    required String description,
    this.notes = const Value.absent(),
    required DateTime transactionDate,
    this.payee = const Value.absent(),
    this.location = const Value.absent(),
    this.tags = const Value.absent(),
    this.attachmentUrl = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringTransactionId = const Value.absent(),
    this.externalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       accountId = Value(accountId),
       type = Value(type),
       amountInCents = Value(amountInCents),
       description = Value(description),
       transactionDate = Value(transactionDate);
  static Insertable<TransactionEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? type,
    Expression<int>? status,
    Expression<int>? amountInCents,
    Expression<String>? currency,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<DateTime>? transactionDate,
    Expression<String>? payee,
    Expression<String>? location,
    Expression<String>? tags,
    Expression<String>? attachmentUrl,
    Expression<int>? toAccountId,
    Expression<bool>? isRecurring,
    Expression<int>? recurringTransactionId,
    Expression<String>? externalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (currency != null) 'currency': currency,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (payee != null) 'payee': payee,
      if (location != null) 'location': location,
      if (tags != null) 'tags': tags,
      if (attachmentUrl != null) 'attachment_url': attachmentUrl,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringTransactionId != null)
        'recurring_transaction_id': recurringTransactionId,
      if (externalId != null) 'external_id': externalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? accountId,
    Value<int?>? categoryId,
    Value<TransactionType>? type,
    Value<TransactionStatus>? status,
    Value<int>? amountInCents,
    Value<String>? currency,
    Value<String>? description,
    Value<String?>? notes,
    Value<DateTime>? transactionDate,
    Value<String?>? payee,
    Value<String?>? location,
    Value<String?>? tags,
    Value<String?>? attachmentUrl,
    Value<int?>? toAccountId,
    Value<bool>? isRecurring,
    Value<int?>? recurringTransactionId,
    Value<String?>? externalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      status: status ?? this.status,
      amountInCents: amountInCents ?? this.amountInCents,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      transactionDate: transactionDate ?? this.transactionDate,
      payee: payee ?? this.payee,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      toAccountId: toAccountId ?? this.toAccountId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringTransactionId:
          recurringTransactionId ?? this.recurringTransactionId,
      externalId: externalId ?? this.externalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $TransactionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (attachmentUrl.present) {
      map['attachment_url'] = Variable<String>(attachmentUrl.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringTransactionId.present) {
      map['recurring_transaction_id'] = Variable<int>(
        recurringTransactionId.value,
      );
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('payee: $payee, ')
          ..write('location: $location, ')
          ..write('tags: $tags, ')
          ..write('attachmentUrl: $attachmentUrl, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringTransactionId: $recurringTransactionId, ')
          ..write('externalId: $externalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets
    with TableInfo<$BudgetsTable, BudgetEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BudgetPeriod, int> period =
      GeneratedColumn<int>(
        'period',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<BudgetPeriod>($BudgetsTable.$converterperiod);
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolloverMeta = const VerificationMeta(
    'rollover',
  );
  @override
  late final GeneratedColumn<bool> rollover = GeneratedColumn<bool>(
    'rollover',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rollover" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alertThresholdMeta = const VerificationMeta(
    'alertThreshold',
  );
  @override
  late final GeneratedColumn<int> alertThreshold = GeneratedColumn<int>(
    'alert_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(80),
  );
  static const VerificationMeta _alertsEnabledMeta = const VerificationMeta(
    'alertsEnabled',
  );
  @override
  late final GeneratedColumn<bool> alertsEnabled = GeneratedColumn<bool>(
    'alerts_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alerts_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    amountInCents,
    currency,
    period,
    startDate,
    endDate,
    rollover,
    alertThreshold,
    alertsEnabled,
    isActive,
    color,
    icon,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('rollover')) {
      context.handle(
        _rolloverMeta,
        rollover.isAcceptableOrUnknown(data['rollover']!, _rolloverMeta),
      );
    }
    if (data.containsKey('alert_threshold')) {
      context.handle(
        _alertThresholdMeta,
        alertThreshold.isAcceptableOrUnknown(
          data['alert_threshold']!,
          _alertThresholdMeta,
        ),
      );
    }
    if (data.containsKey('alerts_enabled')) {
      context.handle(
        _alertsEnabledMeta,
        alertsEnabled.isAcceptableOrUnknown(
          data['alerts_enabled']!,
          _alertsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      period: $BudgetsTable.$converterperiod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}period'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      rollover: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rollover'],
      )!,
      alertThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alert_threshold'],
      )!,
      alertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alerts_enabled'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BudgetPeriod, int, int> $converterperiod =
      const EnumIndexConverter<BudgetPeriod>(BudgetPeriod.values);
}

class BudgetEntity extends DataClass implements Insertable<BudgetEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Budget name
  final String name;

  /// Budget amount in cents
  final int amountInCents;

  /// Currency code
  final String currency;

  /// Budget period
  final BudgetPeriod period;

  /// Period start date
  final DateTime startDate;

  /// Period end date
  final DateTime endDate;

  /// Whether to rollover unused budget
  final bool rollover;

  /// Alert threshold percentage (0-100)
  final int alertThreshold;

  /// Whether alerts are enabled
  final bool alertsEnabled;

  /// Whether this budget is active
  final bool isActive;

  /// Budget color (hex code)
  final String? color;

  /// Budget icon name
  final String? icon;

  /// Notes about the budget
  final String? notes;

  /// When the budget was created
  final DateTime createdAt;

  /// When the budget was last updated
  final DateTime updatedAt;
  const BudgetEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.amountInCents,
    required this.currency,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.rollover,
    required this.alertThreshold,
    required this.alertsEnabled,
    required this.isActive,
    this.color,
    this.icon,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['currency'] = Variable<String>(currency);
    {
      map['period'] = Variable<int>(
        $BudgetsTable.$converterperiod.toSql(period),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['rollover'] = Variable<bool>(rollover);
    map['alert_threshold'] = Variable<int>(alertThreshold);
    map['alerts_enabled'] = Variable<bool>(alertsEnabled);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      amountInCents: Value(amountInCents),
      currency: Value(currency),
      period: Value(period),
      startDate: Value(startDate),
      endDate: Value(endDate),
      rollover: Value(rollover),
      alertThreshold: Value(alertThreshold),
      alertsEnabled: Value(alertsEnabled),
      isActive: Value(isActive),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      currency: serializer.fromJson<String>(json['currency']),
      period: $BudgetsTable.$converterperiod.fromJson(
        serializer.fromJson<int>(json['period']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      rollover: serializer.fromJson<bool>(json['rollover']),
      alertThreshold: serializer.fromJson<int>(json['alertThreshold']),
      alertsEnabled: serializer.fromJson<bool>(json['alertsEnabled']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'currency': serializer.toJson<String>(currency),
      'period': serializer.toJson<int>(
        $BudgetsTable.$converterperiod.toJson(period),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'rollover': serializer.toJson<bool>(rollover),
      'alertThreshold': serializer.toJson<int>(alertThreshold),
      'alertsEnabled': serializer.toJson<bool>(alertsEnabled),
      'isActive': serializer.toJson<bool>(isActive),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetEntity copyWith({
    int? id,
    int? userId,
    String? name,
    int? amountInCents,
    String? currency,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? rollover,
    int? alertThreshold,
    bool? alertsEnabled,
    bool? isActive,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    amountInCents: amountInCents ?? this.amountInCents,
    currency: currency ?? this.currency,
    period: period ?? this.period,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    rollover: rollover ?? this.rollover,
    alertThreshold: alertThreshold ?? this.alertThreshold,
    alertsEnabled: alertsEnabled ?? this.alertsEnabled,
    isActive: isActive ?? this.isActive,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetEntity copyWithCompanion(BudgetsCompanion data) {
    return BudgetEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      period: data.period.present ? data.period.value : this.period,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      rollover: data.rollover.present ? data.rollover.value : this.rollover,
      alertThreshold: data.alertThreshold.present
          ? data.alertThreshold.value
          : this.alertThreshold,
      alertsEnabled: data.alertsEnabled.present
          ? data.alertsEnabled.value
          : this.alertsEnabled,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rollover: $rollover, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('alertsEnabled: $alertsEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    amountInCents,
    currency,
    period,
    startDate,
    endDate,
    rollover,
    alertThreshold,
    alertsEnabled,
    isActive,
    color,
    icon,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.amountInCents == this.amountInCents &&
          other.currency == this.currency &&
          other.period == this.period &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.rollover == this.rollover &&
          other.alertThreshold == this.alertThreshold &&
          other.alertsEnabled == this.alertsEnabled &&
          other.isActive == this.isActive &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<BudgetEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<int> amountInCents;
  final Value<String> currency;
  final Value<BudgetPeriod> period;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<bool> rollover;
  final Value<int> alertThreshold;
  final Value<bool> alertsEnabled;
  final Value<bool> isActive;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rollover = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    this.alertsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    required int amountInCents,
    this.currency = const Value.absent(),
    required BudgetPeriod period,
    required DateTime startDate,
    required DateTime endDate,
    this.rollover = const Value.absent(),
    this.alertThreshold = const Value.absent(),
    this.alertsEnabled = const Value.absent(),
    this.isActive = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       name = Value(name),
       amountInCents = Value(amountInCents),
       period = Value(period),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<BudgetEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<int>? amountInCents,
    Expression<String>? currency,
    Expression<int>? period,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? rollover,
    Expression<int>? alertThreshold,
    Expression<bool>? alertsEnabled,
    Expression<bool>? isActive,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (currency != null) 'currency': currency,
      if (period != null) 'period': period,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rollover != null) 'rollover': rollover,
      if (alertThreshold != null) 'alert_threshold': alertThreshold,
      if (alertsEnabled != null) 'alerts_enabled': alertsEnabled,
      if (isActive != null) 'is_active': isActive,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? name,
    Value<int>? amountInCents,
    Value<String>? currency,
    Value<BudgetPeriod>? period,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<bool>? rollover,
    Value<int>? alertThreshold,
    Value<bool>? alertsEnabled,
    Value<bool>? isActive,
    Value<String?>? color,
    Value<String?>? icon,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      amountInCents: amountInCents ?? this.amountInCents,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rollover: rollover ?? this.rollover,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (period.present) {
      map['period'] = Variable<int>(
        $BudgetsTable.$converterperiod.toSql(period.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rollover.present) {
      map['rollover'] = Variable<bool>(rollover.value);
    }
    if (alertThreshold.present) {
      map['alert_threshold'] = Variable<int>(alertThreshold.value);
    }
    if (alertsEnabled.present) {
      map['alerts_enabled'] = Variable<bool>(alertsEnabled.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rollover: $rollover, ')
          ..write('alertThreshold: $alertThreshold, ')
          ..write('alertsEnabled: $alertsEnabled, ')
          ..write('isActive: $isActive, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoriesTable extends BudgetCategories
    with TableInfo<$BudgetCategoriesTable, BudgetCategoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allocatedAmountInCentsMeta =
      const VerificationMeta('allocatedAmountInCents');
  @override
  late final GeneratedColumn<int> allocatedAmountInCents = GeneratedColumn<int>(
    'allocated_amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    categoryId,
    allocatedAmountInCents,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCategoryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('allocated_amount_in_cents')) {
      context.handle(
        _allocatedAmountInCentsMeta,
        allocatedAmountInCents.isAcceptableOrUnknown(
          data['allocated_amount_in_cents']!,
          _allocatedAmountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allocatedAmountInCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCategoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategoryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      allocatedAmountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocated_amount_in_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetCategoriesTable createAlias(String alias) {
    return $BudgetCategoriesTable(attachedDatabase, alias);
  }
}

class BudgetCategoryEntity extends DataClass
    implements Insertable<BudgetCategoryEntity> {
  /// Primary key
  final int id;

  /// Budget ID (foreign key)
  final int budgetId;

  /// Category ID (foreign key)
  final int categoryId;

  /// Allocated amount in cents for this category
  final int allocatedAmountInCents;

  /// When the allocation was created
  final DateTime createdAt;

  /// When the allocation was last updated
  final DateTime updatedAt;
  const BudgetCategoryEntity({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.allocatedAmountInCents,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<int>(budgetId);
    map['category_id'] = Variable<int>(categoryId);
    map['allocated_amount_in_cents'] = Variable<int>(allocatedAmountInCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetCategoriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoriesCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      categoryId: Value(categoryId),
      allocatedAmountInCents: Value(allocatedAmountInCents),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetCategoryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategoryEntity(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<int>(json['budgetId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      allocatedAmountInCents: serializer.fromJson<int>(
        json['allocatedAmountInCents'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<int>(budgetId),
      'categoryId': serializer.toJson<int>(categoryId),
      'allocatedAmountInCents': serializer.toJson<int>(allocatedAmountInCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetCategoryEntity copyWith({
    int? id,
    int? budgetId,
    int? categoryId,
    int? allocatedAmountInCents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetCategoryEntity(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    categoryId: categoryId ?? this.categoryId,
    allocatedAmountInCents:
        allocatedAmountInCents ?? this.allocatedAmountInCents,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetCategoryEntity copyWithCompanion(BudgetCategoriesCompanion data) {
    return BudgetCategoryEntity(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      allocatedAmountInCents: data.allocatedAmountInCents.present
          ? data.allocatedAmountInCents.value
          : this.allocatedAmountInCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoryEntity(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('allocatedAmountInCents: $allocatedAmountInCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    categoryId,
    allocatedAmountInCents,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategoryEntity &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.categoryId == this.categoryId &&
          other.allocatedAmountInCents == this.allocatedAmountInCents &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetCategoriesCompanion extends UpdateCompanion<BudgetCategoryEntity> {
  final Value<int> id;
  final Value<int> budgetId;
  final Value<int> categoryId;
  final Value<int> allocatedAmountInCents;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BudgetCategoriesCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.allocatedAmountInCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BudgetCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int budgetId,
    required int categoryId,
    required int allocatedAmountInCents,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : budgetId = Value(budgetId),
       categoryId = Value(categoryId),
       allocatedAmountInCents = Value(allocatedAmountInCents);
  static Insertable<BudgetCategoryEntity> custom({
    Expression<int>? id,
    Expression<int>? budgetId,
    Expression<int>? categoryId,
    Expression<int>? allocatedAmountInCents,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (categoryId != null) 'category_id': categoryId,
      if (allocatedAmountInCents != null)
        'allocated_amount_in_cents': allocatedAmountInCents,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BudgetCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? budgetId,
    Value<int>? categoryId,
    Value<int>? allocatedAmountInCents,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BudgetCategoriesCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      categoryId: categoryId ?? this.categoryId,
      allocatedAmountInCents:
          allocatedAmountInCents ?? this.allocatedAmountInCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (allocatedAmountInCents.present) {
      map['allocated_amount_in_cents'] = Variable<int>(
        allocatedAmountInCents.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('allocatedAmountInCents: $allocatedAmountInCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetAmountInCentsMeta =
      const VerificationMeta('targetAmountInCents');
  @override
  late final GeneratedColumn<int> targetAmountInCents = GeneratedColumn<int>(
    'target_amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountInCentsMeta =
      const VerificationMeta('currentAmountInCents');
  @override
  late final GeneratedColumn<int> currentAmountInCents = GeneratedColumn<int>(
    'current_amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<GoalStatus>($GoalsTable.$converterstatus);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyContributionInCentsMeta =
      const VerificationMeta('monthlyContributionInCents');
  @override
  late final GeneratedColumn<int> monthlyContributionInCents =
      GeneratedColumn<int>(
        'monthly_contribution_in_cents',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _autoSaveEnabledMeta = const VerificationMeta(
    'autoSaveEnabled',
  );
  @override
  late final GeneratedColumn<bool> autoSaveEnabled = GeneratedColumn<bool>(
    'auto_save_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_save_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoSavePercentageMeta =
      const VerificationMeta('autoSavePercentage');
  @override
  late final GeneratedColumn<int> autoSavePercentage = GeneratedColumn<int>(
    'auto_save_percentage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    description,
    targetAmountInCents,
    currentAmountInCents,
    currency,
    targetDate,
    status,
    accountId,
    monthlyContributionInCents,
    autoSaveEnabled,
    autoSavePercentage,
    priority,
    color,
    icon,
    imageUrl,
    notes,
    createdAt,
    updatedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('target_amount_in_cents')) {
      context.handle(
        _targetAmountInCentsMeta,
        targetAmountInCents.isAcceptableOrUnknown(
          data['target_amount_in_cents']!,
          _targetAmountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountInCentsMeta);
    }
    if (data.containsKey('current_amount_in_cents')) {
      context.handle(
        _currentAmountInCentsMeta,
        currentAmountInCents.isAcceptableOrUnknown(
          data['current_amount_in_cents']!,
          _currentAmountInCentsMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('monthly_contribution_in_cents')) {
      context.handle(
        _monthlyContributionInCentsMeta,
        monthlyContributionInCents.isAcceptableOrUnknown(
          data['monthly_contribution_in_cents']!,
          _monthlyContributionInCentsMeta,
        ),
      );
    }
    if (data.containsKey('auto_save_enabled')) {
      context.handle(
        _autoSaveEnabledMeta,
        autoSaveEnabled.isAcceptableOrUnknown(
          data['auto_save_enabled']!,
          _autoSaveEnabledMeta,
        ),
      );
    }
    if (data.containsKey('auto_save_percentage')) {
      context.handle(
        _autoSavePercentageMeta,
        autoSavePercentage.isAcceptableOrUnknown(
          data['auto_save_percentage']!,
          _autoSavePercentageMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      targetAmountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount_in_cents'],
      )!,
      currentAmountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_amount_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      status: $GoalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      monthlyContributionInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_contribution_in_cents'],
      ),
      autoSaveEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_save_enabled'],
      )!,
      autoSavePercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_save_percentage'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GoalStatus, int, int> $converterstatus =
      const EnumIndexConverter<GoalStatus>(GoalStatus.values);
}

class GoalEntity extends DataClass implements Insertable<GoalEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Goal name
  final String name;

  /// Goal description
  final String? description;

  /// Target amount in cents
  final int targetAmountInCents;

  /// Current saved amount in cents
  final int currentAmountInCents;

  /// Currency code
  final String currency;

  /// Target date to achieve the goal
  final DateTime targetDate;

  /// Goal status
  final GoalStatus status;

  /// Linked account ID (where savings are stored)
  final int? accountId;

  /// Monthly contribution amount in cents
  final int? monthlyContributionInCents;

  /// Whether auto-save is enabled
  final bool autoSaveEnabled;

  /// Auto-save percentage (0-100)
  final int? autoSavePercentage;

  /// Goal priority (1-5, 1 being highest)
  final int priority;

  /// Goal color (hex code)
  final String? color;

  /// Goal icon name
  final String? icon;

  /// Goal image URL
  final String? imageUrl;

  /// Notes about the goal
  final String? notes;

  /// When the goal was created
  final DateTime createdAt;

  /// When the goal was last updated
  final DateTime updatedAt;

  /// When the goal was completed
  final DateTime? completedAt;
  const GoalEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.targetAmountInCents,
    required this.currentAmountInCents,
    required this.currency,
    required this.targetDate,
    required this.status,
    this.accountId,
    this.monthlyContributionInCents,
    required this.autoSaveEnabled,
    this.autoSavePercentage,
    required this.priority,
    this.color,
    this.icon,
    this.imageUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['target_amount_in_cents'] = Variable<int>(targetAmountInCents);
    map['current_amount_in_cents'] = Variable<int>(currentAmountInCents);
    map['currency'] = Variable<String>(currency);
    map['target_date'] = Variable<DateTime>(targetDate);
    {
      map['status'] = Variable<int>($GoalsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || monthlyContributionInCents != null) {
      map['monthly_contribution_in_cents'] = Variable<int>(
        monthlyContributionInCents,
      );
    }
    map['auto_save_enabled'] = Variable<bool>(autoSaveEnabled);
    if (!nullToAbsent || autoSavePercentage != null) {
      map['auto_save_percentage'] = Variable<int>(autoSavePercentage);
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      targetAmountInCents: Value(targetAmountInCents),
      currentAmountInCents: Value(currentAmountInCents),
      currency: Value(currency),
      targetDate: Value(targetDate),
      status: Value(status),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      monthlyContributionInCents:
          monthlyContributionInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyContributionInCents),
      autoSaveEnabled: Value(autoSaveEnabled),
      autoSavePercentage: autoSavePercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(autoSavePercentage),
      priority: Value(priority),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory GoalEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      targetAmountInCents: serializer.fromJson<int>(
        json['targetAmountInCents'],
      ),
      currentAmountInCents: serializer.fromJson<int>(
        json['currentAmountInCents'],
      ),
      currency: serializer.fromJson<String>(json['currency']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      status: $GoalsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      accountId: serializer.fromJson<int?>(json['accountId']),
      monthlyContributionInCents: serializer.fromJson<int?>(
        json['monthlyContributionInCents'],
      ),
      autoSaveEnabled: serializer.fromJson<bool>(json['autoSaveEnabled']),
      autoSavePercentage: serializer.fromJson<int?>(json['autoSavePercentage']),
      priority: serializer.fromJson<int>(json['priority']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'targetAmountInCents': serializer.toJson<int>(targetAmountInCents),
      'currentAmountInCents': serializer.toJson<int>(currentAmountInCents),
      'currency': serializer.toJson<String>(currency),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'status': serializer.toJson<int>(
        $GoalsTable.$converterstatus.toJson(status),
      ),
      'accountId': serializer.toJson<int?>(accountId),
      'monthlyContributionInCents': serializer.toJson<int?>(
        monthlyContributionInCents,
      ),
      'autoSaveEnabled': serializer.toJson<bool>(autoSaveEnabled),
      'autoSavePercentage': serializer.toJson<int?>(autoSavePercentage),
      'priority': serializer.toJson<int>(priority),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  GoalEntity copyWith({
    int? id,
    int? userId,
    String? name,
    Value<String?> description = const Value.absent(),
    int? targetAmountInCents,
    int? currentAmountInCents,
    String? currency,
    DateTime? targetDate,
    GoalStatus? status,
    Value<int?> accountId = const Value.absent(),
    Value<int?> monthlyContributionInCents = const Value.absent(),
    bool? autoSaveEnabled,
    Value<int?> autoSavePercentage = const Value.absent(),
    int? priority,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => GoalEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    targetAmountInCents: targetAmountInCents ?? this.targetAmountInCents,
    currentAmountInCents: currentAmountInCents ?? this.currentAmountInCents,
    currency: currency ?? this.currency,
    targetDate: targetDate ?? this.targetDate,
    status: status ?? this.status,
    accountId: accountId.present ? accountId.value : this.accountId,
    monthlyContributionInCents: monthlyContributionInCents.present
        ? monthlyContributionInCents.value
        : this.monthlyContributionInCents,
    autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
    autoSavePercentage: autoSavePercentage.present
        ? autoSavePercentage.value
        : this.autoSavePercentage,
    priority: priority ?? this.priority,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  GoalEntity copyWithCompanion(GoalsCompanion data) {
    return GoalEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      targetAmountInCents: data.targetAmountInCents.present
          ? data.targetAmountInCents.value
          : this.targetAmountInCents,
      currentAmountInCents: data.currentAmountInCents.present
          ? data.currentAmountInCents.value
          : this.currentAmountInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      status: data.status.present ? data.status.value : this.status,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      monthlyContributionInCents: data.monthlyContributionInCents.present
          ? data.monthlyContributionInCents.value
          : this.monthlyContributionInCents,
      autoSaveEnabled: data.autoSaveEnabled.present
          ? data.autoSaveEnabled.value
          : this.autoSaveEnabled,
      autoSavePercentage: data.autoSavePercentage.present
          ? data.autoSavePercentage.value
          : this.autoSavePercentage,
      priority: data.priority.present ? data.priority.value : this.priority,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('targetAmountInCents: $targetAmountInCents, ')
          ..write('currentAmountInCents: $currentAmountInCents, ')
          ..write('currency: $currency, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('monthlyContributionInCents: $monthlyContributionInCents, ')
          ..write('autoSaveEnabled: $autoSaveEnabled, ')
          ..write('autoSavePercentage: $autoSavePercentage, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    name,
    description,
    targetAmountInCents,
    currentAmountInCents,
    currency,
    targetDate,
    status,
    accountId,
    monthlyContributionInCents,
    autoSaveEnabled,
    autoSavePercentage,
    priority,
    color,
    icon,
    imageUrl,
    notes,
    createdAt,
    updatedAt,
    completedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description &&
          other.targetAmountInCents == this.targetAmountInCents &&
          other.currentAmountInCents == this.currentAmountInCents &&
          other.currency == this.currency &&
          other.targetDate == this.targetDate &&
          other.status == this.status &&
          other.accountId == this.accountId &&
          other.monthlyContributionInCents == this.monthlyContributionInCents &&
          other.autoSaveEnabled == this.autoSaveEnabled &&
          other.autoSavePercentage == this.autoSavePercentage &&
          other.priority == this.priority &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.imageUrl == this.imageUrl &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class GoalsCompanion extends UpdateCompanion<GoalEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> targetAmountInCents;
  final Value<int> currentAmountInCents;
  final Value<String> currency;
  final Value<DateTime> targetDate;
  final Value<GoalStatus> status;
  final Value<int?> accountId;
  final Value<int?> monthlyContributionInCents;
  final Value<bool> autoSaveEnabled;
  final Value<int?> autoSavePercentage;
  final Value<int> priority;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<String?> imageUrl;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.targetAmountInCents = const Value.absent(),
    this.currentAmountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.accountId = const Value.absent(),
    this.monthlyContributionInCents = const Value.absent(),
    this.autoSaveEnabled = const Value.absent(),
    this.autoSavePercentage = const Value.absent(),
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String name,
    this.description = const Value.absent(),
    required int targetAmountInCents,
    this.currentAmountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    required DateTime targetDate,
    this.status = const Value.absent(),
    this.accountId = const Value.absent(),
    this.monthlyContributionInCents = const Value.absent(),
    this.autoSaveEnabled = const Value.absent(),
    this.autoSavePercentage = const Value.absent(),
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : userId = Value(userId),
       name = Value(name),
       targetAmountInCents = Value(targetAmountInCents),
       targetDate = Value(targetDate);
  static Insertable<GoalEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? targetAmountInCents,
    Expression<int>? currentAmountInCents,
    Expression<String>? currency,
    Expression<DateTime>? targetDate,
    Expression<int>? status,
    Expression<int>? accountId,
    Expression<int>? monthlyContributionInCents,
    Expression<bool>? autoSaveEnabled,
    Expression<int>? autoSavePercentage,
    Expression<int>? priority,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<String>? imageUrl,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (targetAmountInCents != null)
        'target_amount_in_cents': targetAmountInCents,
      if (currentAmountInCents != null)
        'current_amount_in_cents': currentAmountInCents,
      if (currency != null) 'currency': currency,
      if (targetDate != null) 'target_date': targetDate,
      if (status != null) 'status': status,
      if (accountId != null) 'account_id': accountId,
      if (monthlyContributionInCents != null)
        'monthly_contribution_in_cents': monthlyContributionInCents,
      if (autoSaveEnabled != null) 'auto_save_enabled': autoSaveEnabled,
      if (autoSavePercentage != null)
        'auto_save_percentage': autoSavePercentage,
      if (priority != null) 'priority': priority,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (imageUrl != null) 'image_url': imageUrl,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? targetAmountInCents,
    Value<int>? currentAmountInCents,
    Value<String>? currency,
    Value<DateTime>? targetDate,
    Value<GoalStatus>? status,
    Value<int?>? accountId,
    Value<int?>? monthlyContributionInCents,
    Value<bool>? autoSaveEnabled,
    Value<int?>? autoSavePercentage,
    Value<int>? priority,
    Value<String?>? color,
    Value<String?>? icon,
    Value<String?>? imageUrl,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmountInCents: targetAmountInCents ?? this.targetAmountInCents,
      currentAmountInCents: currentAmountInCents ?? this.currentAmountInCents,
      currency: currency ?? this.currency,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      accountId: accountId ?? this.accountId,
      monthlyContributionInCents:
          monthlyContributionInCents ?? this.monthlyContributionInCents,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      autoSavePercentage: autoSavePercentage ?? this.autoSavePercentage,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetAmountInCents.present) {
      map['target_amount_in_cents'] = Variable<int>(targetAmountInCents.value);
    }
    if (currentAmountInCents.present) {
      map['current_amount_in_cents'] = Variable<int>(
        currentAmountInCents.value,
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $GoalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (monthlyContributionInCents.present) {
      map['monthly_contribution_in_cents'] = Variable<int>(
        monthlyContributionInCents.value,
      );
    }
    if (autoSaveEnabled.present) {
      map['auto_save_enabled'] = Variable<bool>(autoSaveEnabled.value);
    }
    if (autoSavePercentage.present) {
      map['auto_save_percentage'] = Variable<int>(autoSavePercentage.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('targetAmountInCents: $targetAmountInCents, ')
          ..write('currentAmountInCents: $currentAmountInCents, ')
          ..write('currency: $currency, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('accountId: $accountId, ')
          ..write('monthlyContributionInCents: $monthlyContributionInCents, ')
          ..write('autoSaveEnabled: $autoSaveEnabled, ')
          ..write('autoSavePercentage: $autoSavePercentage, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTable extends RecurringTransactions
    with TableInfo<$RecurringTransactionsTable, RecurringTransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecurrenceFrequency, int>
  frequency =
      GeneratedColumn<int>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<RecurrenceFrequency>(
        $RecurringTransactionsTable.$converterfrequency,
      );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextOccurrenceMeta = const VerificationMeta(
    'nextOccurrence',
  );
  @override
  late final GeneratedColumn<DateTime> nextOccurrence =
      GeneratedColumn<DateTime>(
        'next_occurrence',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastOccurrenceMeta = const VerificationMeta(
    'lastOccurrence',
  );
  @override
  late final GeneratedColumn<DateTime> lastOccurrence =
      GeneratedColumn<DateTime>(
        'last_occurrence',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoCreateMeta = const VerificationMeta(
    'autoCreate',
  );
  @override
  late final GeneratedColumn<bool> autoCreate = GeneratedColumn<bool>(
    'auto_create',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_create" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _daysBeforeToCreateMeta =
      const VerificationMeta('daysBeforeToCreate');
  @override
  late final GeneratedColumn<int> daysBeforeToCreate = GeneratedColumn<int>(
    'days_before_to_create',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enableNotificationsMeta =
      const VerificationMeta('enableNotifications');
  @override
  late final GeneratedColumn<bool> enableNotifications = GeneratedColumn<bool>(
    'enable_notifications',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enable_notifications" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationMinutesBeforeMeta =
      const VerificationMeta('notificationMinutesBefore');
  @override
  late final GeneratedColumn<int> notificationMinutesBefore =
      GeneratedColumn<int>(
        'notification_minutes_before',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    accountId,
    categoryId,
    type,
    amountInCents,
    currency,
    description,
    frequency,
    startDate,
    endDate,
    nextOccurrence,
    lastOccurrence,
    isActive,
    autoCreate,
    daysBeforeToCreate,
    payee,
    notes,
    enableNotifications,
    notificationMinutesBefore,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringTransactionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('next_occurrence')) {
      context.handle(
        _nextOccurrenceMeta,
        nextOccurrence.isAcceptableOrUnknown(
          data['next_occurrence']!,
          _nextOccurrenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextOccurrenceMeta);
    }
    if (data.containsKey('last_occurrence')) {
      context.handle(
        _lastOccurrenceMeta,
        lastOccurrence.isAcceptableOrUnknown(
          data['last_occurrence']!,
          _lastOccurrenceMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('auto_create')) {
      context.handle(
        _autoCreateMeta,
        autoCreate.isAcceptableOrUnknown(data['auto_create']!, _autoCreateMeta),
      );
    }
    if (data.containsKey('days_before_to_create')) {
      context.handle(
        _daysBeforeToCreateMeta,
        daysBeforeToCreate.isAcceptableOrUnknown(
          data['days_before_to_create']!,
          _daysBeforeToCreateMeta,
        ),
      );
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('enable_notifications')) {
      context.handle(
        _enableNotificationsMeta,
        enableNotifications.isAcceptableOrUnknown(
          data['enable_notifications']!,
          _enableNotificationsMeta,
        ),
      );
    }
    if (data.containsKey('notification_minutes_before')) {
      context.handle(
        _notificationMinutesBeforeMeta,
        notificationMinutesBefore.isAcceptableOrUnknown(
          data['notification_minutes_before']!,
          _notificationMinutesBeforeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransactionEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransactionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      frequency: $RecurringTransactionsTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      nextOccurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_occurrence'],
      )!,
      lastOccurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_occurrence'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      autoCreate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_create'],
      )!,
      daysBeforeToCreate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_before_to_create'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      enableNotifications: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_notifications'],
      )!,
      notificationMinutesBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_minutes_before'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringTransactionsTable createAlias(String alias) {
    return $RecurringTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecurrenceFrequency, int, int> $converterfrequency =
      const EnumIndexConverter<RecurrenceFrequency>(RecurrenceFrequency.values);
}

class RecurringTransactionEntity extends DataClass
    implements Insertable<RecurringTransactionEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Account ID (foreign key)
  final int accountId;

  /// Category ID (foreign key)
  final int? categoryId;

  /// Transaction type (income/expense/transfer)
  final int type;

  /// Amount in cents
  final int amountInCents;

  /// Currency code
  final String currency;

  /// Description
  final String description;

  /// Recurrence frequency
  final RecurrenceFrequency frequency;

  /// Start date
  final DateTime startDate;

  /// End date (null for indefinite)
  final DateTime? endDate;

  /// Next occurrence date
  final DateTime nextOccurrence;

  /// Last occurrence date
  final DateTime? lastOccurrence;

  /// Whether this recurring transaction is active
  final bool isActive;

  /// Whether to auto-create transactions
  final bool autoCreate;

  /// Days before to create transaction
  final int daysBeforeToCreate;

  /// Payee/Payer name
  final String? payee;

  /// Notes
  final String? notes;

  /// Whether to show notifications for this recurring transaction
  final bool enableNotifications;

  /// Minutes before the transaction to show notification (0 = on due date)
  final int notificationMinutesBefore;

  /// When the recurring transaction was created
  final DateTime createdAt;

  /// When the recurring transaction was last updated
  final DateTime updatedAt;
  const RecurringTransactionEntity({
    required this.id,
    required this.userId,
    required this.accountId,
    this.categoryId,
    required this.type,
    required this.amountInCents,
    required this.currency,
    required this.description,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.nextOccurrence,
    this.lastOccurrence,
    required this.isActive,
    required this.autoCreate,
    required this.daysBeforeToCreate,
    this.payee,
    this.notes,
    required this.enableNotifications,
    required this.notificationMinutesBefore,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['type'] = Variable<int>(type);
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['currency'] = Variable<String>(currency);
    map['description'] = Variable<String>(description);
    {
      map['frequency'] = Variable<int>(
        $RecurringTransactionsTable.$converterfrequency.toSql(frequency),
      );
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['next_occurrence'] = Variable<DateTime>(nextOccurrence);
    if (!nullToAbsent || lastOccurrence != null) {
      map['last_occurrence'] = Variable<DateTime>(lastOccurrence);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['auto_create'] = Variable<bool>(autoCreate);
    map['days_before_to_create'] = Variable<int>(daysBeforeToCreate);
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['enable_notifications'] = Variable<bool>(enableNotifications);
    map['notification_minutes_before'] = Variable<int>(
      notificationMinutesBefore,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      type: Value(type),
      amountInCents: Value(amountInCents),
      currency: Value(currency),
      description: Value(description),
      frequency: Value(frequency),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      nextOccurrence: Value(nextOccurrence),
      lastOccurrence: lastOccurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOccurrence),
      isActive: Value(isActive),
      autoCreate: Value(autoCreate),
      daysBeforeToCreate: Value(daysBeforeToCreate),
      payee: payee == null && nullToAbsent
          ? const Value.absent()
          : Value(payee),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      enableNotifications: Value(enableNotifications),
      notificationMinutesBefore: Value(notificationMinutesBefore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringTransactionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransactionEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      type: serializer.fromJson<int>(json['type']),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      currency: serializer.fromJson<String>(json['currency']),
      description: serializer.fromJson<String>(json['description']),
      frequency: $RecurringTransactionsTable.$converterfrequency.fromJson(
        serializer.fromJson<int>(json['frequency']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      nextOccurrence: serializer.fromJson<DateTime>(json['nextOccurrence']),
      lastOccurrence: serializer.fromJson<DateTime?>(json['lastOccurrence']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      autoCreate: serializer.fromJson<bool>(json['autoCreate']),
      daysBeforeToCreate: serializer.fromJson<int>(json['daysBeforeToCreate']),
      payee: serializer.fromJson<String?>(json['payee']),
      notes: serializer.fromJson<String?>(json['notes']),
      enableNotifications: serializer.fromJson<bool>(
        json['enableNotifications'],
      ),
      notificationMinutesBefore: serializer.fromJson<int>(
        json['notificationMinutesBefore'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'accountId': serializer.toJson<int>(accountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'type': serializer.toJson<int>(type),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'currency': serializer.toJson<String>(currency),
      'description': serializer.toJson<String>(description),
      'frequency': serializer.toJson<int>(
        $RecurringTransactionsTable.$converterfrequency.toJson(frequency),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'nextOccurrence': serializer.toJson<DateTime>(nextOccurrence),
      'lastOccurrence': serializer.toJson<DateTime?>(lastOccurrence),
      'isActive': serializer.toJson<bool>(isActive),
      'autoCreate': serializer.toJson<bool>(autoCreate),
      'daysBeforeToCreate': serializer.toJson<int>(daysBeforeToCreate),
      'payee': serializer.toJson<String?>(payee),
      'notes': serializer.toJson<String?>(notes),
      'enableNotifications': serializer.toJson<bool>(enableNotifications),
      'notificationMinutesBefore': serializer.toJson<int>(
        notificationMinutesBefore,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringTransactionEntity copyWith({
    int? id,
    int? userId,
    int? accountId,
    Value<int?> categoryId = const Value.absent(),
    int? type,
    int? amountInCents,
    String? currency,
    String? description,
    RecurrenceFrequency? frequency,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    DateTime? nextOccurrence,
    Value<DateTime?> lastOccurrence = const Value.absent(),
    bool? isActive,
    bool? autoCreate,
    int? daysBeforeToCreate,
    Value<String?> payee = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? enableNotifications,
    int? notificationMinutesBefore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringTransactionEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    type: type ?? this.type,
    amountInCents: amountInCents ?? this.amountInCents,
    currency: currency ?? this.currency,
    description: description ?? this.description,
    frequency: frequency ?? this.frequency,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    nextOccurrence: nextOccurrence ?? this.nextOccurrence,
    lastOccurrence: lastOccurrence.present
        ? lastOccurrence.value
        : this.lastOccurrence,
    isActive: isActive ?? this.isActive,
    autoCreate: autoCreate ?? this.autoCreate,
    daysBeforeToCreate: daysBeforeToCreate ?? this.daysBeforeToCreate,
    payee: payee.present ? payee.value : this.payee,
    notes: notes.present ? notes.value : this.notes,
    enableNotifications: enableNotifications ?? this.enableNotifications,
    notificationMinutesBefore:
        notificationMinutesBefore ?? this.notificationMinutesBefore,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringTransactionEntity copyWithCompanion(
    RecurringTransactionsCompanion data,
  ) {
    return RecurringTransactionEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      type: data.type.present ? data.type.value : this.type,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      description: data.description.present
          ? data.description.value
          : this.description,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      nextOccurrence: data.nextOccurrence.present
          ? data.nextOccurrence.value
          : this.nextOccurrence,
      lastOccurrence: data.lastOccurrence.present
          ? data.lastOccurrence.value
          : this.lastOccurrence,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      autoCreate: data.autoCreate.present
          ? data.autoCreate.value
          : this.autoCreate,
      daysBeforeToCreate: data.daysBeforeToCreate.present
          ? data.daysBeforeToCreate.value
          : this.daysBeforeToCreate,
      payee: data.payee.present ? data.payee.value : this.payee,
      notes: data.notes.present ? data.notes.value : this.notes,
      enableNotifications: data.enableNotifications.present
          ? data.enableNotifications.value
          : this.enableNotifications,
      notificationMinutesBefore: data.notificationMinutesBefore.present
          ? data.notificationMinutesBefore.value
          : this.notificationMinutesBefore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('nextOccurrence: $nextOccurrence, ')
          ..write('lastOccurrence: $lastOccurrence, ')
          ..write('isActive: $isActive, ')
          ..write('autoCreate: $autoCreate, ')
          ..write('daysBeforeToCreate: $daysBeforeToCreate, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('enableNotifications: $enableNotifications, ')
          ..write('notificationMinutesBefore: $notificationMinutesBefore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    accountId,
    categoryId,
    type,
    amountInCents,
    currency,
    description,
    frequency,
    startDate,
    endDate,
    nextOccurrence,
    lastOccurrence,
    isActive,
    autoCreate,
    daysBeforeToCreate,
    payee,
    notes,
    enableNotifications,
    notificationMinutesBefore,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransactionEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.type == this.type &&
          other.amountInCents == this.amountInCents &&
          other.currency == this.currency &&
          other.description == this.description &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.nextOccurrence == this.nextOccurrence &&
          other.lastOccurrence == this.lastOccurrence &&
          other.isActive == this.isActive &&
          other.autoCreate == this.autoCreate &&
          other.daysBeforeToCreate == this.daysBeforeToCreate &&
          other.payee == this.payee &&
          other.notes == this.notes &&
          other.enableNotifications == this.enableNotifications &&
          other.notificationMinutesBefore == this.notificationMinutesBefore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringTransactionsCompanion
    extends UpdateCompanion<RecurringTransactionEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> accountId;
  final Value<int?> categoryId;
  final Value<int> type;
  final Value<int> amountInCents;
  final Value<String> currency;
  final Value<String> description;
  final Value<RecurrenceFrequency> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime> nextOccurrence;
  final Value<DateTime?> lastOccurrence;
  final Value<bool> isActive;
  final Value<bool> autoCreate;
  final Value<int> daysBeforeToCreate;
  final Value<String?> payee;
  final Value<String?> notes;
  final Value<bool> enableNotifications;
  final Value<int> notificationMinutesBefore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RecurringTransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.nextOccurrence = const Value.absent(),
    this.lastOccurrence = const Value.absent(),
    this.isActive = const Value.absent(),
    this.autoCreate = const Value.absent(),
    this.daysBeforeToCreate = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.enableNotifications = const Value.absent(),
    this.notificationMinutesBefore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RecurringTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int accountId,
    this.categoryId = const Value.absent(),
    required int type,
    required int amountInCents,
    this.currency = const Value.absent(),
    required String description,
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required DateTime nextOccurrence,
    this.lastOccurrence = const Value.absent(),
    this.isActive = const Value.absent(),
    this.autoCreate = const Value.absent(),
    this.daysBeforeToCreate = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.enableNotifications = const Value.absent(),
    this.notificationMinutesBefore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       accountId = Value(accountId),
       type = Value(type),
       amountInCents = Value(amountInCents),
       description = Value(description),
       frequency = Value(frequency),
       startDate = Value(startDate),
       nextOccurrence = Value(nextOccurrence);
  static Insertable<RecurringTransactionEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? accountId,
    Expression<int>? categoryId,
    Expression<int>? type,
    Expression<int>? amountInCents,
    Expression<String>? currency,
    Expression<String>? description,
    Expression<int>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? nextOccurrence,
    Expression<DateTime>? lastOccurrence,
    Expression<bool>? isActive,
    Expression<bool>? autoCreate,
    Expression<int>? daysBeforeToCreate,
    Expression<String>? payee,
    Expression<String>? notes,
    Expression<bool>? enableNotifications,
    Expression<int>? notificationMinutesBefore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (type != null) 'type': type,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (currency != null) 'currency': currency,
      if (description != null) 'description': description,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (nextOccurrence != null) 'next_occurrence': nextOccurrence,
      if (lastOccurrence != null) 'last_occurrence': lastOccurrence,
      if (isActive != null) 'is_active': isActive,
      if (autoCreate != null) 'auto_create': autoCreate,
      if (daysBeforeToCreate != null)
        'days_before_to_create': daysBeforeToCreate,
      if (payee != null) 'payee': payee,
      if (notes != null) 'notes': notes,
      if (enableNotifications != null)
        'enable_notifications': enableNotifications,
      if (notificationMinutesBefore != null)
        'notification_minutes_before': notificationMinutesBefore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RecurringTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? accountId,
    Value<int?>? categoryId,
    Value<int>? type,
    Value<int>? amountInCents,
    Value<String>? currency,
    Value<String>? description,
    Value<RecurrenceFrequency>? frequency,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime>? nextOccurrence,
    Value<DateTime?>? lastOccurrence,
    Value<bool>? isActive,
    Value<bool>? autoCreate,
    Value<int>? daysBeforeToCreate,
    Value<String?>? payee,
    Value<String?>? notes,
    Value<bool>? enableNotifications,
    Value<int>? notificationMinutesBefore,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RecurringTransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      amountInCents: amountInCents ?? this.amountInCents,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextOccurrence: nextOccurrence ?? this.nextOccurrence,
      lastOccurrence: lastOccurrence ?? this.lastOccurrence,
      isActive: isActive ?? this.isActive,
      autoCreate: autoCreate ?? this.autoCreate,
      daysBeforeToCreate: daysBeforeToCreate ?? this.daysBeforeToCreate,
      payee: payee ?? this.payee,
      notes: notes ?? this.notes,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationMinutesBefore:
          notificationMinutesBefore ?? this.notificationMinutesBefore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(
        $RecurringTransactionsTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (nextOccurrence.present) {
      map['next_occurrence'] = Variable<DateTime>(nextOccurrence.value);
    }
    if (lastOccurrence.present) {
      map['last_occurrence'] = Variable<DateTime>(lastOccurrence.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (autoCreate.present) {
      map['auto_create'] = Variable<bool>(autoCreate.value);
    }
    if (daysBeforeToCreate.present) {
      map['days_before_to_create'] = Variable<int>(daysBeforeToCreate.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (enableNotifications.present) {
      map['enable_notifications'] = Variable<bool>(enableNotifications.value);
    }
    if (notificationMinutesBefore.present) {
      map['notification_minutes_before'] = Variable<int>(
        notificationMinutesBefore.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('type: $type, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('nextOccurrence: $nextOccurrence, ')
          ..write('lastOccurrence: $lastOccurrence, ')
          ..write('isActive: $isActive, ')
          ..write('autoCreate: $autoCreate, ')
          ..write('daysBeforeToCreate: $daysBeforeToCreate, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('enableNotifications: $enableNotifications, ')
          ..write('notificationMinutesBefore: $notificationMinutesBefore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsTable extends Savings
    with TableInfo<$SavingsTable, SavingsEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SavingsCategory, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SavingsCategory>($SavingsTable.$convertercategory);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueInCentsMeta =
      const VerificationMeta('currentValueInCents');
  @override
  late final GeneratedColumn<int> currentValueInCents = GeneratedColumn<int>(
    'current_value_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _investedAmountInCentsMeta =
      const VerificationMeta('investedAmountInCents');
  @override
  late final GeneratedColumn<int> investedAmountInCents = GeneratedColumn<int>(
    'invested_amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _maturityDateMeta = const VerificationMeta(
    'maturityDate',
  );
  @override
  late final GeneratedColumn<DateTime> maturityDate = GeneratedColumn<DateTime>(
    'maturity_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<int> interestRate = GeneratedColumn<int>(
    'interest_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberMeta = const VerificationMeta(
    'accountNumber',
  );
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
    'account_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    category,
    name,
    currentValueInCents,
    investedAmountInCents,
    currency,
    maturityDate,
    interestRate,
    accountNumber,
    institutionName,
    notes,
    isActive,
    color,
    icon,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('current_value_in_cents')) {
      context.handle(
        _currentValueInCentsMeta,
        currentValueInCents.isAcceptableOrUnknown(
          data['current_value_in_cents']!,
          _currentValueInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueInCentsMeta);
    }
    if (data.containsKey('invested_amount_in_cents')) {
      context.handle(
        _investedAmountInCentsMeta,
        investedAmountInCents.isAcceptableOrUnknown(
          data['invested_amount_in_cents']!,
          _investedAmountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_investedAmountInCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('maturity_date')) {
      context.handle(
        _maturityDateMeta,
        maturityDate.isAcceptableOrUnknown(
          data['maturity_date']!,
          _maturityDateMeta,
        ),
      );
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    }
    if (data.containsKey('account_number')) {
      context.handle(
        _accountNumberMeta,
        accountNumber.isAcceptableOrUnknown(
          data['account_number']!,
          _accountNumberMeta,
        ),
      );
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      category: $SavingsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currentValueInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_value_in_cents'],
      )!,
      investedAmountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invested_amount_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      maturityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}maturity_date'],
      ),
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_rate'],
      ),
      accountNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number'],
      ),
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavingsTable createAlias(String alias) {
    return $SavingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SavingsCategory, int, int> $convertercategory =
      const EnumIndexConverter<SavingsCategory>(SavingsCategory.values);
}

class SavingsEntity extends DataClass implements Insertable<SavingsEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Savings category
  final SavingsCategory category;

  /// Savings name/description
  final String name;

  /// Current value in cents
  final int currentValueInCents;

  /// Invested/Principal amount in cents
  final int investedAmountInCents;

  /// Currency code
  final String currency;

  /// Maturity date (optional)
  final DateTime? maturityDate;

  /// Interest rate (optional, stored as percentage * 100, e.g., 7.5% = 750)
  final int? interestRate;

  /// Account/Policy/Folio number
  final String? accountNumber;

  /// Institution/Company name (e.g., SBI, HDFC, LIC)
  final String? institutionName;

  /// Additional notes
  final String? notes;

  /// Whether this savings is active
  final bool isActive;

  /// Color for UI display (hex code)
  final String? color;

  /// Icon name for UI display
  final String? icon;

  /// When the savings entry was created
  final DateTime createdAt;

  /// When the savings entry was last updated
  final DateTime updatedAt;
  const SavingsEntity({
    required this.id,
    required this.userId,
    required this.category,
    required this.name,
    required this.currentValueInCents,
    required this.investedAmountInCents,
    required this.currency,
    this.maturityDate,
    this.interestRate,
    this.accountNumber,
    this.institutionName,
    this.notes,
    required this.isActive,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    {
      map['category'] = Variable<int>(
        $SavingsTable.$convertercategory.toSql(category),
      );
    }
    map['name'] = Variable<String>(name);
    map['current_value_in_cents'] = Variable<int>(currentValueInCents);
    map['invested_amount_in_cents'] = Variable<int>(investedAmountInCents);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || maturityDate != null) {
      map['maturity_date'] = Variable<DateTime>(maturityDate);
    }
    if (!nullToAbsent || interestRate != null) {
      map['interest_rate'] = Variable<int>(interestRate);
    }
    if (!nullToAbsent || accountNumber != null) {
      map['account_number'] = Variable<String>(accountNumber);
    }
    if (!nullToAbsent || institutionName != null) {
      map['institution_name'] = Variable<String>(institutionName);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavingsCompanion toCompanion(bool nullToAbsent) {
    return SavingsCompanion(
      id: Value(id),
      userId: Value(userId),
      category: Value(category),
      name: Value(name),
      currentValueInCents: Value(currentValueInCents),
      investedAmountInCents: Value(investedAmountInCents),
      currency: Value(currency),
      maturityDate: maturityDate == null && nullToAbsent
          ? const Value.absent()
          : Value(maturityDate),
      interestRate: interestRate == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRate),
      accountNumber: accountNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumber),
      institutionName: institutionName == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionName),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavingsEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      category: $SavingsTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      name: serializer.fromJson<String>(json['name']),
      currentValueInCents: serializer.fromJson<int>(
        json['currentValueInCents'],
      ),
      investedAmountInCents: serializer.fromJson<int>(
        json['investedAmountInCents'],
      ),
      currency: serializer.fromJson<String>(json['currency']),
      maturityDate: serializer.fromJson<DateTime?>(json['maturityDate']),
      interestRate: serializer.fromJson<int?>(json['interestRate']),
      accountNumber: serializer.fromJson<String?>(json['accountNumber']),
      institutionName: serializer.fromJson<String?>(json['institutionName']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'category': serializer.toJson<int>(
        $SavingsTable.$convertercategory.toJson(category),
      ),
      'name': serializer.toJson<String>(name),
      'currentValueInCents': serializer.toJson<int>(currentValueInCents),
      'investedAmountInCents': serializer.toJson<int>(investedAmountInCents),
      'currency': serializer.toJson<String>(currency),
      'maturityDate': serializer.toJson<DateTime?>(maturityDate),
      'interestRate': serializer.toJson<int?>(interestRate),
      'accountNumber': serializer.toJson<String?>(accountNumber),
      'institutionName': serializer.toJson<String?>(institutionName),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavingsEntity copyWith({
    int? id,
    int? userId,
    SavingsCategory? category,
    String? name,
    int? currentValueInCents,
    int? investedAmountInCents,
    String? currency,
    Value<DateTime?> maturityDate = const Value.absent(),
    Value<int?> interestRate = const Value.absent(),
    Value<String?> accountNumber = const Value.absent(),
    Value<String?> institutionName = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SavingsEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    name: name ?? this.name,
    currentValueInCents: currentValueInCents ?? this.currentValueInCents,
    investedAmountInCents: investedAmountInCents ?? this.investedAmountInCents,
    currency: currency ?? this.currency,
    maturityDate: maturityDate.present ? maturityDate.value : this.maturityDate,
    interestRate: interestRate.present ? interestRate.value : this.interestRate,
    accountNumber: accountNumber.present
        ? accountNumber.value
        : this.accountNumber,
    institutionName: institutionName.present
        ? institutionName.value
        : this.institutionName,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavingsEntity copyWithCompanion(SavingsCompanion data) {
    return SavingsEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      currentValueInCents: data.currentValueInCents.present
          ? data.currentValueInCents.value
          : this.currentValueInCents,
      investedAmountInCents: data.investedAmountInCents.present
          ? data.investedAmountInCents.value
          : this.investedAmountInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      maturityDate: data.maturityDate.present
          ? data.maturityDate.value
          : this.maturityDate,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      accountNumber: data.accountNumber.present
          ? data.accountNumber.value
          : this.accountNumber,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('currentValueInCents: $currentValueInCents, ')
          ..write('investedAmountInCents: $investedAmountInCents, ')
          ..write('currency: $currency, ')
          ..write('maturityDate: $maturityDate, ')
          ..write('interestRate: $interestRate, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('institutionName: $institutionName, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    category,
    name,
    currentValueInCents,
    investedAmountInCents,
    currency,
    maturityDate,
    interestRate,
    accountNumber,
    institutionName,
    notes,
    isActive,
    color,
    icon,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.category == this.category &&
          other.name == this.name &&
          other.currentValueInCents == this.currentValueInCents &&
          other.investedAmountInCents == this.investedAmountInCents &&
          other.currency == this.currency &&
          other.maturityDate == this.maturityDate &&
          other.interestRate == this.interestRate &&
          other.accountNumber == this.accountNumber &&
          other.institutionName == this.institutionName &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavingsCompanion extends UpdateCompanion<SavingsEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<SavingsCategory> category;
  final Value<String> name;
  final Value<int> currentValueInCents;
  final Value<int> investedAmountInCents;
  final Value<String> currency;
  final Value<DateTime?> maturityDate;
  final Value<int?> interestRate;
  final Value<String?> accountNumber;
  final Value<String?> institutionName;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SavingsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.currentValueInCents = const Value.absent(),
    this.investedAmountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.maturityDate = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SavingsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required SavingsCategory category,
    required String name,
    required int currentValueInCents,
    required int investedAmountInCents,
    this.currency = const Value.absent(),
    this.maturityDate = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       category = Value(category),
       name = Value(name),
       currentValueInCents = Value(currentValueInCents),
       investedAmountInCents = Value(investedAmountInCents);
  static Insertable<SavingsEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? category,
    Expression<String>? name,
    Expression<int>? currentValueInCents,
    Expression<int>? investedAmountInCents,
    Expression<String>? currency,
    Expression<DateTime>? maturityDate,
    Expression<int>? interestRate,
    Expression<String>? accountNumber,
    Expression<String>? institutionName,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (currentValueInCents != null)
        'current_value_in_cents': currentValueInCents,
      if (investedAmountInCents != null)
        'invested_amount_in_cents': investedAmountInCents,
      if (currency != null) 'currency': currency,
      if (maturityDate != null) 'maturity_date': maturityDate,
      if (interestRate != null) 'interest_rate': interestRate,
      if (accountNumber != null) 'account_number': accountNumber,
      if (institutionName != null) 'institution_name': institutionName,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SavingsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<SavingsCategory>? category,
    Value<String>? name,
    Value<int>? currentValueInCents,
    Value<int>? investedAmountInCents,
    Value<String>? currency,
    Value<DateTime?>? maturityDate,
    Value<int?>? interestRate,
    Value<String?>? accountNumber,
    Value<String?>? institutionName,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<String?>? color,
    Value<String?>? icon,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SavingsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      name: name ?? this.name,
      currentValueInCents: currentValueInCents ?? this.currentValueInCents,
      investedAmountInCents:
          investedAmountInCents ?? this.investedAmountInCents,
      currency: currency ?? this.currency,
      maturityDate: maturityDate ?? this.maturityDate,
      interestRate: interestRate ?? this.interestRate,
      accountNumber: accountNumber ?? this.accountNumber,
      institutionName: institutionName ?? this.institutionName,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $SavingsTable.$convertercategory.toSql(category.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currentValueInCents.present) {
      map['current_value_in_cents'] = Variable<int>(currentValueInCents.value);
    }
    if (investedAmountInCents.present) {
      map['invested_amount_in_cents'] = Variable<int>(
        investedAmountInCents.value,
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (maturityDate.present) {
      map['maturity_date'] = Variable<DateTime>(maturityDate.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<int>(interestRate.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('currentValueInCents: $currentValueInCents, ')
          ..write('investedAmountInCents: $investedAmountInCents, ')
          ..write('currency: $currency, ')
          ..write('maturityDate: $maturityDate, ')
          ..write('interestRate: $interestRate, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('institutionName: $institutionName, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SavingsTransactionsTable extends SavingsTransactions
    with TableInfo<$SavingsTransactionsTable, SavingsTransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savingsIdMeta = const VerificationMeta(
    'savingsId',
  );
  @override
  late final GeneratedColumn<int> savingsId = GeneratedColumn<int>(
    'savings_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SavingsTransactionType, int>
  type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SavingsTransactionType>(
        $SavingsTransactionsTable.$convertertype,
      );
  static const VerificationMeta _amountInCentsMeta = const VerificationMeta(
    'amountInCents',
  );
  @override
  late final GeneratedColumn<int> amountInCents = GeneratedColumn<int>(
    'amount_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
    'units',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricePerUnitInCentsMeta =
      const VerificationMeta('pricePerUnitInCents');
  @override
  late final GeneratedColumn<int> pricePerUnitInCents = GeneratedColumn<int>(
    'price_per_unit_in_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurringTransactionIdMeta =
      const VerificationMeta('recurringTransactionId');
  @override
  late final GeneratedColumn<int> recurringTransactionId = GeneratedColumn<int>(
    'recurring_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<int> linkedTransactionId = GeneratedColumn<int>(
    'linked_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    savingsId,
    type,
    amountInCents,
    currency,
    transactionDate,
    notes,
    units,
    pricePerUnitInCents,
    isRecurring,
    recurringTransactionId,
    linkedTransactionId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsTransactionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('savings_id')) {
      context.handle(
        _savingsIdMeta,
        savingsId.isAcceptableOrUnknown(data['savings_id']!, _savingsIdMeta),
      );
    } else if (isInserting) {
      context.missing(_savingsIdMeta);
    }
    if (data.containsKey('amount_in_cents')) {
      context.handle(
        _amountInCentsMeta,
        amountInCents.isAcceptableOrUnknown(
          data['amount_in_cents']!,
          _amountInCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('units')) {
      context.handle(
        _unitsMeta,
        units.isAcceptableOrUnknown(data['units']!, _unitsMeta),
      );
    }
    if (data.containsKey('price_per_unit_in_cents')) {
      context.handle(
        _pricePerUnitInCentsMeta,
        pricePerUnitInCents.isAcceptableOrUnknown(
          data['price_per_unit_in_cents']!,
          _pricePerUnitInCentsMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('recurring_transaction_id')) {
      context.handle(
        _recurringTransactionIdMeta,
        recurringTransactionId.isAcceptableOrUnknown(
          data['recurring_transaction_id']!,
          _recurringTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
        _linkedTransactionIdMeta,
        linkedTransactionId.isAcceptableOrUnknown(
          data['linked_transaction_id']!,
          _linkedTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsTransactionEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsTransactionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      savingsId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}savings_id'],
      )!,
      type: $SavingsTransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      amountInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_in_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      units: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}units'],
      ),
      pricePerUnitInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_per_unit_in_cents'],
      ),
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      recurringTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurring_transaction_id'],
      ),
      linkedTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavingsTransactionsTable createAlias(String alias) {
    return $SavingsTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SavingsTransactionType, int, int> $convertertype =
      const EnumIndexConverter<SavingsTransactionType>(
        SavingsTransactionType.values,
      );
}

class SavingsTransactionEntity extends DataClass
    implements Insertable<SavingsTransactionEntity> {
  /// Primary key
  final int id;

  /// User ID (foreign key)
  final int userId;

  /// Savings ID (foreign key to Savings table)
  final int savingsId;

  /// Transaction type
  final SavingsTransactionType type;

  /// Amount in cents
  final int amountInCents;

  /// Currency code
  final String currency;

  /// Transaction date
  final DateTime transactionDate;

  /// Additional notes
  final String? notes;

  /// Units (for mutual funds, stocks - optional)
  final double? units;

  /// NAV/Price per unit (for mutual funds, stocks - optional, stored in cents)
  final int? pricePerUnitInCents;

  /// Whether this is from a recurring transaction
  final bool isRecurring;

  /// Recurring transaction ID (if this is part of a recurring series)
  final int? recurringTransactionId;

  /// Linked expense transaction ID (for deposits that create expense transactions)
  final int? linkedTransactionId;

  /// When the transaction was created
  final DateTime createdAt;

  /// When the transaction was last updated
  final DateTime updatedAt;
  const SavingsTransactionEntity({
    required this.id,
    required this.userId,
    required this.savingsId,
    required this.type,
    required this.amountInCents,
    required this.currency,
    required this.transactionDate,
    this.notes,
    this.units,
    this.pricePerUnitInCents,
    required this.isRecurring,
    this.recurringTransactionId,
    this.linkedTransactionId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['savings_id'] = Variable<int>(savingsId);
    {
      map['type'] = Variable<int>(
        $SavingsTransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount_in_cents'] = Variable<int>(amountInCents);
    map['currency'] = Variable<String>(currency);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || units != null) {
      map['units'] = Variable<double>(units);
    }
    if (!nullToAbsent || pricePerUnitInCents != null) {
      map['price_per_unit_in_cents'] = Variable<int>(pricePerUnitInCents);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringTransactionId != null) {
      map['recurring_transaction_id'] = Variable<int>(recurringTransactionId);
    }
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<int>(linkedTransactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavingsTransactionsCompanion toCompanion(bool nullToAbsent) {
    return SavingsTransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      savingsId: Value(savingsId),
      type: Value(type),
      amountInCents: Value(amountInCents),
      currency: Value(currency),
      transactionDate: Value(transactionDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      units: units == null && nullToAbsent
          ? const Value.absent()
          : Value(units),
      pricePerUnitInCents: pricePerUnitInCents == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerUnitInCents),
      isRecurring: Value(isRecurring),
      recurringTransactionId: recurringTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringTransactionId),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavingsTransactionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsTransactionEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      savingsId: serializer.fromJson<int>(json['savingsId']),
      type: $SavingsTransactionsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      amountInCents: serializer.fromJson<int>(json['amountInCents']),
      currency: serializer.fromJson<String>(json['currency']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      units: serializer.fromJson<double?>(json['units']),
      pricePerUnitInCents: serializer.fromJson<int?>(
        json['pricePerUnitInCents'],
      ),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringTransactionId: serializer.fromJson<int?>(
        json['recurringTransactionId'],
      ),
      linkedTransactionId: serializer.fromJson<int?>(
        json['linkedTransactionId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'savingsId': serializer.toJson<int>(savingsId),
      'type': serializer.toJson<int>(
        $SavingsTransactionsTable.$convertertype.toJson(type),
      ),
      'amountInCents': serializer.toJson<int>(amountInCents),
      'currency': serializer.toJson<String>(currency),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'notes': serializer.toJson<String?>(notes),
      'units': serializer.toJson<double?>(units),
      'pricePerUnitInCents': serializer.toJson<int?>(pricePerUnitInCents),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringTransactionId': serializer.toJson<int?>(recurringTransactionId),
      'linkedTransactionId': serializer.toJson<int?>(linkedTransactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavingsTransactionEntity copyWith({
    int? id,
    int? userId,
    int? savingsId,
    SavingsTransactionType? type,
    int? amountInCents,
    String? currency,
    DateTime? transactionDate,
    Value<String?> notes = const Value.absent(),
    Value<double?> units = const Value.absent(),
    Value<int?> pricePerUnitInCents = const Value.absent(),
    bool? isRecurring,
    Value<int?> recurringTransactionId = const Value.absent(),
    Value<int?> linkedTransactionId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SavingsTransactionEntity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    savingsId: savingsId ?? this.savingsId,
    type: type ?? this.type,
    amountInCents: amountInCents ?? this.amountInCents,
    currency: currency ?? this.currency,
    transactionDate: transactionDate ?? this.transactionDate,
    notes: notes.present ? notes.value : this.notes,
    units: units.present ? units.value : this.units,
    pricePerUnitInCents: pricePerUnitInCents.present
        ? pricePerUnitInCents.value
        : this.pricePerUnitInCents,
    isRecurring: isRecurring ?? this.isRecurring,
    recurringTransactionId: recurringTransactionId.present
        ? recurringTransactionId.value
        : this.recurringTransactionId,
    linkedTransactionId: linkedTransactionId.present
        ? linkedTransactionId.value
        : this.linkedTransactionId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavingsTransactionEntity copyWithCompanion(
    SavingsTransactionsCompanion data,
  ) {
    return SavingsTransactionEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      savingsId: data.savingsId.present ? data.savingsId.value : this.savingsId,
      type: data.type.present ? data.type.value : this.type,
      amountInCents: data.amountInCents.present
          ? data.amountInCents.value
          : this.amountInCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      units: data.units.present ? data.units.value : this.units,
      pricePerUnitInCents: data.pricePerUnitInCents.present
          ? data.pricePerUnitInCents.value
          : this.pricePerUnitInCents,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      recurringTransactionId: data.recurringTransactionId.present
          ? data.recurringTransactionId.value
          : this.recurringTransactionId,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTransactionEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('savingsId: $savingsId, ')
          ..write('type: $type, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('units: $units, ')
          ..write('pricePerUnitInCents: $pricePerUnitInCents, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringTransactionId: $recurringTransactionId, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    savingsId,
    type,
    amountInCents,
    currency,
    transactionDate,
    notes,
    units,
    pricePerUnitInCents,
    isRecurring,
    recurringTransactionId,
    linkedTransactionId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsTransactionEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.savingsId == this.savingsId &&
          other.type == this.type &&
          other.amountInCents == this.amountInCents &&
          other.currency == this.currency &&
          other.transactionDate == this.transactionDate &&
          other.notes == this.notes &&
          other.units == this.units &&
          other.pricePerUnitInCents == this.pricePerUnitInCents &&
          other.isRecurring == this.isRecurring &&
          other.recurringTransactionId == this.recurringTransactionId &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavingsTransactionsCompanion
    extends UpdateCompanion<SavingsTransactionEntity> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> savingsId;
  final Value<SavingsTransactionType> type;
  final Value<int> amountInCents;
  final Value<String> currency;
  final Value<DateTime> transactionDate;
  final Value<String?> notes;
  final Value<double?> units;
  final Value<int?> pricePerUnitInCents;
  final Value<bool> isRecurring;
  final Value<int?> recurringTransactionId;
  final Value<int?> linkedTransactionId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SavingsTransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.savingsId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountInCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.units = const Value.absent(),
    this.pricePerUnitInCents = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringTransactionId = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SavingsTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int savingsId,
    required SavingsTransactionType type,
    required int amountInCents,
    this.currency = const Value.absent(),
    required DateTime transactionDate,
    this.notes = const Value.absent(),
    this.units = const Value.absent(),
    this.pricePerUnitInCents = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringTransactionId = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       savingsId = Value(savingsId),
       type = Value(type),
       amountInCents = Value(amountInCents),
       transactionDate = Value(transactionDate);
  static Insertable<SavingsTransactionEntity> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? savingsId,
    Expression<int>? type,
    Expression<int>? amountInCents,
    Expression<String>? currency,
    Expression<DateTime>? transactionDate,
    Expression<String>? notes,
    Expression<double>? units,
    Expression<int>? pricePerUnitInCents,
    Expression<bool>? isRecurring,
    Expression<int>? recurringTransactionId,
    Expression<int>? linkedTransactionId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (savingsId != null) 'savings_id': savingsId,
      if (type != null) 'type': type,
      if (amountInCents != null) 'amount_in_cents': amountInCents,
      if (currency != null) 'currency': currency,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (notes != null) 'notes': notes,
      if (units != null) 'units': units,
      if (pricePerUnitInCents != null)
        'price_per_unit_in_cents': pricePerUnitInCents,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringTransactionId != null)
        'recurring_transaction_id': recurringTransactionId,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SavingsTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? savingsId,
    Value<SavingsTransactionType>? type,
    Value<int>? amountInCents,
    Value<String>? currency,
    Value<DateTime>? transactionDate,
    Value<String?>? notes,
    Value<double?>? units,
    Value<int?>? pricePerUnitInCents,
    Value<bool>? isRecurring,
    Value<int?>? recurringTransactionId,
    Value<int?>? linkedTransactionId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SavingsTransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      savingsId: savingsId ?? this.savingsId,
      type: type ?? this.type,
      amountInCents: amountInCents ?? this.amountInCents,
      currency: currency ?? this.currency,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      units: units ?? this.units,
      pricePerUnitInCents: pricePerUnitInCents ?? this.pricePerUnitInCents,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringTransactionId:
          recurringTransactionId ?? this.recurringTransactionId,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (savingsId.present) {
      map['savings_id'] = Variable<int>(savingsId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $SavingsTransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amountInCents.present) {
      map['amount_in_cents'] = Variable<int>(amountInCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (pricePerUnitInCents.present) {
      map['price_per_unit_in_cents'] = Variable<int>(pricePerUnitInCents.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringTransactionId.present) {
      map['recurring_transaction_id'] = Variable<int>(
        recurringTransactionId.value,
      );
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] = Variable<int>(linkedTransactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('savingsId: $savingsId, ')
          ..write('type: $type, ')
          ..write('amountInCents: $amountInCents, ')
          ..write('currency: $currency, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('units: $units, ')
          ..write('pricePerUnitInCents: $pricePerUnitInCents, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringTransactionId: $recurringTransactionId, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetCategoriesTable budgetCategories = $BudgetCategoriesTable(
    this,
  );
  late final $GoalsTable goals = $GoalsTable(this);
  late final $RecurringTransactionsTable recurringTransactions =
      $RecurringTransactionsTable(this);
  late final $SavingsTable savings = $SavingsTable(this);
  late final $SavingsTransactionsTable savingsTransactions =
      $SavingsTransactionsTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final TransactionsDao transactionsDao = TransactionsDao(
    this as AppDatabase,
  );
  late final RecurringTransactionsDao recurringTransactionsDao =
      RecurringTransactionsDao(this as AppDatabase);
  late final SavingsDao savingsDao = SavingsDao(this as AppDatabase);
  late final SavingsTransactionsDao savingsTransactionsDao =
      SavingsTransactionsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    accounts,
    categories,
    transactions,
    budgets,
    budgetCategories,
    goals,
    recurringTransactions,
    savings,
    savingsTransactions,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String uid,
      required String email,
      Value<String?> displayName,
      Value<String?> phoneNumber,
      Value<String?> photoUrl,
      Value<String> currency,
      Value<String> language,
      Value<bool> biometricEnabled,
      Value<bool> notificationsEnabled,
      Value<String?> timezone,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> uid,
      Value<String> email,
      Value<String?> displayName,
      Value<String?> phoneNumber,
      Value<String?> photoUrl,
      Value<String> currency,
      Value<String> language,
      Value<bool> biometricEnabled,
      Value<bool> notificationsEnabled,
      Value<String?> timezone,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserEntity,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
          UserEntity,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                uid: uid,
                email: email,
                displayName: displayName,
                phoneNumber: phoneNumber,
                photoUrl: photoUrl,
                currency: currency,
                language: language,
                biometricEnabled: biometricEnabled,
                notificationsEnabled: notificationsEnabled,
                timezone: timezone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uid,
                required String email,
                Value<String?> displayName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                uid: uid,
                email: email,
                displayName: displayName,
                phoneNumber: phoneNumber,
                photoUrl: photoUrl,
                currency: currency,
                language: language,
                biometricEnabled: biometricEnabled,
                notificationsEnabled: notificationsEnabled,
                timezone: timezone,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserEntity,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
      UserEntity,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required int userId,
      required String name,
      required AccountType type,
      Value<int> balanceInCents,
      Value<String> currency,
      Value<String?> color,
      Value<String?> icon,
      Value<String?> accountNumber,
      Value<String?> bankName,
      Value<bool> isDefault,
      Value<bool> isActive,
      Value<bool> includeInTotal,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> displayOrder,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> name,
      Value<AccountType> type,
      Value<int> balanceInCents,
      Value<String> currency,
      Value<String?> color,
      Value<String?> icon,
      Value<String?> accountNumber,
      Value<String?> bankName,
      Value<bool> isDefault,
      Value<bool> isActive,
      Value<bool> includeInTotal,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> displayOrder,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get balanceInCents => $composableBuilder(
    column: $table.balanceInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includeInTotal => $composableBuilder(
    column: $table.includeInTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceInCents => $composableBuilder(
    column: $table.balanceInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeInTotal => $composableBuilder(
    column: $table.includeInTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get balanceInCents => $composableBuilder(
    column: $table.balanceInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get includeInTotal => $composableBuilder(
    column: $table.includeInTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountEntity,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountEntity,
            BaseReferences<_$AppDatabase, $AccountsTable, AccountEntity>,
          ),
          AccountEntity,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<int> balanceInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> includeInTotal = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                userId: userId,
                name: name,
                type: type,
                balanceInCents: balanceInCents,
                currency: currency,
                color: color,
                icon: icon,
                accountNumber: accountNumber,
                bankName: bankName,
                isDefault: isDefault,
                isActive: isActive,
                includeInTotal: includeInTotal,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                displayOrder: displayOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String name,
                required AccountType type,
                Value<int> balanceInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> includeInTotal = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                type: type,
                balanceInCents: balanceInCents,
                currency: currency,
                color: color,
                icon: icon,
                accountNumber: accountNumber,
                bankName: bankName,
                isDefault: isDefault,
                isActive: isActive,
                includeInTotal: includeInTotal,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                displayOrder: displayOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountEntity,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (
        AccountEntity,
        BaseReferences<_$AppDatabase, $AccountsTable, AccountEntity>,
      ),
      AccountEntity,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required int userId,
      required String name,
      required CategoryType type,
      Value<int?> parentId,
      Value<String?> color,
      Value<String?> icon,
      Value<int?> budgetLimitInCents,
      Value<bool> isSystem,
      Value<bool> isActive,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> name,
      Value<CategoryType> type,
      Value<int?> parentId,
      Value<String?> color,
      Value<String?> icon,
      Value<int?> budgetLimitInCents,
      Value<bool> isSystem,
      Value<bool> isActive,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryType, CategoryType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetLimitInCents => $composableBuilder(
    column: $table.budgetLimitInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetLimitInCents => $composableBuilder(
    column: $table.budgetLimitInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get budgetLimitInCents => $composableBuilder(
    column: $table.budgetLimitInCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryEntity,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryEntity,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoryEntity>,
          ),
          CategoryEntity,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryType> type = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int?> budgetLimitInCents = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                userId: userId,
                name: name,
                type: type,
                parentId: parentId,
                color: color,
                icon: icon,
                budgetLimitInCents: budgetLimitInCents,
                isSystem: isSystem,
                isActive: isActive,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String name,
                required CategoryType type,
                Value<int?> parentId = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int?> budgetLimitInCents = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                type: type,
                parentId: parentId,
                color: color,
                icon: icon,
                budgetLimitInCents: budgetLimitInCents,
                isSystem: isSystem,
                isActive: isActive,
                displayOrder: displayOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryEntity,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryEntity,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoryEntity>,
      ),
      CategoryEntity,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required int userId,
      required int accountId,
      Value<int?> categoryId,
      required TransactionType type,
      Value<TransactionStatus> status,
      required int amountInCents,
      Value<String> currency,
      required String description,
      Value<String?> notes,
      required DateTime transactionDate,
      Value<String?> payee,
      Value<String?> location,
      Value<String?> tags,
      Value<String?> attachmentUrl,
      Value<int?> toAccountId,
      Value<bool> isRecurring,
      Value<int?> recurringTransactionId,
      Value<String?> externalId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> accountId,
      Value<int?> categoryId,
      Value<TransactionType> type,
      Value<TransactionStatus> status,
      Value<int> amountInCents,
      Value<String> currency,
      Value<String> description,
      Value<String?> notes,
      Value<DateTime> transactionDate,
      Value<String?> payee,
      Value<String?> location,
      Value<String?> tags,
      Value<String?> attachmentUrl,
      Value<int?> toAccountId,
      Value<bool> isRecurring,
      Value<int?> recurringTransactionId,
      Value<String?> externalId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionStatus, TransactionStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentUrl => $composableBuilder(
    column: $table.attachmentUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurringTransactionId => $composableBuilder(
    column: $table.recurringTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentUrl => $composableBuilder(
    column: $table.attachmentUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurringTransactionId => $composableBuilder(
    column: $table.recurringTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get attachmentUrl => $composableBuilder(
    column: $table.attachmentUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get toAccountId => $composableBuilder(
    column: $table.toAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recurringTransactionId => $composableBuilder(
    column: $table.recurringTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionEntity,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionEntity,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTable,
              TransactionEntity
            >,
          ),
          TransactionEntity,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<TransactionType> type = const Value.absent(),
                Value<TransactionStatus> status = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> attachmentUrl = const Value.absent(),
                Value<int?> toAccountId = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<int?> recurringTransactionId = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                userId: userId,
                accountId: accountId,
                categoryId: categoryId,
                type: type,
                status: status,
                amountInCents: amountInCents,
                currency: currency,
                description: description,
                notes: notes,
                transactionDate: transactionDate,
                payee: payee,
                location: location,
                tags: tags,
                attachmentUrl: attachmentUrl,
                toAccountId: toAccountId,
                isRecurring: isRecurring,
                recurringTransactionId: recurringTransactionId,
                externalId: externalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int accountId,
                Value<int?> categoryId = const Value.absent(),
                required TransactionType type,
                Value<TransactionStatus> status = const Value.absent(),
                required int amountInCents,
                Value<String> currency = const Value.absent(),
                required String description,
                Value<String?> notes = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> payee = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> attachmentUrl = const Value.absent(),
                Value<int?> toAccountId = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<int?> recurringTransactionId = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                userId: userId,
                accountId: accountId,
                categoryId: categoryId,
                type: type,
                status: status,
                amountInCents: amountInCents,
                currency: currency,
                description: description,
                notes: notes,
                transactionDate: transactionDate,
                payee: payee,
                location: location,
                tags: tags,
                attachmentUrl: attachmentUrl,
                toAccountId: toAccountId,
                isRecurring: isRecurring,
                recurringTransactionId: recurringTransactionId,
                externalId: externalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionEntity,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionEntity,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionEntity>,
      ),
      TransactionEntity,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      required int userId,
      required String name,
      required int amountInCents,
      Value<String> currency,
      required BudgetPeriod period,
      required DateTime startDate,
      required DateTime endDate,
      Value<bool> rollover,
      Value<int> alertThreshold,
      Value<bool> alertsEnabled,
      Value<bool> isActive,
      Value<String?> color,
      Value<String?> icon,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> name,
      Value<int> amountInCents,
      Value<String> currency,
      Value<BudgetPeriod> period,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<bool> rollover,
      Value<int> alertThreshold,
      Value<bool> alertsEnabled,
      Value<bool> isActive,
      Value<String?> color,
      Value<String?> icon,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BudgetPeriod, BudgetPeriod, int> get period =>
      $composableBuilder(
        column: $table.period,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alertThreshold => $composableBuilder(
    column: $table.alertThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alertThreshold => $composableBuilder(
    column: $table.alertThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BudgetPeriod, int> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get rollover =>
      $composableBuilder(column: $table.rollover, builder: (column) => column);

  GeneratedColumn<int> get alertThreshold => $composableBuilder(
    column: $table.alertThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alertsEnabled => $composableBuilder(
    column: $table.alertsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetEntity,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (
            BudgetEntity,
            BaseReferences<_$AppDatabase, $BudgetsTable, BudgetEntity>,
          ),
          BudgetEntity,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<BudgetPeriod> period = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<bool> rollover = const Value.absent(),
                Value<int> alertThreshold = const Value.absent(),
                Value<bool> alertsEnabled = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                userId: userId,
                name: name,
                amountInCents: amountInCents,
                currency: currency,
                period: period,
                startDate: startDate,
                endDate: endDate,
                rollover: rollover,
                alertThreshold: alertThreshold,
                alertsEnabled: alertsEnabled,
                isActive: isActive,
                color: color,
                icon: icon,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String name,
                required int amountInCents,
                Value<String> currency = const Value.absent(),
                required BudgetPeriod period,
                required DateTime startDate,
                required DateTime endDate,
                Value<bool> rollover = const Value.absent(),
                Value<int> alertThreshold = const Value.absent(),
                Value<bool> alertsEnabled = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                amountInCents: amountInCents,
                currency: currency,
                period: period,
                startDate: startDate,
                endDate: endDate,
                rollover: rollover,
                alertThreshold: alertThreshold,
                alertsEnabled: alertsEnabled,
                isActive: isActive,
                color: color,
                icon: icon,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetEntity,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (
        BudgetEntity,
        BaseReferences<_$AppDatabase, $BudgetsTable, BudgetEntity>,
      ),
      BudgetEntity,
      PrefetchHooks Function()
    >;
typedef $$BudgetCategoriesTableCreateCompanionBuilder =
    BudgetCategoriesCompanion Function({
      Value<int> id,
      required int budgetId,
      required int categoryId,
      required int allocatedAmountInCents,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BudgetCategoriesTableUpdateCompanionBuilder =
    BudgetCategoriesCompanion Function({
      Value<int> id,
      Value<int> budgetId,
      Value<int> categoryId,
      Value<int> allocatedAmountInCents,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BudgetCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allocatedAmountInCents => $composableBuilder(
    column: $table.allocatedAmountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocatedAmountInCents => $composableBuilder(
    column: $table.allocatedAmountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allocatedAmountInCents => $composableBuilder(
    column: $table.allocatedAmountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCategoriesTable,
          BudgetCategoryEntity,
          $$BudgetCategoriesTableFilterComposer,
          $$BudgetCategoriesTableOrderingComposer,
          $$BudgetCategoriesTableAnnotationComposer,
          $$BudgetCategoriesTableCreateCompanionBuilder,
          $$BudgetCategoriesTableUpdateCompanionBuilder,
          (
            BudgetCategoryEntity,
            BaseReferences<
              _$AppDatabase,
              $BudgetCategoriesTable,
              BudgetCategoryEntity
            >,
          ),
          BudgetCategoryEntity,
          PrefetchHooks Function()
        > {
  $$BudgetCategoriesTableTableManager(
    _$AppDatabase db,
    $BudgetCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> budgetId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> allocatedAmountInCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetCategoriesCompanion(
                id: id,
                budgetId: budgetId,
                categoryId: categoryId,
                allocatedAmountInCents: allocatedAmountInCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int budgetId,
                required int categoryId,
                required int allocatedAmountInCents,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BudgetCategoriesCompanion.insert(
                id: id,
                budgetId: budgetId,
                categoryId: categoryId,
                allocatedAmountInCents: allocatedAmountInCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCategoriesTable,
      BudgetCategoryEntity,
      $$BudgetCategoriesTableFilterComposer,
      $$BudgetCategoriesTableOrderingComposer,
      $$BudgetCategoriesTableAnnotationComposer,
      $$BudgetCategoriesTableCreateCompanionBuilder,
      $$BudgetCategoriesTableUpdateCompanionBuilder,
      (
        BudgetCategoryEntity,
        BaseReferences<
          _$AppDatabase,
          $BudgetCategoriesTable,
          BudgetCategoryEntity
        >,
      ),
      BudgetCategoryEntity,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      Value<int> id,
      required int userId,
      required String name,
      Value<String?> description,
      required int targetAmountInCents,
      Value<int> currentAmountInCents,
      Value<String> currency,
      required DateTime targetDate,
      Value<GoalStatus> status,
      Value<int?> accountId,
      Value<int?> monthlyContributionInCents,
      Value<bool> autoSaveEnabled,
      Value<int?> autoSavePercentage,
      Value<int> priority,
      Value<String?> color,
      Value<String?> icon,
      Value<String?> imageUrl,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> name,
      Value<String?> description,
      Value<int> targetAmountInCents,
      Value<int> currentAmountInCents,
      Value<String> currency,
      Value<DateTime> targetDate,
      Value<GoalStatus> status,
      Value<int?> accountId,
      Value<int?> monthlyContributionInCents,
      Value<bool> autoSaveEnabled,
      Value<int?> autoSavePercentage,
      Value<int> priority,
      Value<String?> color,
      Value<String?> icon,
      Value<String?> imageUrl,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
    });

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmountInCents => $composableBuilder(
    column: $table.targetAmountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentAmountInCents => $composableBuilder(
    column: $table.currentAmountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalStatus, GoalStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyContributionInCents => $composableBuilder(
    column: $table.monthlyContributionInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSaveEnabled => $composableBuilder(
    column: $table.autoSaveEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoSavePercentage => $composableBuilder(
    column: $table.autoSavePercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmountInCents => $composableBuilder(
    column: $table.targetAmountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAmountInCents => $composableBuilder(
    column: $table.currentAmountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyContributionInCents => $composableBuilder(
    column: $table.monthlyContributionInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSaveEnabled => $composableBuilder(
    column: $table.autoSaveEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoSavePercentage => $composableBuilder(
    column: $table.autoSavePercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetAmountInCents => $composableBuilder(
    column: $table.targetAmountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentAmountInCents => $composableBuilder(
    column: $table.currentAmountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GoalStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get monthlyContributionInCents => $composableBuilder(
    column: $table.monthlyContributionInCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoSaveEnabled => $composableBuilder(
    column: $table.autoSaveEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoSavePercentage => $composableBuilder(
    column: $table.autoSavePercentage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalEntity,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalEntity, BaseReferences<_$AppDatabase, $GoalsTable, GoalEntity>),
          GoalEntity,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> targetAmountInCents = const Value.absent(),
                Value<int> currentAmountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<GoalStatus> status = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int?> monthlyContributionInCents = const Value.absent(),
                Value<bool> autoSaveEnabled = const Value.absent(),
                Value<int?> autoSavePercentage = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                userId: userId,
                name: name,
                description: description,
                targetAmountInCents: targetAmountInCents,
                currentAmountInCents: currentAmountInCents,
                currency: currency,
                targetDate: targetDate,
                status: status,
                accountId: accountId,
                monthlyContributionInCents: monthlyContributionInCents,
                autoSaveEnabled: autoSaveEnabled,
                autoSavePercentage: autoSavePercentage,
                priority: priority,
                color: color,
                icon: icon,
                imageUrl: imageUrl,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String name,
                Value<String?> description = const Value.absent(),
                required int targetAmountInCents,
                Value<int> currentAmountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                required DateTime targetDate,
                Value<GoalStatus> status = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int?> monthlyContributionInCents = const Value.absent(),
                Value<bool> autoSaveEnabled = const Value.absent(),
                Value<int?> autoSavePercentage = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                description: description,
                targetAmountInCents: targetAmountInCents,
                currentAmountInCents: currentAmountInCents,
                currency: currency,
                targetDate: targetDate,
                status: status,
                accountId: accountId,
                monthlyContributionInCents: monthlyContributionInCents,
                autoSaveEnabled: autoSaveEnabled,
                autoSavePercentage: autoSavePercentage,
                priority: priority,
                color: color,
                icon: icon,
                imageUrl: imageUrl,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalEntity,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalEntity, BaseReferences<_$AppDatabase, $GoalsTable, GoalEntity>),
      GoalEntity,
      PrefetchHooks Function()
    >;
typedef $$RecurringTransactionsTableCreateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      Value<int> id,
      required int userId,
      required int accountId,
      Value<int?> categoryId,
      required int type,
      required int amountInCents,
      Value<String> currency,
      required String description,
      required RecurrenceFrequency frequency,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required DateTime nextOccurrence,
      Value<DateTime?> lastOccurrence,
      Value<bool> isActive,
      Value<bool> autoCreate,
      Value<int> daysBeforeToCreate,
      Value<String?> payee,
      Value<String?> notes,
      Value<bool> enableNotifications,
      Value<int> notificationMinutesBefore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$RecurringTransactionsTableUpdateCompanionBuilder =
    RecurringTransactionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> accountId,
      Value<int?> categoryId,
      Value<int> type,
      Value<int> amountInCents,
      Value<String> currency,
      Value<String> description,
      Value<RecurrenceFrequency> frequency,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<DateTime> nextOccurrence,
      Value<DateTime?> lastOccurrence,
      Value<bool> isActive,
      Value<bool> autoCreate,
      Value<int> daysBeforeToCreate,
      Value<String?> payee,
      Value<String?> notes,
      Value<bool> enableNotifications,
      Value<int> notificationMinutesBefore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$RecurringTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecurrenceFrequency, RecurrenceFrequency, int>
  get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextOccurrence => $composableBuilder(
    column: $table.nextOccurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOccurrence => $composableBuilder(
    column: $table.lastOccurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCreate => $composableBuilder(
    column: $table.autoCreate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysBeforeToCreate => $composableBuilder(
    column: $table.daysBeforeToCreate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableNotifications => $composableBuilder(
    column: $table.enableNotifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationMinutesBefore => $composableBuilder(
    column: $table.notificationMinutesBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextOccurrence => $composableBuilder(
    column: $table.nextOccurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOccurrence => $composableBuilder(
    column: $table.lastOccurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCreate => $composableBuilder(
    column: $table.autoCreate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysBeforeToCreate => $composableBuilder(
    column: $table.daysBeforeToCreate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableNotifications => $composableBuilder(
    column: $table.enableNotifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationMinutesBefore => $composableBuilder(
    column: $table.notificationMinutesBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RecurrenceFrequency, int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextOccurrence => $composableBuilder(
    column: $table.nextOccurrence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastOccurrence => $composableBuilder(
    column: $table.lastOccurrence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get autoCreate => $composableBuilder(
    column: $table.autoCreate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysBeforeToCreate => $composableBuilder(
    column: $table.daysBeforeToCreate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get enableNotifications => $composableBuilder(
    column: $table.enableNotifications,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationMinutesBefore => $composableBuilder(
    column: $table.notificationMinutesBefore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurringTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransactionEntity,
          $$RecurringTransactionsTableFilterComposer,
          $$RecurringTransactionsTableOrderingComposer,
          $$RecurringTransactionsTableAnnotationComposer,
          $$RecurringTransactionsTableCreateCompanionBuilder,
          $$RecurringTransactionsTableUpdateCompanionBuilder,
          (
            RecurringTransactionEntity,
            BaseReferences<
              _$AppDatabase,
              $RecurringTransactionsTable,
              RecurringTransactionEntity
            >,
          ),
          RecurringTransactionEntity,
          PrefetchHooks Function()
        > {
  $$RecurringTransactionsTableTableManager(
    _$AppDatabase db,
    $RecurringTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<RecurrenceFrequency> frequency = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime> nextOccurrence = const Value.absent(),
                Value<DateTime?> lastOccurrence = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> autoCreate = const Value.absent(),
                Value<int> daysBeforeToCreate = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> enableNotifications = const Value.absent(),
                Value<int> notificationMinutesBefore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringTransactionsCompanion(
                id: id,
                userId: userId,
                accountId: accountId,
                categoryId: categoryId,
                type: type,
                amountInCents: amountInCents,
                currency: currency,
                description: description,
                frequency: frequency,
                startDate: startDate,
                endDate: endDate,
                nextOccurrence: nextOccurrence,
                lastOccurrence: lastOccurrence,
                isActive: isActive,
                autoCreate: autoCreate,
                daysBeforeToCreate: daysBeforeToCreate,
                payee: payee,
                notes: notes,
                enableNotifications: enableNotifications,
                notificationMinutesBefore: notificationMinutesBefore,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int accountId,
                Value<int?> categoryId = const Value.absent(),
                required int type,
                required int amountInCents,
                Value<String> currency = const Value.absent(),
                required String description,
                required RecurrenceFrequency frequency,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required DateTime nextOccurrence,
                Value<DateTime?> lastOccurrence = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> autoCreate = const Value.absent(),
                Value<int> daysBeforeToCreate = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> enableNotifications = const Value.absent(),
                Value<int> notificationMinutesBefore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RecurringTransactionsCompanion.insert(
                id: id,
                userId: userId,
                accountId: accountId,
                categoryId: categoryId,
                type: type,
                amountInCents: amountInCents,
                currency: currency,
                description: description,
                frequency: frequency,
                startDate: startDate,
                endDate: endDate,
                nextOccurrence: nextOccurrence,
                lastOccurrence: lastOccurrence,
                isActive: isActive,
                autoCreate: autoCreate,
                daysBeforeToCreate: daysBeforeToCreate,
                payee: payee,
                notes: notes,
                enableNotifications: enableNotifications,
                notificationMinutesBefore: notificationMinutesBefore,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringTransactionsTable,
      RecurringTransactionEntity,
      $$RecurringTransactionsTableFilterComposer,
      $$RecurringTransactionsTableOrderingComposer,
      $$RecurringTransactionsTableAnnotationComposer,
      $$RecurringTransactionsTableCreateCompanionBuilder,
      $$RecurringTransactionsTableUpdateCompanionBuilder,
      (
        RecurringTransactionEntity,
        BaseReferences<
          _$AppDatabase,
          $RecurringTransactionsTable,
          RecurringTransactionEntity
        >,
      ),
      RecurringTransactionEntity,
      PrefetchHooks Function()
    >;
typedef $$SavingsTableCreateCompanionBuilder =
    SavingsCompanion Function({
      Value<int> id,
      required int userId,
      required SavingsCategory category,
      required String name,
      required int currentValueInCents,
      required int investedAmountInCents,
      Value<String> currency,
      Value<DateTime?> maturityDate,
      Value<int?> interestRate,
      Value<String?> accountNumber,
      Value<String?> institutionName,
      Value<String?> notes,
      Value<bool> isActive,
      Value<String?> color,
      Value<String?> icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SavingsTableUpdateCompanionBuilder =
    SavingsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<SavingsCategory> category,
      Value<String> name,
      Value<int> currentValueInCents,
      Value<int> investedAmountInCents,
      Value<String> currency,
      Value<DateTime?> maturityDate,
      Value<int?> interestRate,
      Value<String?> accountNumber,
      Value<String?> institutionName,
      Value<String?> notes,
      Value<bool> isActive,
      Value<String?> color,
      Value<String?> icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$SavingsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsTable> {
  $$SavingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SavingsCategory, SavingsCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentValueInCents => $composableBuilder(
    column: $table.currentValueInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get investedAmountInCents => $composableBuilder(
    column: $table.investedAmountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get maturityDate => $composableBuilder(
    column: $table.maturityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsTable> {
  $$SavingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentValueInCents => $composableBuilder(
    column: $table.currentValueInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get investedAmountInCents => $composableBuilder(
    column: $table.investedAmountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get maturityDate => $composableBuilder(
    column: $table.maturityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsTable> {
  $$SavingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SavingsCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get currentValueInCents => $composableBuilder(
    column: $table.currentValueInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get investedAmountInCents => $composableBuilder(
    column: $table.investedAmountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get maturityDate => $composableBuilder(
    column: $table.maturityDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumber => $composableBuilder(
    column: $table.accountNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SavingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsTable,
          SavingsEntity,
          $$SavingsTableFilterComposer,
          $$SavingsTableOrderingComposer,
          $$SavingsTableAnnotationComposer,
          $$SavingsTableCreateCompanionBuilder,
          $$SavingsTableUpdateCompanionBuilder,
          (
            SavingsEntity,
            BaseReferences<_$AppDatabase, $SavingsTable, SavingsEntity>,
          ),
          SavingsEntity,
          PrefetchHooks Function()
        > {
  $$SavingsTableTableManager(_$AppDatabase db, $SavingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<SavingsCategory> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> currentValueInCents = const Value.absent(),
                Value<int> investedAmountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime?> maturityDate = const Value.absent(),
                Value<int?> interestRate = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsCompanion(
                id: id,
                userId: userId,
                category: category,
                name: name,
                currentValueInCents: currentValueInCents,
                investedAmountInCents: investedAmountInCents,
                currency: currency,
                maturityDate: maturityDate,
                interestRate: interestRate,
                accountNumber: accountNumber,
                institutionName: institutionName,
                notes: notes,
                isActive: isActive,
                color: color,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required SavingsCategory category,
                required String name,
                required int currentValueInCents,
                required int investedAmountInCents,
                Value<String> currency = const Value.absent(),
                Value<DateTime?> maturityDate = const Value.absent(),
                Value<int?> interestRate = const Value.absent(),
                Value<String?> accountNumber = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsCompanion.insert(
                id: id,
                userId: userId,
                category: category,
                name: name,
                currentValueInCents: currentValueInCents,
                investedAmountInCents: investedAmountInCents,
                currency: currency,
                maturityDate: maturityDate,
                interestRate: interestRate,
                accountNumber: accountNumber,
                institutionName: institutionName,
                notes: notes,
                isActive: isActive,
                color: color,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsTable,
      SavingsEntity,
      $$SavingsTableFilterComposer,
      $$SavingsTableOrderingComposer,
      $$SavingsTableAnnotationComposer,
      $$SavingsTableCreateCompanionBuilder,
      $$SavingsTableUpdateCompanionBuilder,
      (
        SavingsEntity,
        BaseReferences<_$AppDatabase, $SavingsTable, SavingsEntity>,
      ),
      SavingsEntity,
      PrefetchHooks Function()
    >;
typedef $$SavingsTransactionsTableCreateCompanionBuilder =
    SavingsTransactionsCompanion Function({
      Value<int> id,
      required int userId,
      required int savingsId,
      required SavingsTransactionType type,
      required int amountInCents,
      Value<String> currency,
      required DateTime transactionDate,
      Value<String?> notes,
      Value<double?> units,
      Value<int?> pricePerUnitInCents,
      Value<bool> isRecurring,
      Value<int?> recurringTransactionId,
      Value<int?> linkedTransactionId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$SavingsTransactionsTableUpdateCompanionBuilder =
    SavingsTransactionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> savingsId,
      Value<SavingsTransactionType> type,
      Value<int> amountInCents,
      Value<String> currency,
      Value<DateTime> transactionDate,
      Value<String?> notes,
      Value<double?> units,
      Value<int?> pricePerUnitInCents,
      Value<bool> isRecurring,
      Value<int?> recurringTransactionId,
      Value<int?> linkedTransactionId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$SavingsTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsTransactionsTable> {
  $$SavingsTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savingsId => $composableBuilder(
    column: $table.savingsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    SavingsTransactionType,
    SavingsTransactionType,
    int
  >
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pricePerUnitInCents => $composableBuilder(
    column: $table.pricePerUnitInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurringTransactionId => $composableBuilder(
    column: $table.recurringTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get linkedTransactionId => $composableBuilder(
    column: $table.linkedTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsTransactionsTable> {
  $$SavingsTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savingsId => $composableBuilder(
    column: $table.savingsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pricePerUnitInCents => $composableBuilder(
    column: $table.pricePerUnitInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurringTransactionId => $composableBuilder(
    column: $table.recurringTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get linkedTransactionId => $composableBuilder(
    column: $table.linkedTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsTransactionsTable> {
  $$SavingsTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get savingsId =>
      $composableBuilder(column: $table.savingsId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SavingsTransactionType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountInCents => $composableBuilder(
    column: $table.amountInCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<int> get pricePerUnitInCents => $composableBuilder(
    column: $table.pricePerUnitInCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recurringTransactionId => $composableBuilder(
    column: $table.recurringTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get linkedTransactionId => $composableBuilder(
    column: $table.linkedTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SavingsTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsTransactionsTable,
          SavingsTransactionEntity,
          $$SavingsTransactionsTableFilterComposer,
          $$SavingsTransactionsTableOrderingComposer,
          $$SavingsTransactionsTableAnnotationComposer,
          $$SavingsTransactionsTableCreateCompanionBuilder,
          $$SavingsTransactionsTableUpdateCompanionBuilder,
          (
            SavingsTransactionEntity,
            BaseReferences<
              _$AppDatabase,
              $SavingsTransactionsTable,
              SavingsTransactionEntity
            >,
          ),
          SavingsTransactionEntity,
          PrefetchHooks Function()
        > {
  $$SavingsTransactionsTableTableManager(
    _$AppDatabase db,
    $SavingsTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SavingsTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> savingsId = const Value.absent(),
                Value<SavingsTransactionType> type = const Value.absent(),
                Value<int> amountInCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> units = const Value.absent(),
                Value<int?> pricePerUnitInCents = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<int?> recurringTransactionId = const Value.absent(),
                Value<int?> linkedTransactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsTransactionsCompanion(
                id: id,
                userId: userId,
                savingsId: savingsId,
                type: type,
                amountInCents: amountInCents,
                currency: currency,
                transactionDate: transactionDate,
                notes: notes,
                units: units,
                pricePerUnitInCents: pricePerUnitInCents,
                isRecurring: isRecurring,
                recurringTransactionId: recurringTransactionId,
                linkedTransactionId: linkedTransactionId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int savingsId,
                required SavingsTransactionType type,
                required int amountInCents,
                Value<String> currency = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> notes = const Value.absent(),
                Value<double?> units = const Value.absent(),
                Value<int?> pricePerUnitInCents = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<int?> recurringTransactionId = const Value.absent(),
                Value<int?> linkedTransactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SavingsTransactionsCompanion.insert(
                id: id,
                userId: userId,
                savingsId: savingsId,
                type: type,
                amountInCents: amountInCents,
                currency: currency,
                transactionDate: transactionDate,
                notes: notes,
                units: units,
                pricePerUnitInCents: pricePerUnitInCents,
                isRecurring: isRecurring,
                recurringTransactionId: recurringTransactionId,
                linkedTransactionId: linkedTransactionId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsTransactionsTable,
      SavingsTransactionEntity,
      $$SavingsTransactionsTableFilterComposer,
      $$SavingsTransactionsTableOrderingComposer,
      $$SavingsTransactionsTableAnnotationComposer,
      $$SavingsTransactionsTableCreateCompanionBuilder,
      $$SavingsTransactionsTableUpdateCompanionBuilder,
      (
        SavingsTransactionEntity,
        BaseReferences<
          _$AppDatabase,
          $SavingsTransactionsTable,
          SavingsTransactionEntity
        >,
      ),
      SavingsTransactionEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$BudgetCategoriesTableTableManager get budgetCategories =>
      $$BudgetCategoriesTableTableManager(_db, _db.budgetCategories);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(_db, _db.recurringTransactions);
  $$SavingsTableTableManager get savings =>
      $$SavingsTableTableManager(_db, _db.savings);
  $$SavingsTransactionsTableTableManager get savingsTransactions =>
      $$SavingsTransactionsTableTableManager(_db, _db.savingsTransactions);
}
