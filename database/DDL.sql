-- ============================================================================
-- GreenLeaf Plant Care Database
-- CS 340 Portfolio Project - Group 05
-- DDL.sql: Creates all database tables and inserts the original sample data.
-- Target DBMS: MariaDB / MySQL
--
-- Originality and assistance citation:
-- The GreenLeaf database design, entities, relationships, and original sample
-- data were created by the project team. This final DDL was reviewed and
-- with assistance from OpenAI ChatGPT on 2026-08-03. ChatGPT was
-- prompted to audit the Step 4 DDL against the Step 5 rubric in which it added
-- one extra insert to meet the rubric goals
-- Source: https://chatgpt.com/
-- ============================================================================

DROP PROCEDURE IF EXISTS sp_ResetGreenLeaf;

DELIMITER //

CREATE PROCEDURE sp_ResetGreenLeaf()
BEGIN
    -- Temporarily disable FK checks so the complete schema can be safely reset.
    SET FOREIGN_KEY_CHECKS = 0;

    -- Drop child tables before parent tables.
    DROP TABLE IF EXISTS PlantCareLogs;
    DROP TABLE IF EXISTS Plants;
    DROP TABLE IF EXISTS Inventories;
    DROP TABLE IF EXISTS Locations;
    DROP TABLE IF EXISTS PlantSpecies;
    DROP TABLE IF EXISTS Users;

    -- ========================================================================
    -- CREATE TABLES
    -- ========================================================================

    -- Stores registered application users.
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

    -- Stores reference information about plant species.
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

    -- Stores user-defined places where plants are kept.
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

    -- Stores plant-care products owned by each user.
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

    -- Stores individual plants and connects each plant to its owner, species,
    -- and current location.
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
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
        CONSTRAINT fk_Plants_PlantSpecies
            FOREIGN KEY (species_id)
            REFERENCES PlantSpecies (species_id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
        CONSTRAINT fk_Plants_Users
            FOREIGN KEY (user_id)
            REFERENCES Users (user_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    ) ENGINE=InnoDB
      DEFAULT CHARSET=utf8mb4
      COLLATE=utf8mb4_general_ci;

    -- Associative entity between Plants and Inventories. It records care events
    -- and supports the project's M:N insert, update, and delete operations.
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

    -- ========================================================================
    -- INSERT SAMPLE DATA
    -- Each table receives at least three rows. Foreign keys are populated with
    -- SELECT subqueries so the inserts do not depend on generated numeric IDs.
    -- ========================================================================

    INSERT INTO Users (username, email, password, date_joined)
    VALUES
        ('cs340_demo_user',
         'cs340_demo_user@example.com',
         'hashed_password_1',
         '2026-07-01'),
        ('cs340_demo_user2',
         'cs340_demo_user2@example.com',
         'hashed_password_2',
         '2026-07-02'),
        ('cs340_demo_user3',
         'cs340_demo_user3@example.com',
         'hashed_password_3',
         '2026-07-03');

    INSERT INTO PlantSpecies
        (scientific_name, common_name, sunlight_type,
         watering_frequency, soil_type, pet_safe)
    VALUES
        ('Monstera deliciosa',
         'Monstera',
         'Bright indirect light',
         'Every 7 to 10 days',
         'Well-draining tropical mix',
         0),
        ('Epipremnum aureum',
         'Golden Pothos',
         'Medium to bright indirect light',
         'When top inch of soil is dry',
         'Standard houseplant mix',
         0),
        ('Chlorophytum comosum',
         'Spider Plant',
         'Bright indirect light',
         'Every 7 days',
         'Well-draining potting mix',
         1);

    INSERT INTO Locations
        (location_name, light_level, temperature_range, notes, user_id)
    VALUES
        ('Living Room Window',
         'Bright',
         '65-75F',
         'South-facing window',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user')),
        ('Bedroom Shelf',
         'Medium',
         '65-72F',
         'Receives indirect afternoon light',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user')),
        ('Office Desk',
         'Medium',
         '68-75F',
         'Near an east-facing window',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user2'));

    INSERT INTO Inventories
        (product_name, category, manufacturer, qty_on_hand, unit,
         purchase_date, expiration_date, user_id)
    VALUES
        ('Indoor Plant Fertilizer',
         'Fertilizer',
         'GreenGrow',
         24.00,
         'oz',
         '2026-06-15',
         '2028-06-15',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user')),
        ('Organic Potting Mix',
         'Soil',
         'PlantWorks',
         10.00,
         'lb',
         '2026-06-20',
         NULL,
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user')),
        ('Neem Oil Spray',
         'Pest Control',
         'Garden Care',
         12.00,
         'oz',
         '2026-07-01',
         '2028-07-01',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user2'));

    INSERT INTO Plants
        (nickname, date_acquired, health_status,
         user_id, species_id, location_id)
    VALUES
        ('Monty',
         '2026-05-10',
         'Healthy',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user'),
         (SELECT species_id FROM PlantSpecies
          WHERE scientific_name = 'Monstera deliciosa'),
         (SELECT location_id FROM Locations
          WHERE location_name = 'Living Room Window'
            AND user_id = (SELECT user_id FROM Users
                           WHERE username = 'cs340_demo_user'))),
        ('Goldie',
         '2026-05-20',
         'Healthy',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user'),
         (SELECT species_id FROM PlantSpecies
          WHERE scientific_name = 'Epipremnum aureum'),
         (SELECT location_id FROM Locations
          WHERE location_name = 'Bedroom Shelf'
            AND user_id = (SELECT user_id FROM Users
                           WHERE username = 'cs340_demo_user'))),
        ('Charlotte',
         '2026-06-05',
         'Needs Attention',
         (SELECT user_id FROM Users
          WHERE username = 'cs340_demo_user2'),
         (SELECT species_id FROM PlantSpecies
          WHERE scientific_name = 'Chlorophytum comosum'),
         (SELECT location_id FROM Locations
          WHERE location_name = 'Office Desk'
            AND user_id = (SELECT user_id FROM Users
                           WHERE username = 'cs340_demo_user2')));

    INSERT INTO PlantCareLogs
        (care_type, date_performed, amount_used, notes,
         inventory_id, plant_id)
    VALUES
        ('Watering',
         '2026-07-20',
         16.00,
         'Soil was dry before watering',
         NULL,
         (SELECT plant_id FROM Plants WHERE nickname = 'Monty')),
        ('Fertilizing',
         '2026-07-22',
         1.00,
         'Used diluted indoor plant fertilizer',
         (SELECT inventory_id FROM Inventories
          WHERE product_name = 'Indoor Plant Fertilizer'
            AND user_id = (SELECT user_id FROM Users
                           WHERE username = 'cs340_demo_user')),
         (SELECT plant_id FROM Plants WHERE nickname = 'Goldie')),
        ('Pest Treatment',
         '2026-07-25',
         2.00,
         'Applied neem oil to affected leaves',
         (SELECT inventory_id FROM Inventories
          WHERE product_name = 'Neem Oil Spray'
            AND user_id = (SELECT user_id FROM Users
                           WHERE username = 'cs340_demo_user2')),
         (SELECT plant_id FROM Plants WHERE nickname = 'Charlotte'));

    SET FOREIGN_KEY_CHECKS = 1;
END //

DELIMITER ;

-- Build and seed the database when this file is imported.
CALL sp_ResetGreenLeaf();
