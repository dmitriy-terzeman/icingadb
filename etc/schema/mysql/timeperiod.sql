SET sql_mode = 'STRICT_ALL_TABLES,NO_ENGINE_SUBSTITUTION';
SET innodb_strict_mode = 1;

CREATE TABLE timeperiod (
  id binary(20) NOT NULL COMMENT 'sha1(env.name + name)',
  env_id binary(20) NOT NULL COMMENT 'env.id',

  name_checksum binary(20) NOT NULL COMMENT 'sha1(name)',
  ranges_checksum binary(20) NOT NULL COMMENT 'sha1(ranges from timeperiod_ranges where timeperiod_range.timeperiod_id = id)',
  properties_checksum binary(20) NOT NULL COMMENT 'sha1(all properties)',
  customvars_checksum binary(20) NOT NULL COMMENT 'sha1(timeperiod.vars)',
  includes_checksum binary(20) NOT NULL COMMENT 'sha1(includes)',
  excludes_checksum binary(20) NOT NULL COMMENT 'sha1(excludes)',

  name varchar(255) NOT NULL,
  name_ci varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  display_name varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  prefer_includes enum('y','n') NOT NULL,

  zone_id binary(20) DEFAULT NULL COMMENT 'zone.id',

  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE timeperiod_range (
  timeperiod_id binary(20) NOT NULL COMMENT 'timeperiod.id',
  range_key varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  env_id binary(20) NOT NULL COMMENT 'env.id',

  range_value varchar(255) NOT NULL,

  PRIMARY KEY (timeperiod_id,range_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE timeperiod_override (
  timeperiod_id binary(20) NOT NULL COMMENT 'timeperiod.id',
  override_id binary(20) NOT NULL COMMENT 'timeperiod.id',
  env_id binary(20) NOT NULL COMMENT 'env.id',

  override_type enum('include','exclude') NOT NULL,

  PRIMARY KEY (timeperiod_id,override_id,override_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

CREATE TABLE timeperiod_customvar (
  timeperiod_id binary(20) NOT NULL COMMENT 'timeperiod.id',
  customvar_id binary(20) NOT NULL COMMENT 'customvar.id',
  env_id binary(20) DEFAULT NULL COMMENT 'sha1(environment.name)',
  PRIMARY KEY (customvar_id, timeperiod_id)
) ENGINE=InnoDb ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_bin;