-- --------------------------------------------------------
-- Hostitel:                     10.42.0.0
-- Verze serveru:                11.7.2-MariaDB-ubu2404 - mariadb.org binary distribution
-- OS serveru:                   debian-linux-gnu
-- HeidiSQL Verze:               12.14.0.7165
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Exportování struktury pro tabulka westhaven_dev.aprts_ranch
CREATE TABLE IF NOT EXISTS `aprts_ranch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `owner` int(11) unsigned NOT NULL DEFAULT 0,
  `land_id` mediumint(8) unsigned NOT NULL,
  `money` float NOT NULL DEFAULT 0,
  `storage_id` mediumint(8) unsigned DEFAULT 0,
  `storage_limit` smallint(5) unsigned NOT NULL DEFAULT 200,
  `coords` longtext DEFAULT NULL CHECK (json_valid(`coords`)),
  KEY `Index 1` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportování dat pro tabulku westhaven_dev.aprts_ranch: ~1 rows (přibližně)
INSERT INTO `aprts_ranch` (`id`, `name`, `owner`, `land_id`, `money`, `storage_id`, `storage_limit`, `coords`) VALUES
	(60, 'Ranch', 11464, 400, 0, 60, 200, '{"x":2266.7919921875,"y":-117.99412536621094,"z":45.44279098510742}');

-- Exportování struktury pro tabulka westhaven_dev.aprts_ranch_animals
CREATE TABLE IF NOT EXISTS `aprts_ranch_animals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `breed` varchar(50) NOT NULL DEFAULT 'goat',
  `coords` longtext NOT NULL DEFAULT '{"x":0.0,"y":0.0,"z":0.0}',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `pregnantStart` timestamp NOT NULL DEFAULT current_timestamp(),
  `home` tinyint(4) NOT NULL DEFAULT 1,
  `railing_id` smallint(6) unsigned NOT NULL,
  `health` tinyint(4) unsigned NOT NULL DEFAULT 100,
  `food` smallint(6) unsigned NOT NULL DEFAULT 100,
  `water` smallint(6) unsigned NOT NULL DEFAULT 100,
  `clean` tinyint(4) unsigned NOT NULL DEFAULT 100,
  `sick` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `happynes` tinyint(4) unsigned NOT NULL DEFAULT 100,
  `energy` tinyint(4) unsigned NOT NULL DEFAULT 100,
  `age` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `quality` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `count` tinyint(4) unsigned NOT NULL DEFAULT 0,
  `born` timestamp NOT NULL DEFAULT current_timestamp(),
  `meta` longtext NOT NULL DEFAULT '{}',
  `xp` int(10) unsigned DEFAULT 0,
  `pregnant` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0',
  `updated` timestamp NOT NULL DEFAULT current_timestamp(),
  KEY `Index 1` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9666 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportování dat pro tabulku westhaven_dev.aprts_ranch_animals: ~4 rows (přibližně)
