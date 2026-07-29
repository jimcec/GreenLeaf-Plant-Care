-- USERS

-- Create a user
INSERT INTO Users
(username, email, password)
VALUES
(:usernameInput, :emailInput, :passwordInput);

-- Read users (password intentionally excluded)
SELECT
    user_id,
    username,
    email,
    date_joined
FROM Users
ORDER BY user_id;

-- Update a user
UPDATE Users
SET username = :usernameInput,
    email = :emailInput
WHERE user_id = :userIDInput;

-- Delete a user
DELETE FROM Users
WHERE user_id = :userIDInput;


-- PLANT SPECIES

-- Create a species
INSERT INTO PlantSpecies
(common_name, scientific_name, sunlight_type, watering_frequency, soil_type, pet_safe)
VALUES
(:commonNameInput,
 :scientificNameInput,
 :sunlightTypeInput,
 :wateringFrequencyInput,
 :soilTypeInput,
 :petSafeInput);

-- Read species (API aliases shown for frontend compatibility)
SELECT
    species_id,
    common_name,
    scientific_name,
    watering_frequency AS watering_needs,
    sunlight_type AS sunlight_requirements,
    soil_type,
    pet_safe
FROM PlantSpecies
ORDER BY species_id;

-- Update a species
UPDATE PlantSpecies
SET common_name = :commonNameInput,
    scientific_name = :scientificNameInput,
    sunlight_type = :sunlightTypeInput,
    watering_frequency = :wateringFrequencyInput,
    soil_type = :soilTypeInput,
    pet_safe = :petSafeInput
WHERE species_id = :speciesIDInput;

-- Delete a species
DELETE FROM PlantSpecies
WHERE species_id = :speciesIDInput;


-- LOCATIONS

-- Create a location
INSERT INTO Locations
(user_id, location_name)
VALUES
(:userIDInput, :locationNameInput);

-- Read locations with user names
SELECT
    Locations.location_id,
    Locations.user_id,
    Users.username,
    Locations.location_name
FROM Locations
INNER JOIN Users
    ON Locations.user_id = Users.user_id
ORDER BY Locations.location_id;

-- Update a location
UPDATE Locations
SET user_id = :userIDInput,
    location_name = :locationNameInput
WHERE location_id = :locationIDInput;

-- Delete a location
DELETE FROM Locations
WHERE location_id = :locationIDInput;


-- INVENTORIES

-- Create an inventory item
INSERT INTO Inventories
(product_name, category, manufacturer, qty_on_hand, unit, purchase_date, expiration_date, user_id)
VALUES
(:productNameInput,
 :categoryInput,
 :manufacturerInput,
 :quantityInput,
 :unitInput,
 :purchaseDateInput,
 :expirationDateInput,
 :userIDInput);

-- Read inventory with user names (API aliases shown for frontend compatibility)
SELECT
    Inventories.inventory_id,
    Inventories.user_id,
    Users.username,
    Inventories.product_name AS item_name,
    Inventories.category AS item_type,
    Inventories.qty_on_hand AS quantity,
    Inventories.manufacturer,
    Inventories.unit,
    Inventories.purchase_date,
    Inventories.expiration_date
FROM Inventories
INNER JOIN Users
    ON Inventories.user_id = Users.user_id
ORDER BY Inventories.inventory_id;

-- Update an inventory item
UPDATE Inventories
SET product_name = :productNameInput,
    category = :categoryInput,
    manufacturer = :manufacturerInput,
    qty_on_hand = :quantityInput,
    unit = :unitInput,
    purchase_date = :purchaseDateInput,
    expiration_date = :expirationDateInput,
    user_id = :userIDInput
WHERE inventory_id = :inventoryIDInput;

-- Delete an inventory item
DELETE FROM Inventories
WHERE inventory_id = :inventoryIDInput;


-- PLANTS

-- Create a plant
INSERT INTO Plants
(nickname, date_acquired, health_status, user_id, species_id, location_id)
VALUES
(:plantNameInput,
 :dateAcquiredInput,
 :healthStatusInput,
 :userIDInput,
 :speciesIDInput,
 :locationIDInput);

-- Read plants with related display values (API aliases shown for frontend compatibility)
SELECT
    Plants.plant_id,
    Plants.user_id,
    Users.username,
    Plants.species_id,
    PlantSpecies.common_name AS species_name,
    Plants.location_id,
    Locations.location_name,
    Plants.nickname AS plant_name,
    Plants.date_acquired,
    Plants.health_status
FROM Plants
INNER JOIN Users
    ON Plants.user_id = Users.user_id
LEFT JOIN PlantSpecies
    ON Plants.species_id = PlantSpecies.species_id
LEFT JOIN Locations
    ON Plants.location_id = Locations.location_id
ORDER BY Plants.plant_id;

-- Update a plant
UPDATE Plants
SET nickname = :plantNameInput,
    date_acquired = :dateAcquiredInput,
    health_status = :healthStatusInput,
    user_id = :userIDInput,
    species_id = :speciesIDInput,
    location_id = :locationIDInput
WHERE plant_id = :plantIDInput;

-- Delete a plant
DELETE FROM Plants
WHERE plant_id = :plantIDInput;


-- PLANT CARE LOGS

-- Create a care log
INSERT INTO PlantCareLogs
(care_type, date_performed, amount_used, notes, inventory_id, plant_id)
VALUES
(:careTypeInput,
 :careDateInput,
 :amountInput,
 :notesInput,
 :inventoryIDInput,
 :plantIDInput);

-- Read care logs with plant names (API aliases shown for frontend compatibility)
SELECT
    PlantCareLogs.carelog_id AS log_id,
    PlantCareLogs.plant_id,
    Plants.nickname AS plant_name,
    PlantCareLogs.care_type,
    PlantCareLogs.date_performed AS care_date,
    PlantCareLogs.amount_used AS amount,
    PlantCareLogs.notes,
    PlantCareLogs.inventory_id
FROM PlantCareLogs
INNER JOIN Plants
    ON PlantCareLogs.plant_id = Plants.plant_id
ORDER BY PlantCareLogs.carelog_id;

-- Update a care log
UPDATE PlantCareLogs
SET care_type = :careTypeInput,
    date_performed = :careDateInput,
    amount_used = :amountInput,
    notes = :notesInput,
    inventory_id = :inventoryIDInput,
    plant_id = :plantIDInput
WHERE carelog_id = :logIDInput;

-- Delete a care log
DELETE FROM PlantCareLogs
WHERE carelog_id = :logIDInput;
