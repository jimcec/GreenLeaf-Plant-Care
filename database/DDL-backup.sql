-- Documentation-only snapshot of the current live OSU schema.
-- Do not execute in production without explicit approval.

CREATE TABLE `Users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `date_joined` date NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `PlantSpecies` (
  `species_id` int(11) NOT NULL AUTO_INCREMENT,
  `scientific_name` varchar(150) NOT NULL,
  `common_name` varchar(150) NOT NULL,
  `sunlight_type` varchar(150) NOT NULL,
  `watering_frequency` varchar(150) NOT NULL,
  `soil_type` varchar(150) NOT NULL,
  `pet_safe` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`species_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `Locations` (
  `location_id` int(11) NOT NULL AUTO_INCREMENT,
  `location_name` varchar(100) NOT NULL,
  `light_level` varchar(50) DEFAULT NULL,
  `temperature_range` varchar(50) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`location_id`),
  KEY `fk_Locations_Users_idx` (`user_id`),
  CONSTRAINT `fk_Locations_Users`
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `Inventories` (
  `inventory_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(150) NOT NULL,
  `category` varchar(50) NOT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `qty_on_hand` decimal(10,2) NOT NULL,
  `unit` varchar(25) NOT NULL,
  `purchase_date` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`inventory_id`),
  KEY `fk_Inventories_Users_idx` (`user_id`),
  CONSTRAINT `fk_Inventories_Users`
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `Plants` (
  `plant_id` int(11) NOT NULL AUTO_INCREMENT,
  `nickname` varchar(150) DEFAULT NULL,
  `date_acquired` date DEFAULT NULL,
  `health_status` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `species_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  PRIMARY KEY (`plant_id`),
  KEY `fk_Plants_Users_idx` (`user_id`),
  KEY `fk_Plants_PlantSpecies_idx` (`species_id`),
  KEY `fk_Plants_Locations_idx` (`location_id`),
  CONSTRAINT `fk_Plants_Locations`
    FOREIGN KEY (`location_id`) REFERENCES `Locations` (`location_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Plants_PlantSpecies`
    FOREIGN KEY (`species_id`) REFERENCES `PlantSpecies` (`species_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Plants_Users`
    FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `PlantCareLogs` (
  `carelog_id` int(11) NOT NULL AUTO_INCREMENT,
  `care_type` varchar(50) NOT NULL,
  `date_performed` date NOT NULL,
  `amount_used` decimal(10,2) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `inventory_id` int(11) DEFAULT NULL,
  `plant_id` int(11) NOT NULL,
  PRIMARY KEY (`carelog_id`),
  KEY `fk_PlantCareLogs_Inventories_idx` (`inventory_id`),
  KEY `fk_PlantCareLogs_Plants_idx` (`plant_id`),
  CONSTRAINT `fk_PlantCareLogs_Inventories`
    FOREIGN KEY (`inventory_id`) REFERENCES `Inventories` (`inventory_id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_PlantCareLogs_Plants`
    FOREIGN KEY (`plant_id`) REFERENCES `Plants` (`plant_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
