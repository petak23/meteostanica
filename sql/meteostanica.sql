-- Adminer 4.8.1 MySQL 8.0.27-0ubuntu0.20.04.1 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `devices`;
CREATE TABLE `devices` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_slovak_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_slovak_ci DEFAULT NULL,
  `first_login` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_slovak_ci COMMENT='List of devices. Device has one or more Sensors.';

INSERT INTO `devices` (`id`, `name`, `description`, `first_login`, `last_login`) VALUES
(1,	'Obývačka DHT 22',	'Teplomer na okne v obývačke',	NULL,	NULL);

DROP TABLE IF EXISTS `main_menu`;
CREATE TABLE `main_menu` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '[A]Index',
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'Zobrazený názov položky',
  `link` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'Odkaz',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin COMMENT='Hlavné menu';

INSERT INTO `main_menu` (`id`, `name`, `link`) VALUES
(1,	'Zariadenia',	'Inventory:Home'),
(2,	'Kódy jednotiek',	'Inventory:Units');

DROP TABLE IF EXISTS `measures`;
CREATE TABLE `measures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_sensor` smallint NOT NULL,
  `data_time` datetime NOT NULL COMMENT 'timestamp of data recording',
  `server_time` datetime NOT NULL COMMENT 'timestamp where data has been received by server',
  `s_value` double NOT NULL COMMENT 'data measured (raw)',
  `out_value` double DEFAULT NULL COMMENT 'processed value',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0 = received, 1 = processed, 2 = exported',
  PRIMARY KEY (`id`),
  KEY `id_sensor` (`id_sensor`),
  CONSTRAINT `measures_ibfk_1` FOREIGN KEY (`id_sensor`) REFERENCES `sensors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_slovak_ci COMMENT='Recorded data - raw. SUMDATA are created from recorded data, and old data are deleted from MEASURES.';


DROP TABLE IF EXISTS `sensors`;
CREATE TABLE `sensors` (
  `id` smallint NOT NULL AUTO_INCREMENT,
  `id_device` smallint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_slovak_ci NOT NULL,
  `id_value_type` int NOT NULL,
  `description` varchar(256) CHARACTER SET utf8 COLLATE utf8_slovak_ci DEFAULT NULL,
  `last_data_time` datetime DEFAULT NULL,
  `last_out_value` double DEFAULT NULL,
  `imp_count` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_device_name` (`id_device`,`name`),
  KEY `id_value_type` (`id_value_type`),
  CONSTRAINT `sensors_ibfk_1` FOREIGN KEY (`id_device`) REFERENCES `devices` (`id`),
  CONSTRAINT `sensors_ibfk_2` FOREIGN KEY (`id_value_type`) REFERENCES `value_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_slovak_ci COMMENT='List of sensors. Each sensor is a part of one DEVICE.';

INSERT INTO `sensors` (`id`, `id_device`, `name`, `id_value_type`, `description`, `last_data_time`, `last_out_value`, `imp_count`) VALUES
(1,	1,	'Teplota',	1,	'Teplota vonku',	NULL,	NULL,	NULL),
(2,	1,	'Vlhkosť',	2,	'Vlhkosť vonku',	NULL,	NULL,	NULL);

DROP TABLE IF EXISTS `value_types`;
CREATE TABLE `value_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `unit` varchar(100) CHARACTER SET utf8 COLLATE utf8_slovak_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_slovak_ci COMMENT='Units for any kind of recorder values.';

INSERT INTO `value_types` (`id`, `unit`) VALUES
(1,	'°C'),
(2,	'%');

-- 2021-12-22 14:32:00
