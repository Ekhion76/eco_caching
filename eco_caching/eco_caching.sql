INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('coin_weapon', 'Fegyver érme', '1', '0', '1'),
('coin_car', 'Jármü érme', '1', '0', '1'),
('coin_shirt', 'Ruha érme', '1', '0', '1'),
('coin_property', 'Ingatlan érme', '1', '0', '1');


CREATE TABLE IF NOT EXISTS `eco_caching_session` (
  `id` smallint(6) NOT NULL,
  `state_allocation` text DEFAULT NULL,
  `next_award` smallint(6) NOT NULL DEFAULT 1,
  `expire` datetime DEFAULT NULL,
  `active` enum('0','1') NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `eco_caching_session` (`id`, `state_allocation`, `next_award`, `expire`, `active`) VALUES
(1, '{\"1\":2,\"2\":2,\"3\":2,\"4\":2,\"5\":2,\"6\":2}', 1, NULL, '1'),
(2, '{\"10\":3}', 1, NULL, '0');

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `eco_caching_state` (
  `identifier` varchar(100) NOT NULL,
  `sid` smallint(6) NOT NULL,
  `zid` smallint(6) NOT NULL,
  `pid` smallint(6) NOT NULL,
  `state` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `eco_caching_stats` (
  `identifier` varchar(100) NOT NULL,
  `opened` smallint(6) NOT NULL DEFAULT 0,
  `hit` smallint(6) NOT NULL DEFAULT 0,
  `point` smallint(6) NOT NULL DEFAULT 0,
  `coin` smallint(6) NOT NULL DEFAULT 0,
  `event` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;