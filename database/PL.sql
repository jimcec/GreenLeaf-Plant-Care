-- =============================================================
-- GreenLeaf Plant Care Database
-- CS 340 Portfolio Project - Procedural Language Queries
-- Group 05
--
-- Purpose:
--   Defines the stored procedures used by the GreenLeaf web
--   application for CREATE, UPDATE, DELETE, M:N relationship
--   maintenance, and database reset operations.
--
-- AI ASSISTANCE CITATION
-- NONE
-- =============================================================

-- Remove old definitions so this file can be imported repeatedly.
DROP PROCEDURE IF EXISTS sp_CreateUser;
DROP PROCEDURE IF EXISTS sp_UpdateUser;
DROP PROCEDURE IF EXISTS sp_DeleteUser;
DROP PROCEDURE IF EXISTS sp_CreatePlantSpecies;
DROP PROCEDURE IF EXISTS sp_UpdatePlantSpecies;
DROP PROCEDURE IF EXISTS sp_DeletePlantSpecies;
DROP PROCEDURE IF EXISTS sp_CreateLocation;
DROP PROCEDURE IF EXISTS sp_UpdateLocation;
DROP PROCEDURE IF EXISTS sp_DeleteLocation;
DROP PROCEDURE IF EXISTS sp_CreateInventory;
DROP PROCEDURE IF EXISTS sp_UpdateInventory;
DROP PROCEDURE IF EXISTS sp_DeleteInventory;
DROP PROCEDURE IF EXISTS sp_CreatePlant;
DROP PROCEDURE IF EXISTS sp_UpdatePlant;
DROP PROCEDURE IF EXISTS sp_DeletePlant;
DROP PROCEDURE IF EXISTS sp_CreatePlantCareLog;
DROP PROCEDURE IF EXISTS sp_UpdatePlantCareLog;
DROP PROCEDURE IF EXISTS sp_DeletePlantCareLog;
DROP PROCEDURE IF EXISTS sp_ResetDatabase;

DELIMITER //

-- =============================================================
-- USERS: CREATE, UPDATE, DELETE
-- =============================================================

CREATE PROCEDURE sp_CreateUser(
    IN p_username VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_password VARCHAR(255),
    IN p_date_joined DATE
)
BEGIN
    INSERT INTO Users (username, email, password, date_joined)
    VALUES (p_username, p_email, p_password, p_date_joined);
END //

CREATE PROCEDURE sp_UpdateUser(
    IN p_user_id INT,
    IN p_username VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_password VARCHAR(255)
)
BEGIN
    UPDATE Users
    SET username = p_username,
        email = p_email,
        password = p_password
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE sp_DeleteUser(IN p_user_id INT)
BEGIN
    DELETE FROM Users
    WHERE user_id = p_user_id;
END //

-- =============================================================
-- PLANT SPECIES: CREATE, UPDATE, DELETE
-- =============================================================

CREATE PROCEDURE sp_CreatePlantSpecies(
    IN p_scientific_name VARCHAR(150),
    IN p_common_name VARCHAR(150),
    IN p_sunlight_type VARCHAR(150),
    IN p_watering_frequency VARCHAR(150),
    IN p_soil_type VARCHAR(150),
    IN p_pet_safe TINYINT
)
BEGIN
    INSERT INTO PlantSpecies (
        scientific_name,
        common_name,
        sunlight_type,
        watering_frequency,
        soil_type,
        pet_safe
    )
    VALUES (
        p_scientific_name,
        p_common_name,
        p_sunlight_type,
        p_watering_frequency,
        p_soil_type,
        p_pet_safe
    );
END //

CREATE PROCEDURE sp_UpdatePlantSpecies(
    IN p_species_id INT,
    IN p_scientific_name VARCHAR(150),
    IN p_common_name VARCHAR(150)
)
BEGIN
    UPDATE PlantSpecies
    SET scientific_name = p_scientific_name,
        common_name = p_common_name
    WHERE species_id = p_species_id;
END //

CREATE PROCEDURE sp_DeletePlantSpecies(IN p_species_id INT)
BEGIN
    DELETE FROM PlantSpecies
    WHERE species_id = p_species_id;
END //

-- =============================================================
-- LOCATIONS: CREATE, UPDATE, DELETE
-- =============================================================

CREATE PROCEDURE sp_CreateLocation(
    IN p_location_name VARCHAR(100),
    IN p_light_level VARCHAR(50),
    IN p_temperature_range VARCHAR(50),
    IN p_notes VARCHAR(255),
    IN p_user_id INT
)
BEGIN
    INSERT INTO Locations (
        location_name,
        light_level,
        temperature_range,
        notes,
        user_id
    )
    VALUES (
        p_location_name,
        p_light_level,
        p_temperature_range,
        p_notes,
        p_user_id
    );
END //

CREATE PROCEDURE sp_UpdateLocation(
    IN p_location_id INT,
    IN p_location_name VARCHAR(100),
    IN p_light_level VARCHAR(50),
    IN p_temperature_range VARCHAR(50),
    IN p_notes VARCHAR(255),
    IN p_user_id INT
)
BEGIN
    UPDATE Locations
    SET location_name = p_location_name,
        light_level = p_light_level,
        temperature_range = p_temperature_range,
        notes = p_notes,
        user_id = p_user_id
    WHERE location_id = p_location_id;
END //

CREATE PROCEDURE sp_DeleteLocation(IN p_location_id INT)
BEGIN
    DELETE FROM Locations
    WHERE location_id = p_location_id;
END //

-- =============================================================
-- INVENTORIES: CREATE, UPDATE, DELETE
-- =============================================================

