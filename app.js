// Citation for the following code:
// Date: 7/27/2026
// Adapted from CS340 Exploration - Web Application Technology
// Source URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-web-application-technology-2?module_item_id=26923351


// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = process.env.PORT || 40069;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars');
app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');

// ########################################
// ########## GET ROUTES (READ)

app.get('/', async function (req, res) {
    try {
        res.render('home');
    } catch (error) {
        console.error('Error rendering page:', error);
        res.status(500).send('An error occurred.');
    }
});

app.get('/users', async function (req, res) {
    try {
        const query = 'SELECT user_id, username, email, password, date_joined FROM Users;';
        const [users] = await db.query(query);
        res.render('users', { users: users });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});

app.get('/plant-species', async function (req, res) {
    try {
        const query = 'SELECT * FROM PlantSpecies;';
        const [plant_species] = await db.query(query);
        res.render('plant-species', { plant_species: plant_species });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});

app.get('/locations', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM Locations;';
        const query2 = 'SELECT user_id, username FROM Users;';
        const [locations] = await db.query(query1);
        const [users] = await db.query(query2);
        res.render('locations', { locations: locations, users: users });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});

app.get('/inventories', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM Inventories;';
        const query2 = 'SELECT user_id, username FROM Users;';
        const [inventories] = await db.query(query1);
        const [users] = await db.query(query2);
        res.render('inventories', { inventories: inventories, users: users });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});

app.get('/plants', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM Plants;';
        const query2 = 'SELECT user_id, username FROM Users;';
        const query3 = 'SELECT species_id, common_name FROM PlantSpecies;';
        const query4 = 'SELECT location_id, location_name FROM Locations;';
        const [plants] = await db.query(query1);
        const [users] = await db.query(query2);
        const [plant_species] = await db.query(query3);
        const [locations] = await db.query(query4);
        res.render('plants', { plants: plants, users: users, plant_species: plant_species, locations: locations });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});

app.get('/plant-care-logs', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM PlantCareLogs;';
        const query2 = 'SELECT inventory_id, product_name FROM Inventories;';
        const query3 = 'SELECT plant_id, nickname FROM Plants;';
        const [logs] = await db.query(query1);
        const [inventories] = await db.query(query2);
        const [plants] = await db.query(query3);
        res.render('plant-care-logs', { logs: logs, inventories: inventories, plants: plants });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});

// ########################################
// ########## POST ROUTES (CREATE, UPDATE, DELETE)

// Add a User
app.post('/add-user', async function(req, res) {
    try {
        let data = req.body;
        let query = `INSERT INTO Users (username, email, password, date_joined) VALUES (?, ?, ?, ?)`;
        await db.query(query, [data.create_user_username, data.create_user_email, data.create_user_password, data.create_user_date_joined]);
        // Send the user back to the users page to see the new data
        res.redirect('/users');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error adding user');
    }
});

// Update a User
app.post('/update-user', async function(req, res) {
    try {
        let data = req.body;
        let query = `UPDATE Users SET username = ?, email = ?, password = ? WHERE user_id = ?`;
        await db.query(query, [data.update_user_username, data.update_user_email, data.update_user_password, data.update_user_id]);
        res.redirect('/users');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error updating user');
    }
});

// Delete a User
app.post('/delete-user', async function(req, res) {
    try {
        let data = req.body;
        let query = `DELETE FROM Users WHERE user_id = ?`;
        await db.query(query, [data.delete_user_id]);
        res.redirect('/users');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error deleting user');
    }
});

// ########################################
// ########## PLANT SPECIES ROUTES

app.post('/add-species', async function(req, res) {
    try {
        let data = req.body;
        let query = `INSERT INTO PlantSpecies (scientific_name, common_name, sunlight_type, watering_frequency, soil_type, pet_safe) VALUES (?, ?, ?, ?, ?, ?)`;
        await db.query(query, [data.scientific_name, data.common_name, data.sunlight_type, data.watering_frequency, data.soil_type, data.pet_safe]);
        res.redirect('/plant-species');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error adding species');
    }
});

app.post('/update-species', async function(req, res) {
    try {
        let data = req.body;
        // Based on the HTML update form we created, we are only updating scientific and common names here
        let query = `UPDATE PlantSpecies SET scientific_name = ?, common_name = ? WHERE species_id = ?`;
        await db.query(query, [data.scientific_name, data.common_name, data.update_species_id]);
        res.redirect('/plant-species');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error updating species');
    }
});

app.post('/delete-species', async function(req, res) {
    try {
        let data = req.body;
        let query = `DELETE FROM PlantSpecies WHERE species_id = ?`;
        await db.query(query, [data.delete_species_id]);
        res.redirect('/plant-species');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error deleting species');
    }
});

// ########################################
// ########## LOCATIONS ROUTES

app.post('/add-location', async function(req, res) {
    try {
        let data = req.body;
        let query = `INSERT INTO Locations (location_name, light_level, temperature_range, notes, user_id) VALUES (?, ?, ?, ?, ?)`;
        await db.query(query, [data.location_name, data.light_level, data.temperature_range, data.notes, data.user_id]);
        res.redirect('/locations');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error adding location');
    }
});

app.post('/update-location', async function(req, res) {
    try {
        let data = req.body;
        let query = `UPDATE Locations SET location_name = ?, light_level = ?, temperature_range = ?, notes = ?, user_id = ? WHERE location_id = ?`;
        await db.query(query, [data.location_name, data.light_level, data.temperature_range, data.notes, data.user_id, data.update_location_id]);
        res.redirect('/locations');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error updating location');
    }
});

