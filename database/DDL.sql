-- Citation:
-- Date: 8/2/2026
-- Adapted from the CS340 Project Step 4 RESET stored procedure example.
-- Source: OSU CS340 Project Step 4 assignment materials.

DROP PROCEDURE IF EXISTS sp_ResetGreenLeaf;

DELIMITER //

CREATE PROCEDURE sp_ResetGreenLeaf()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    -- Drop child tables before parent tables
    DROP TABLE IF EXISTS PlantCareLogs;
    DROP TABLE IF EXISTS Plants;
    DROP TABLE IF EXISTS Inventories;
    DROP TABLE IF EXISTS Locations;
    DROP TABLE IF EXISTS PlantSpecies;
    DROP TABLE IF EXISTS Users;

    CREATE TABLE Users (
        user_id INT NOT NULL AUTO_INCREMENT,
        username VARCHAR(150) NOT NULL,
        email VARCHAR(150) NOT NULL,
        password VARCHAR(255) NOT NULL,
        date_joined DATE NOT NULL,
        PRIMARY KEY (user_id),
        UNIQUE KEY username_UNIQUE (username),
        UNIQUE KEY email_UNIQUE (email)
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    CREATE TABLE PlantSpecies (
        species_id INT NOT NULL AUTO_INCREMENT,
        scientific_name VARCHAR(150) NOT NULL,
        common_name VARCHAR(150) NOT NULL,
        sunlight_type VARCHAR(150) NOT NULL,
        watering_frequency VARCHAR(150) NOT NULL,
        soil_type VARCHAR(150) NOT NULL,
        pet_safe TINYINT(1) DEFAULT NULL,
        PRIMARY KEY (species_id)
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    CREATE TABLE Locations (
        location_id INT NOT NULL AUTO_INCREMENT,
        location_name VARCHAR(100) NOT NULL,
        light_level VARCHAR(50) DEFAULT NULL,
        temperature_range VARCHAR(50) DEFAULT NULL,
        notes VARCHAR(255) DEFAULT NULL,
        user_id INT NOT NULL,
        PRIMARY KEY (location_id),
        KEY fk_Locations_Users_idx (user_id),
        CONSTRAINT fk_Locations_Users
            FOREIGN KEY (user_id)
            REFERENCES Users (user_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    CREATE TABLE Inventories (
        inventory_id INT NOT NULL AUTO_INCREMENT,
        product_name VARCHAR(150) NOT NULL,
        category VARCHAR(50) NOT NULL,
        manufacturer VARCHAR(100) DEFAULT NULL,
        qty_on_hand DECIMAL(10,2) NOT NULL,
        unit VARCHAR(25) NOT NULL,
        purchase_date DATE DEFAULT NULL,
        expiration_date DATE DEFAULT NULL,
        user_id INT NOT NULL,
        PRIMARY KEY (inventory_id),
        KEY fk_Inventories_Users_idx (user_id),
        CONSTRAINT fk_Inventories_Users
            FOREIGN KEY (user_id)
            REFERENCES Users (user_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    CREATE TABLE Plants (
        plant_id INT NOT NULL AUTO_INCREMENT,
        nickname VARCHAR(150) DEFAULT NULL,
        date_acquired DATE DEFAULT NULL,
        health_status VARCHAR(50) NOT NULL,
        user_id INT NOT NULL,
        species_id INT NOT NULL,
        location_id INT NOT NULL,
        PRIMARY KEY (plant_id),
        KEY fk_Plants_Users_idx (user_id),
        KEY fk_Plants_PlantSpecies_idx (species_id),
        KEY fk_Plants_Locations_idx (location_id),
        CONSTRAINT fk_Plants_Locations
            FOREIGN KEY (location_id)
            REFERENCES Locations (location_id)
            ON UPDATE CASCADE,
        CONSTRAINT fk_Plants_PlantSpecies
            FOREIGN KEY (species_id)
            REFERENCES PlantSpecies (species_id)
            ON UPDATE CASCADE,
        CONSTRAINT fk_Plants_Users
            FOREIGN KEY (user_id)
            REFERENCES Users (user_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    CREATE TABLE PlantCareLogs (
        carelog_id INT NOT NULL AUTO_INCREMENT,
        care_type VARCHAR(50) NOT NULL,
        date_performed DATE NOT NULL,
        amount_used DECIMAL(10,2) DEFAULT NULL,
        notes VARCHAR(255) DEFAULT NULL,
        inventory_id INT DEFAULT NULL,
        plant_id INT NOT NULL,
        PRIMARY KEY (carelog_id),
        KEY fk_PlantCareLogs_Inventories_idx (inventory_id),
        KEY fk_PlantCareLogs_Plants_idx (plant_id),
        CONSTRAINT fk_PlantCareLogs_Inventories
            FOREIGN KEY (inventory_id)
            REFERENCES Inventories (inventory_id)
            ON DELETE SET NULL
            ON UPDATE CASCADE,
        CONSTRAINT fk_PlantCareLogs_Plants
            FOREIGN KEY (plant_id)
            REFERENCES Plants (plant_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    /*
      Paste your sample INSERT statements here in this order:

      1. Users
      2. PlantSpecies
      3. Locations
      4. Inventories
      5. Plants
      6. PlantCareLogs
    */

    SET FOREIGN_KEY_CHECKS = 1;
END //

DELIMITER ;

CALL sp_ResetGreenLeaf();