CREATE PROCEDURE sp_CreateInventory(
    IN p_product_name VARCHAR(150),
    IN p_category VARCHAR(50),
    IN p_manufacturer VARCHAR(100),
    IN p_qty_on_hand DECIMAL(10,2),
    IN p_unit VARCHAR(25),
    IN p_purchase_date DATE,
    IN p_expiration_date DATE,
    IN p_user_id INT
)
BEGIN
    INSERT INTO Inventories (
        product_name,
        category,
        manufacturer,
        qty_on_hand,
        unit,
        purchase_date,
        expiration_date,
        user_id
    )
    VALUES (
        p_product_name,
        p_category,
        p_manufacturer,
        p_qty_on_hand,
        p_unit,
        p_purchase_date,
        p_expiration_date,
        p_user_id
    );
END //

CREATE PROCEDURE sp_UpdateInventory(
    IN p_inventory_id INT,
    IN p_product_name VARCHAR(150),
    IN p_category VARCHAR(50),
    IN p_manufacturer VARCHAR(100),
    IN p_qty_on_hand DECIMAL(10,2),
    IN p_unit VARCHAR(25),
    IN p_purchase_date DATE,
    IN p_expiration_date DATE,
    IN p_user_id INT
)
BEGIN
    UPDATE Inventories
    SET product_name = p_product_name,
        category = p_category,
        manufacturer = p_manufacturer,
        qty_on_hand = p_qty_on_hand,
        unit = p_unit,
        purchase_date = p_purchase_date,
        expiration_date = p_expiration_date,
        user_id = p_user_id
    WHERE inventory_id = p_inventory_id;
END //

CREATE PROCEDURE sp_DeleteInventory(IN p_inventory_id INT)
BEGIN
    DELETE FROM Inventories
    WHERE inventory_id = p_inventory_id;
END //

-- =============================================================
-- PLANTS: CREATE, UPDATE, DELETE
-- =============================================================

CREATE PROCEDURE sp_CreatePlant(
    IN p_nickname VARCHAR(150),
    IN p_date_acquired DATE,
    IN p_health_status VARCHAR(50),
    IN p_user_id INT,
    IN p_species_id INT,
    IN p_location_id INT
)
BEGIN
    INSERT INTO Plants (
        nickname,
        date_acquired,
        health_status,
        user_id,
        species_id,
        location_id
    )
    VALUES (
        p_nickname,
        p_date_acquired,
        p_health_status,
        p_user_id,
        p_species_id,
        p_location_id
    );
END //

CREATE PROCEDURE sp_UpdatePlant(
    IN p_plant_id INT,
    IN p_nickname VARCHAR(150),
    IN p_date_acquired DATE,
    IN p_health_status VARCHAR(50),
    IN p_user_id INT,
    IN p_species_id INT,
    IN p_location_id INT
)
BEGIN
    UPDATE Plants
    SET nickname = p_nickname,
        date_acquired = p_date_acquired,
        health_status = p_health_status,
        user_id = p_user_id,
        species_id = p_species_id,
        location_id = p_location_id
    WHERE plant_id = p_plant_id;
END //

CREATE PROCEDURE sp_DeletePlant(IN p_plant_id INT)
BEGIN
    DELETE FROM Plants
    WHERE plant_id = p_plant_id;
END //

-- =============================================================
-- PLANT CARE LOGS: CREATE, UPDATE M:N, DELETE M:N
--
-- PlantCareLogs is the associative entity connecting Plants and
-- Inventories. Updating plant_id or inventory_id changes the M:N
-- relationship; deleting a row removes one relationship instance.
-- =============================================================

CREATE PROCEDURE sp_CreatePlantCareLog(
    IN p_care_type VARCHAR(50),
    IN p_date_performed DATE,
    IN p_amount_used DECIMAL(10,2),
    IN p_notes VARCHAR(255),
    IN p_inventory_id INT,
    IN p_plant_id INT
)
BEGIN
    INSERT INTO PlantCareLogs (
        care_type,
        date_performed,
        amount_used,
        notes,
        inventory_id,
        plant_id
    )
    VALUES (
        p_care_type,
        p_date_performed,
        p_amount_used,
        p_notes,
        p_inventory_id,
        p_plant_id
    );
END //

CREATE PROCEDURE sp_UpdatePlantCareLog(
    IN p_carelog_id INT,
    IN p_care_type VARCHAR(50),
    IN p_date_performed DATE,
    IN p_amount_used DECIMAL(10,2),
    IN p_notes VARCHAR(255),
    IN p_inventory_id INT,
    IN p_plant_id INT
)
BEGIN
    UPDATE PlantCareLogs
    SET care_type = p_care_type,
        date_performed = p_date_performed,
        amount_used = p_amount_used,
        notes = p_notes,
        inventory_id = p_inventory_id,
        plant_id = p_plant_id
    WHERE carelog_id = p_carelog_id;
END //

CREATE PROCEDURE sp_DeletePlantCareLog(IN p_carelog_id INT)
BEGIN
    DELETE FROM PlantCareLogs
    WHERE carelog_id = p_carelog_id;
END //

-- =============================================================
-- RESET DATABASE
--
-- The complete reset implementation is defined as sp_ResetGreenLeaf
-- in DDL.sql because it recreates the schema and restores sample data.
-- This procedure is the PL.sql reset entry point used by the website.
-- =============================================================

CREATE PROCEDURE sp_ResetDatabase()
BEGIN
    CALL sp_ResetGreenLeaf();
END //

DELIMITER ;