INSERT INTO `aprts_ranch_animals` (`id`, `name`, `breed`, `coords`, `gender`, `pregnantStart`, `home`, `railing_id`, `health`, `food`, `water`, `clean`, `sick`, `happynes`, `energy`, `age`, `quality`, `count`, `born`, `meta`, `xp`, `pregnant`, `updated`) VALUES
	(9662, NULL, 'Cow', '{"z":44.57510757446289,"x":2282.58642578125,"y":-104.72209930419922}', 'female', '2026-03-01 18:17:52', 1, 144, 100, 600, 360, 100, 0, 100, 100, 3, 0, 0, '2026-02-26 18:17:52', '{"0":{"tint2":250,"tint1":52,"material":-667963364,"normal":760197005,"albedo":-1806420525,"tint0":250,"palette":-1698476236,"drawable":-1115349945},"1":{"tint2":250,"tint1":52,"material":548325497,"normal":110873230,"albedo":1698394103,"tint0":250,"palette":-1698476236,"drawable":-1879759348},"2":{"tint2":0,"tint1":0,"material":638149596,"normal":2052081986,"albedo":-1037131122,"tint0":0,"palette":0,"drawable":326871613},"3":{"tint2":0,"tint1":0,"material":306254280,"normal":-1314262808,"albedo":-101812692,"tint0":0,"palette":0,"drawable":1790324566},"4":{"tint2":0,"tint1":0,"material":-108011865,"normal":-862272152,"albedo":1498002260,"tint0":0,"palette":0,"drawable":-1156889980}}', 0, 0, '2026-03-01 18:48:05'),
	(9663, NULL, 'Cow', '{"z":44.57510757446289,"x":2282.58642578125,"y":-104.72209930419922}', 'female', '2026-03-01 18:18:02', 1, 144, 100, 600, 360, 100, 0, 100, 100, 3, 0, 0, '2026-02-26 18:17:52', '{"0":{"tint2":224,"tint1":52,"material":-667963364,"normal":760197005,"albedo":-1806420525,"tint0":224,"palette":-1698476236,"drawable":-1115349945},"1":{"tint2":224,"tint1":52,"material":548325497,"normal":110873230,"albedo":1698394103,"tint0":224,"palette":-1698476236,"drawable":-1879759348},"2":{"tint2":0,"tint1":0,"material":638149596,"normal":2052081986,"albedo":-1037131122,"tint0":0,"palette":0,"drawable":326871613},"3":{"tint2":0,"tint1":0,"material":306254280,"normal":-1314262808,"albedo":-101812692,"tint0":0,"palette":0,"drawable":1790324566},"4":{"tint2":0,"tint1":0,"material":-108011865,"normal":-862272152,"albedo":1498002260,"tint0":0,"palette":0,"drawable":-1156889980}}', 0, 0, '2026-03-01 18:48:05'),
	(9664, NULL, 'Cow', '{"z":44.57510757446289,"y":-104.72209930419922,"x":2282.58642578125}', 'female', '2026-03-01 18:18:12', 1, 144, 100, 600, 360, 100, 0, 100, 100, 3, 0, 0, '2026-02-26 18:17:52', '{"2":{"albedo":-1037131122,"drawable":326871613,"material":638149596,"tint2":0,"tint1":0,"normal":2052081986,"tint0":0,"palette":0},"1":{"albedo":1698394103,"drawable":-1879759348,"material":548325497,"tint2":222,"tint1":223,"normal":110873230,"tint0":221,"palette":-1698476236},"4":{"albedo":1498002260,"drawable":-1156889980,"material":-108011865,"tint2":0,"tint1":0,"normal":-862272152,"tint0":0,"palette":0},"3":{"albedo":-101812692,"drawable":2020395715,"material":306254280,"tint2":0,"tint1":0,"normal":-1314262808,"tint0":0,"palette":0},"0":{"albedo":-1806420525,"drawable":-1115349945,"material":-667963364,"tint2":222,"tint1":223,"normal":760197005,"tint0":221,"palette":-1698476236}}', 0, 0, '2026-03-01 18:42:38'),
	(9665, NULL, 'Cow', '{"z":44.57510757446289,"x":2282.58642578125,"y":-104.72209930419922}', 'female', '2026-03-01 18:18:22', 1, 144, 100, 600, 360, 100, 0, 100, 100, 3, 0, 0, '2026-02-26 18:17:52', '{"0":{"tint2":251,"tint1":250,"material":-667963364,"normal":760197005,"albedo":-1806420525,"tint0":252,"palette":-1698476236,"drawable":-1115349945},"1":{"tint2":251,"tint1":250,"material":548325497,"normal":110873230,"albedo":1698394103,"tint0":252,"palette":-1698476236,"drawable":-1879759348},"2":{"tint2":0,"tint1":0,"material":638149596,"normal":2052081986,"albedo":-1037131122,"tint0":0,"palette":0,"drawable":326871613},"3":{"tint2":0,"tint1":0,"material":-145420153,"normal":1441016197,"albedo":1188826765,"tint0":0,"palette":-1436165981,"drawable":-1826409215},"4":{"tint2":0,"tint1":0,"material":306254280,"normal":-1314262808,"albedo":-101812692,"tint0":0,"palette":0,"drawable":2020395715},"5":{"tint2":0,"tint1":0,"material":-108011865,"normal":-862272152,"albedo":-1946025859,"tint0":0,"palette":0,"drawable":-1156889980}}', 0, 0, '2026-03-01 18:48:05');

