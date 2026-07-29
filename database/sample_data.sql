-- Sample data aligned to the current live schema.
-- Values are examples only; adjust IDs if your Users rows differ.

INSERT INTO Users
(username, email, password, date_joined)
VALUES
('cs340_demo_user', 'cs340_demo_user@example.com', 'hashed_password_1', '2026-07-01'),
('cs340_demo_user2', 'cs340_demo_user2@example.com', 'hashed_password_2', '2026-07-02');

INSERT INTO PlantSpecies
(scientific_name, common_name, sunlight_type, watering_frequency, soil_type, pet_safe)
VALUES
('Monstera deliciosa', 'Monstera', 'Bright indirect light', 'Every 7 to 10 days', 'Well-draining tropical mix', 0),
('Epipremnum aureum', 'Golden Pothos', 'Medium to bright indirect light', 'When top inch is dry', 'Standard houseplant mix', 0);

INSERT INTO Locations
(location_name, light_level, temperature_range, notes, user_id)
VALUES
('Living Room Window', 'Bright', '65-75F', 'South-facing area', 1),
('Bedroom Shelf', 'Medium', '65-72F', 'Near humidifier', 1);

INSERT INTO Inventories
(product_name, category, manufacturer, qty_on_hand, unit, purchase_date, expiration_date, user_id)
VALUES
('Indoor Plant Fertilizer', 'Fertilizer', 'GreenGrow', 24.50, 'fluid ounces', '2026-06-01', '2027-06-01', 1),
('Neem Oil Spray', 'Pest Control', 'LeafSafe', 16.00, 'fluid ounces', '2026-05-20', NULL, 1);

INSERT INTO Plants
(nickname, date_acquired, health_status, user_id, species_id, location_id)
VALUES
('Monty', '2025-08-15', 'Good', 1, 1, 1),
('Goldie', '2026-03-10', 'Good', 1, 2, 2);

INSERT INTO PlantCareLogs
(care_type, date_performed, amount_used, notes, inventory_id, plant_id)
VALUES
('Watering', '2026-07-10', NULL, 'Watered until slight drainage', NULL, 1),
('Fertilizing', '2026-07-14', 1.00, 'Diluted fertilizer in water', 1, 2);
