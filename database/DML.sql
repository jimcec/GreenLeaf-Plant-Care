-- =============================================================
-- GreenLeaf Plant Care Database
-- CS 340 Portfolio Project - Data Manipulation Queries
-- Group 05
--
-- Purpose:
--   Documents the SELECT queries and stored-procedure calls used
--   by the GreenLeaf Plant Care web application.
--
-- Placeholder values beginning with a colon represent values
-- supplied by HTML forms or application route parameters.
--
-- AI ASSISTANCE CITATION
-- Date: 2026-08-03
-- Tool: OpenAI ChatGPT
-- Scope: Organization, comments, placeholder naming, and conversion
-- of the project's documented INSERT, UPDATE, DELETE, and RESET
-- operations into stored-procedure calls matching PL.sql.
-- Originality: The project team(James and Cameron) designed the GreenLeaf database,
-- entities, relationships, application behavior, and original SQL
-- operations. AI assistance was used to reorganize the DML file and
-- align it with the final stored procedures and server-side routes.
-- Prompt summary: Revise the GreenLeaf DML file so its SELECT
-- queries and stored-procedure calls match app.js and PL.sql.
-- Source: https://chatgpt.com/
-- =============================================================


-- =============================================================
-- USERS
-- =============================================================

-- READ/BROWSE/DISPLAY Users
SELECT
    user_id,
    username,
    email,
    password,
    date_joined
FROM Users;

-- CREATE/INSERT User
CALL sp_CreateUser(
    :usernameInput,
    :emailInput,
    :passwordInput,
    :dateJoinedInput
);

-- UPDATE/EDIT User
CALL sp_UpdateUser(
    :userIDInput,
    :usernameInput,
    :emailInput,
    :passwordInput
);

-- DELETE User
CALL sp_DeleteUser(
    :userIDInput
);


-- =============================================================
-- PLANT SPECIES
-- =============================================================

-- READ/BROWSE/DISPLAY Plant Species
SELECT *
FROM PlantSpecies;

-- CREATE/INSERT Plant Species
CALL sp_CreatePlantSpecies(
    :scientificNameInput,
    :commonNameInput,
    :sunlightTypeInput,
    :wateringFrequencyInput,
    :soilTypeInput,
    :petSafeInput
);

-- UPDATE/EDIT Plant Species
CALL sp_UpdatePlantSpecies(
    :speciesIDInput,
    :scientificNameInput,
    :commonNameInput
);

-- DELETE Plant Species
CALL sp_DeletePlantSpecies(
    :speciesIDInput
);


-- =============================================================
-- LOCATIONS
-- =============================================================

-- READ/BROWSE/DISPLAY Locations
SELECT *
FROM Locations;

-- Populate the Users dropdown on the Locations page
SELECT
    user_id,
    username
FROM Users;

-- CREATE/INSERT Location
CALL sp_CreateLocation(
    :locationNameInput,
    :lightLevelInput,
    :temperatureRangeInput,
    :notesInput,
    :userIDInput
);

-- UPDATE/EDIT Location
CALL sp_UpdateLocation(
    :locationIDInput,
    :locationNameInput,
    :lightLevelInput,
    :temperatureRangeInput,
    :notesInput,
    :userIDInput
);

-- DELETE Location
CALL sp_DeleteLocation(
    :locationIDInput
);


-- =============================================================
-- INVENTORIES
-- =============================================================

-- READ/BROWSE/DISPLAY Inventories
SELECT *
FROM Inventories;

-- Populate the Users dropdown on the Inventories page
SELECT
    user_id,
    username
FROM Users;

-- CREATE/INSERT Inventory Item
CALL sp_CreateInventory(
    :productNameInput,
    :categoryInput,
    :manufacturerInput,
    :quantityInput,
    :unitInput,
    :purchaseDateInput,
    :expirationDateInput,
    :userIDInput
);

-- UPDATE/EDIT Inventory Item
CALL sp_UpdateInventory(
    :inventoryIDInput,
    :productNameInput,
    :categoryInput,
    :manufacturerInput,
    :quantityInput,
    :unitInput,
    :purchaseDateInput,
    :expirationDateInput,
    :userIDInput
);

-- DELETE Inventory Item
CALL sp_DeleteInventory(
    :inventoryIDInput
);


-- =============================================================
-- PLANTS
-- =============================================================

-- READ/BROWSE/DISPLAY Plants
SELECT *
FROM Plants;

-- Populate the Users dropdown on the Plants page
SELECT
    user_id,
    username
FROM Users;

-- Populate the Plant Species dropdown on the Plants page
SELECT
    species_id,
    common_name
FROM PlantSpecies;

-- Populate the Locations dropdown on the Plants page
SELECT
    location_id,
    location_name
FROM Locations;

-- CREATE/INSERT Plant
CALL sp_CreatePlant(
    :nicknameInput,
    :dateAcquiredInput,
    :healthStatusInput,
    :userIDInput,
    :speciesIDInput,
    :locationIDInput
);

-- UPDATE/EDIT Plant
CALL sp_UpdatePlant(
    :plantIDInput,
    :nicknameInput,
    :dateAcquiredInput,
    :healthStatusInput,
    :userIDInput,
    :speciesIDInput,
    :locationIDInput
);

-- DELETE Plant
CALL sp_DeletePlant(
    :plantIDInput
);


-- =============================================================
-- PLANT CARE LOGS
-- Associative entity for the Plants–Inventories M:N relationship
-- =============================================================

-- READ/BROWSE/DISPLAY Plant Care Logs
SELECT *
FROM PlantCareLogs;

-- Populate the Inventory dropdown on the Plant Care Logs page
SELECT
    inventory_id,
    product_name
FROM Inventories;

-- Populate the Plants dropdown on the Plant Care Logs page
SELECT
    plant_id,
    nickname
FROM Plants;

-- CREATE/INSERT a Plant–Inventory relationship
CALL sp_CreatePlantCareLog(
    :careTypeInput,
    :datePerformedInput,
    :amountUsedInput,
    :notesInput,
    :inventoryIDInput,
    :plantIDInput
);

-- UPDATE/EDIT the Plant–Inventory M:N relationship
-- Changing inventoryIDInput or plantIDInput changes a foreign key
-- in the associative table.
CALL sp_UpdatePlantCareLog(
    :careLogIDInput,
    :careTypeInput,
    :datePerformedInput,
    :amountUsedInput,
    :notesInput,
    :inventoryIDInput,
    :plantIDInput
);

-- DELETE a Plant–Inventory M:N relationship
CALL sp_DeletePlantCareLog(
    :careLogIDInput
);


-- =============================================================
-- RESET DATABASE
-- =============================================================

-- Restore every table and its sample data to the original state
CALL sp_ResetDatabase();