-- Exportování struktury pro tabulka westhaven_dev.aprts_ranch_config_animal_products
CREATE TABLE IF NOT EXISTS `aprts_ranch_config_animal_products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `animal_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `prop` varchar(255) DEFAULT NULL,
  `gather` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `maxAmount` int(11) DEFAULT NULL,
  `lifetime` int(11) NOT NULL,
  `tool` varchar(255) DEFAULT NULL,
  `anim` longtext DEFAULT NULL CHECK (json_valid(`anim`)),
  `chance` int(11) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `animal_id` (`animal_id`),
  CONSTRAINT `aprts_ranch_config_animal_products_ibfk_1` FOREIGN KEY (`animal_id`) REFERENCES `aprts_ranch_config_animals` (`animal_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportování dat pro tabulku westhaven_dev.aprts_ranch_config_animal_products: ~24 rows (přibližně)
INSERT INTO `aprts_ranch_config_animal_products` (`product_id`, `animal_id`, `name`, `item`, `prop`, `gather`, `amount`, `maxAmount`, `lifetime`, `tool`, `anim`, `chance`, `gender`) VALUES
	(1, 1, 'Kozí Mléko', 'animal_goat_milk', NULL, 2, 1, 15, 10800, 'tool_empty_bucket', '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, 'female'),
	(2, 1, 'Rohy', 'animal_horn', NULL, 1, 2, 2, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(3, 1, 'Zvířecí kůže', 'animal_pelt', NULL, 1, 2, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(4, 3, 'Vejce', 'animal_egg', 'p_egg01x', 3, 1, 30, 10800, 'tool_basket', '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 30, 'female'),
	(5, 3, 'Maso', 'animal_chicken_meat', NULL, 1, 10, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, NULL),
	(6, 3, 'Peří', 'animal_feathers', NULL, 1, 15, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, NULL),
	(7, 4, 'Vlna', 'animal_wool', NULL, 2, 1, 20, 10800, 'tool_scissors', '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, NULL),
	(8, 4, 'Rohy', 'animal_horn', NULL, 1, 2, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, 'male'),
	(9, 4, 'Maso', 'animal_meat', NULL, 1, 20, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, NULL),
	(10, 4, 'Vlna', 'animal_wool', NULL, 1, 10, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, NULL),
	(11, 5, 'Špíček', 'animal_fat', NULL, 1, 20, 50, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_b", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(12, 5, 'Maso', 'animal_boar_meat', NULL, 1, 30, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 60, NULL),
	(13, 2, 'Mléko', 'animal_milk', NULL, 2, 1, 40, 10800, 'tool_empty_bucket', '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, 'female'),
	(14, 2, 'Hovězí maso', 'animal_beef_meet', NULL, 1, 60, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(15, 2, 'Rohy', 'animal_horn', NULL, 1, 2, 2, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, 'male'),
	(16, 5, 'Štětiny', 'animal_pighair', NULL, 2, 1, 10, 10800, 'tool_scissors', '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(17, 1, 'Kosti', 'animal_bone', NULL, 1, 4, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(18, 2, 'Kosti', 'animal_bone', NULL, 1, 15, NULL, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(19, 3, 'Kosti', 'animal_bone', NULL, 1, 2, 2, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(20, 4, 'Kosti', 'animal_bone', NULL, 1, 4, 1, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(21, 5, 'Kosti', 'animal_bone', NULL, 1, 6, 1, 10800, NULL, '{"dict": "mech_animal_interaction@horse@left@brushing", "name": "idle_a", "time": 10000, "flag": 17, "type": "standard", "prop": null}', 100, NULL),
	(22, 1, 'Maso', 'animal_meat', NULL, 1, 10, 10, 0, NULL, '{"dict": "", "name": "", "time": 0, "flag": 0, "type": "", "prop": null}', 100, NULL),
	(24, 2, 'Hovězina', 'animal_beef_leather', NULL, 1, 10, NULL, 0, NULL, '{"dict": "", "name": "", "time": 0, "flag": 0, "type": "", "prop": null}', 100, NULL),
	(25, 5, 'Prasečí kůže', 'animal_pig_leather', NULL, 1, 3, 20, 0, NULL, '{"dict": "", "name": "", "time": 0, "flag": 0, "type": "", "prop": null}', 100, NULL);

-- Exportování struktury pro tabulka westhaven_dev.aprts_ranch_config_animals
CREATE TABLE IF NOT EXISTS `aprts_ranch_config_animals` (
  `animal_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `m_model` varchar(255) NOT NULL,
  `health` int(11) NOT NULL,
  `adultAge` int(11) NOT NULL,
  `WalkOnly` tinyint(1) NOT NULL,
  `offsetX` float NOT NULL,
  `offsetY` float NOT NULL,
  `offsetZ` float NOT NULL,
  `food` int(11) NOT NULL,
  `water` int(11) NOT NULL,
  `foodMax` int(11) NOT NULL,
  `waterMax` int(11) NOT NULL,
  `kibble` varchar(255) NOT NULL,
  `kibbleFood` int(11) NOT NULL,
  `poop` varchar(255) NOT NULL,
  `poopChance` float NOT NULL,
  `dieAge` int(11) NOT NULL,
  `pregnancyTime` int(11) NOT NULL,
  `pregnancyChance` int(11) NOT NULL,
  `noFuckTime` int(11) NOT NULL,
  PRIMARY KEY (`animal_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportování dat pro tabulku westhaven_dev.aprts_ranch_config_animals: ~5 rows (přibližně)
INSERT INTO `aprts_ranch_config_animals` (`animal_id`, `name`, `price`, `model`, `m_model`, `health`, `adultAge`, `WalkOnly`, `offsetX`, `offsetY`, `offsetZ`, `food`, `water`, `foodMax`, `waterMax`, `kibble`, `kibbleFood`, `poop`, `poopChance`, `dieAge`, `pregnancyTime`, `pregnancyChance`, `noFuckTime`) VALUES
	(1, 'Goat', 20, 'a_c_goat_01', 'a_c_bighornram_01', 100, 3, 0, 0, 2, 0, 2, 3, 70, 70, 'product_carrot', 14, 'p_poop01x', 0.1, 12, 1, 10, 1),
	(2, 'Cow', 50, 'a_c_cow', 'a_c_bull_01', 300, 5, 0, 0, 2, 0, 5, 5, 600, 360, 'animal_silage', 200, 's_horsepoop01x', 0.1, 20, 1, 10, 1),
	(3, 'Chicken1', 10, 'a_c_chicken_01', 'a_c_rooster_01', 50, 2, 0, 0, 2, 0, 1, 1, 30, 30, 'product_wheat', 10, 'p_poop01x', 0.09, 10, 1, 20, 1),
	(4, 'sheep', 25, 'a_c_sheep_01', 'mp_a_c_bighornram_01', 50, 2, 0, 0, 2, 0, 2, 2, 100, 100, 'product_grass', 14, 'p_sheeppoop01x', 0.09, 15, 1, 10, 1),
	(5, 'pig', 30, 'a_c_pig_01', 'a_c_pig_01', 50, 3, 0, 0, 2, 0, 2, 2, 120, 120, 'product_wheat', 30, 'p_sheeppoop01x', 0.6, 15, 1, 10, 1);

-- Exportování struktury pro tabulka westhaven_dev.aprts_ranch_poop
CREATE TABLE IF NOT EXISTS `aprts_ranch_poop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext NOT NULL DEFAULT '{}' CHECK (json_valid(`coords`)),
  `railing_id` int(11) NOT NULL DEFAULT 0,
  `prop` varchar(50) NOT NULL DEFAULT 'p_poop01x',
  KEY `Index 1` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87540 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportování dat pro tabulku westhaven_dev.aprts_ranch_poop: ~0 rows (přibližně)

-- Exportování struktury pro tabulka westhaven_dev.aprts_ranch_railing
CREATE TABLE IF NOT EXISTS `aprts_ranch_railing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ranch_id` int(10) unsigned NOT NULL DEFAULT 0,
  `food` int(10) unsigned NOT NULL DEFAULT 0,
  `water` int(10) unsigned NOT NULL DEFAULT 0,
  `shit` int(10) unsigned NOT NULL DEFAULT 0,
  `coords` longtext NOT NULL DEFAULT '{"x":0.0,"y":0.0,"z":0.0}',
  `size` int(11) unsigned NOT NULL DEFAULT 10,
  `prop` varchar(50) NOT NULL DEFAULT 'p_mp_feedbaghang01x',
  `products` longtext NOT NULL DEFAULT '[]',
  KEY `Index 1` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportování dat pro tabulku westhaven_dev.aprts_ranch_railing: ~2 rows (přibližně)
INSERT INTO `aprts_ranch_railing` (`id`, `ranch_id`, `food`, `water`, `shit`, `coords`, `size`, `prop`, `products`) VALUES
	(143, 60, 1000, 1000, 0, '{"x":2266.7919921875,"y":-117.99412536621094,"z":45.44279098510742}', 5, 'p_mp_feedbaghang01x', '[]'),
	(144, 60, 1000, 1000, 0, '{"x":2282.58642578125,"y":-104.72209930419922,"z":44.57510757446289}', 5, 'p_mp_feedbaghang01x', '[]');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