app.post('/delete-location', async function(req, res) {
    try {
        let data = req.body;
        let query = `DELETE FROM Locations WHERE location_id = ?`;
        await db.query(query, [data.delete_location_id]);
        res.redirect('/locations');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error deleting location');
    }
});

// ########################################
// ########## INVENTORIES ROUTES

app.post('/add-inventory', async function(req, res) {
    try {
        let data = req.body;
        // Convert empty dates to null to prevent MySQL errors
        let purchaseDate = data.purchase_date ? data.purchase_date : null;
        let expirationDate = data.expiration_date ? data.expiration_date : null;

        let query = `INSERT INTO Inventories (product_name, category, manufacturer, qty_on_hand, unit, purchase_date, expiration_date, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
        await db.query(query, [data.product_name, data.category, data.manufacturer, data.qty_on_hand, data.unit, purchaseDate, expirationDate, data.user_id]);
        res.redirect('/inventories');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error adding inventory');
    }
});

app.post('/update-inventory', async function(req, res) {
    try {
        let data = req.body;
        let purchaseDate = data.purchase_date ? data.purchase_date : null;
        let expirationDate = data.expiration_date ? data.expiration_date : null;

        let query = `UPDATE Inventories SET product_name = ?, category = ?, manufacturer = ?, qty_on_hand = ?, unit = ?, purchase_date = ?, expiration_date = ?, user_id = ? WHERE inventory_id = ?`;
        await db.query(query, [data.product_name, data.category, data.manufacturer, data.qty_on_hand, data.unit, purchaseDate, expirationDate, data.user_id, data.update_inventory_id]);
        res.redirect('/inventories');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error updating inventory');
    }
});

app.post('/delete-inventory', async function(req, res) {
    try {
        let data = req.body;
        let query = `DELETE FROM Inventories WHERE inventory_id = ?`;
        await db.query(query, [data.delete_inventory_id]);
        res.redirect('/inventories');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error deleting inventory');
    }
});

// ########################################
// ########## PLANTS ROUTES

app.post('/add-plant', async function(req, res) {
    try {
        let data = req.body;
        let dateAcquired = data.date_acquired ? data.date_acquired : null;

        let query = `INSERT INTO Plants (nickname, date_acquired, health_status, user_id, species_id, location_id) VALUES (?, ?, ?, ?, ?, ?)`;
        await db.query(query, [data.nickname, dateAcquired, data.health_status, data.user_id, data.species_id, data.location_id]);
        res.redirect('/plants');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error adding plant');
    }
});

app.post('/update-plant', async function(req, res) {
    try {
        let data = req.body;
        let dateAcquired = data.date_acquired ? data.date_acquired : null;

        let query = `UPDATE Plants SET nickname = ?, date_acquired = ?, health_status = ?, user_id = ?, species_id = ?, location_id = ? WHERE plant_id = ?`;
        await db.query(query, [data.nickname, dateAcquired, data.health_status, data.user_id, data.species_id, data.location_id, data.update_plant_id]);
        res.redirect('/plants');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error updating plant');
    }
});

app.post('/delete-plant', async function(req, res) {
    try {
        let data = req.body;
        let query = `DELETE FROM Plants WHERE plant_id = ?`;
        await db.query(query, [data.delete_plant_id]);
        res.redirect('/plants');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error deleting plant');
    }
});

// ########################################
// ########## PLANT CARE LOGS ROUTES

app.post('/add-log', async function(req, res) {
    try {
        let data = req.body;
        let amountUsed = data.amount_used ? data.amount_used : null;
        let inventoryId = data.inventory_id === 'NULL' ? null : data.inventory_id;

        let query = `INSERT INTO PlantCareLogs (care_type, date_performed, amount_used, notes, inventory_id, plant_id) VALUES (?, ?, ?, ?, ?, ?)`;
        await db.query(query, [data.care_type, data.date_performed, amountUsed, data.notes, inventoryId, data.plant_id]);
        res.redirect('/plant-care-logs');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error adding log');
    }
});

app.post('/update-log', async function(req, res) {
    try {
        let data = req.body;
        let amountUsed = data.amount_used ? data.amount_used : null;
        let inventoryId = data.inventory_id === 'NULL' ? null : data.inventory_id;

        let query = `UPDATE PlantCareLogs SET care_type = ?, date_performed = ?, amount_used = ?, notes = ?, inventory_id = ?, plant_id = ? WHERE carelog_id = ?`;
        await db.query(query, [data.care_type, data.date_performed, amountUsed, data.notes, inventoryId, data.plant_id, data.update_log_id]);
        res.redirect('/plant-care-logs');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error updating log');
    }
});

app.post('/delete-log', async function(req, res) {
    try {
        let data = req.body;
        let query = `DELETE FROM PlantCareLogs WHERE carelog_id = ?`;
        await db.query(query, [data.delete_log_id]);
        res.redirect('/plant-care-logs');
    } catch (error) {
        console.error(error);
        res.status(400).send('Error deleting log');
    }
});


// ########################################
// ########## RESET DATABASE

app.post('/reset-database', async function (req, res) {
    try {
        await db.query('CALL sp_ResetGreenLeaf();');
        res.redirect('/');
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send('Error resetting database.');
    }
});


// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.');
});
