// Citation for the following code:
// Date: 7/27/2026
// Adapted from CS340 Exploration - Web Application Technology
// Source URL:
// https://canvas.oregonstate.edu/courses/2051721/pages/exploration-web-application-technology-2?module_item_id=26923351
//
// AI assistance:
// NONE


// ########################################
//SETUP

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
// GET ROUTES (READ)

// Home page
app.get('/', async function (req, res) {
    try {
        res.render('home');
    } catch (error) {
        console.error('Error rendering page:', error);
        res.status(500).send('An error occurred.');
    }
});


// Display Users
app.get('/users', async function (req, res) {
    try {
        const query =
            'SELECT user_id, username, email, password, date_joined FROM Users;';

        const [users] = await db.query(query);

        res.render('users', {
            users: users
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});


// Display Plant Species
app.get('/plant-species', async function (req, res) {
    try {
        const query = 'SELECT * FROM PlantSpecies;';

        const [plant_species] = await db.query(query);

        res.render('plant-species', {
            plant_species: plant_species
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});


// Display Locations and Users for foreign-key dropdowns
app.get('/locations', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM Locations;';
        const query2 = 'SELECT user_id, username FROM Users;';

        const [locations] = await db.query(query1);
        const [users] = await db.query(query2);

        res.render('locations', {
            locations: locations,
            users: users
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});


// Display Inventories and Users for foreign-key dropdowns
app.get('/inventories', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM Inventories;';
        const query2 = 'SELECT user_id, username FROM Users;';

        const [inventories] = await db.query(query1);
        const [users] = await db.query(query2);

        res.render('inventories', {
            inventories: inventories,
            users: users
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});


// Display Plants and foreign-key dropdown data
app.get('/plants', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM Plants;';
        const query2 = 'SELECT user_id, username FROM Users;';
        const query3 =
            'SELECT species_id, common_name FROM PlantSpecies;';
        const query4 =
            'SELECT location_id, location_name FROM Locations;';

        const [plants] = await db.query(query1);
        const [users] = await db.query(query2);
        const [plant_species] = await db.query(query3);
        const [locations] = await db.query(query4);

        res.render('plants', {
            plants: plants,
            users: users,
            plant_species: plant_species,
            locations: locations
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});


// Display Plant Care Logs and foreign-key dropdown data
app.get('/plant-care-logs', async function (req, res) {
    try {
        const query1 = 'SELECT * FROM PlantCareLogs;';
        const query2 =
            'SELECT inventory_id, product_name FROM Inventories;';
        const query3 =
            'SELECT plant_id, nickname FROM Plants;';

        const [logs] = await db.query(query1);
        const [inventories] = await db.query(query2);
        const [plants] = await db.query(query3);

        res.render('plant-care-logs', {
            logs: logs,
            inventories: inventories,
            plants: plants
        });
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occurred.');
    }
});


// ########################################
// ########## USERS: CREATE, UPDATE, DELETE

// Create User using sp_CreateUser
app.post('/add-user', async function (req, res) {
    try {
        const data = req.body;

        const query = 'CALL sp_CreateUser(?, ?, ?, ?);';

        await db.query(query, [
            data.create_user_username,
            data.create_user_email,
            data.create_user_password,
            data.create_user_date_joined
        ]);

        res.redirect('/users');
    } catch (error) {
        console.error('Error adding user:', error);
        res.status(400).send('Error adding user');
    }
});


// Update User using sp_UpdateUser
app.post('/update-user', async function (req, res) {
    try {
        const data = req.body;

        const query = 'CALL sp_UpdateUser(?, ?, ?, ?);';

        await db.query(query, [
            data.update_user_id,
            data.update_user_username,
            data.update_user_email,
            data.update_user_password
        ]);

        res.redirect('/users');
    } catch (error) {
        console.error('Error updating user:', error);
        res.status(400).send('Error updating user');
    }
});


// Delete User using sp_DeleteUser
app.post('/delete-user', async function (req, res) {
    try {
        const data = req.body;

        const query = 'CALL sp_DeleteUser(?);';

        await db.query(query, [
            data.delete_user_id
        ]);

        res.redirect('/users');
    } catch (error) {
        console.error('Error deleting user:', error);
        res.status(400).send('Error deleting user');
    }
});


// ########################################
// ########## PLANT SPECIES ROUTES

// Create Plant Species using sp_CreatePlantSpecies
app.post('/add-species', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_CreatePlantSpecies(?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.scientific_name,
            data.common_name,
            data.sunlight_type,
            data.watering_frequency,
            data.soil_type,
            data.pet_safe
        ]);

        res.redirect('/plant-species');
    } catch (error) {
        console.error('Error adding species:', error);
        res.status(400).send('Error adding species');
    }
});


// Update Plant Species using sp_UpdatePlantSpecies
app.post('/update-species', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_UpdatePlantSpecies(?, ?, ?);';

        await db.query(query, [
            data.update_species_id,
            data.scientific_name,
            data.common_name
        ]);

        res.redirect('/plant-species');
    } catch (error) {
        console.error('Error updating species:', error);
        res.status(400).send('Error updating species');
    }
});


// Delete Plant Species using sp_DeletePlantSpecies
app.post('/delete-species', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_DeletePlantSpecies(?);';

        await db.query(query, [
            data.delete_species_id
        ]);

        res.redirect('/plant-species');
    } catch (error) {
        console.error('Error deleting species:', error);
        res.status(400).send('Error deleting species');
    }
});


// ########################################
// ########## LOCATIONS ROUTES

// Create Location using sp_CreateLocation
app.post('/add-location', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_CreateLocation(?, ?, ?, ?, ?);';

        await db.query(query, [
            data.location_name,
            data.light_level,
            data.temperature_range,
            data.notes,
            data.user_id
        ]);

        res.redirect('/locations');
    } catch (error) {
        console.error('Error adding location:', error);
        res.status(400).send('Error adding location');
    }
});


// Update Location using sp_UpdateLocation
app.post('/update-location', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_UpdateLocation(?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.update_location_id,
            data.location_name,
            data.light_level,
            data.temperature_range,
            data.notes,
            data.user_id
        ]);

        res.redirect('/locations');
    } catch (error) {
        console.error('Error updating location:', error);
        res.status(400).send('Error updating location');
    }
});


// Delete Location using sp_DeleteLocation
app.post('/delete-location', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_DeleteLocation(?);';

        await db.query(query, [
            data.delete_location_id
        ]);

        res.redirect('/locations');
    } catch (error) {
        console.error('Error deleting location:', error);
        res.status(400).send('Error deleting location');
    }
});


// ########################################
// ########## INVENTORIES ROUTES

// Create Inventory using sp_CreateInventory
app.post('/add-inventory', async function (req, res) {
    try {
        const data = req.body;

        // Empty date fields are converted to NULL.
        const purchaseDate =
            data.purchase_date ? data.purchase_date : null;

        const expirationDate =
            data.expiration_date ? data.expiration_date : null;

        const query =
            'CALL sp_CreateInventory(?, ?, ?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.product_name,
            data.category,
            data.manufacturer,
            data.qty_on_hand,
            data.unit,
            purchaseDate,
            expirationDate,
            data.user_id
        ]);

        res.redirect('/inventories');
    } catch (error) {
        console.error('Error adding inventory:', error);
        res.status(400).send('Error adding inventory');
    }
});


// Update Inventory using sp_UpdateInventory
app.post('/update-inventory', async function (req, res) {
    try {
        const data = req.body;

        const purchaseDate =
            data.purchase_date ? data.purchase_date : null;

        const expirationDate =
            data.expiration_date ? data.expiration_date : null;

        const query =
            'CALL sp_UpdateInventory(?, ?, ?, ?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.update_inventory_id,
            data.product_name,
            data.category,
            data.manufacturer,
            data.qty_on_hand,
            data.unit,
            purchaseDate,
            expirationDate,
            data.user_id
        ]);

        res.redirect('/inventories');
    } catch (error) {
        console.error('Error updating inventory:', error);
        res.status(400).send('Error updating inventory');
    }
});


// Delete Inventory using sp_DeleteInventory
app.post('/delete-inventory', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_DeleteInventory(?);';

        await db.query(query, [
            data.delete_inventory_id
        ]);

        res.redirect('/inventories');
    } catch (error) {
        console.error('Error deleting inventory:', error);
        res.status(400).send('Error deleting inventory');
    }
});


// ########################################
// ########## PLANTS ROUTES

// Create Plant using sp_CreatePlant
app.post('/add-plant', async function (req, res) {
    try {
        const data = req.body;

        const dateAcquired =
            data.date_acquired ? data.date_acquired : null;

        const query =
            'CALL sp_CreatePlant(?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.nickname,
            dateAcquired,
            data.health_status,
            data.user_id,
            data.species_id,
            data.location_id
        ]);

        res.redirect('/plants');
    } catch (error) {
        console.error('Error adding plant:', error);
        res.status(400).send('Error adding plant');
    }
});


// Update Plant using sp_UpdatePlant
app.post('/update-plant', async function (req, res) {
    try {
        const data = req.body;

        const dateAcquired =
            data.date_acquired ? data.date_acquired : null;

        const query =
            'CALL sp_UpdatePlant(?, ?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.update_plant_id,
            data.nickname,
            dateAcquired,
            data.health_status,
            data.user_id,
            data.species_id,
            data.location_id
        ]);

        res.redirect('/plants');
    } catch (error) {
        console.error('Error updating plant:', error);
        res.status(400).send('Error updating plant');
    }
});


// Delete Plant using sp_DeletePlant
app.post('/delete-plant', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_DeletePlant(?);';

        await db.query(query, [
            data.delete_plant_id
        ]);

        res.redirect('/plants');
    } catch (error) {
        console.error('Error deleting plant:', error);
        res.status(400).send('Error deleting plant');
    }
});


// ########################################
// ########## PLANT CARE LOGS ROUTES

// Create Plant Care Log using sp_CreatePlantCareLog
app.post('/add-log', async function (req, res) {
    try {
        const data = req.body;

        const amountUsed =
            data.amount_used ? data.amount_used : null;

        const inventoryId =
            data.inventory_id === 'NULL'
                ? null
                : data.inventory_id;

        const query =
            'CALL sp_CreatePlantCareLog(?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.care_type,
            data.date_performed,
            amountUsed,
            data.notes,
            inventoryId,
            data.plant_id
        ]);

        res.redirect('/plant-care-logs');
    } catch (error) {
        console.error('Error adding care log:', error);
        res.status(400).send('Error adding log');
    }
});


// Update Plant Care Log and its M:N relationship
app.post('/update-log', async function (req, res) {
    try {
        const data = req.body;

        const amountUsed =
            data.amount_used ? data.amount_used : null;

        const inventoryId =
            data.inventory_id === 'NULL'
                ? null
                : data.inventory_id;

        const query =
            'CALL sp_UpdatePlantCareLog(?, ?, ?, ?, ?, ?, ?);';

        await db.query(query, [
            data.update_log_id,
            data.care_type,
            data.date_performed,
            amountUsed,
            data.notes,
            inventoryId,
            data.plant_id
        ]);

        res.redirect('/plant-care-logs');
    } catch (error) {
        console.error('Error updating care log:', error);
        res.status(400).send('Error updating log');
    }
});


// Delete Plant Care Log and remove its M:N relationship
app.post('/delete-log', async function (req, res) {
    try {
        const data = req.body;

        const query =
            'CALL sp_DeletePlantCareLog(?);';

        await db.query(query, [
            data.delete_log_id
        ]);

        res.redirect('/plant-care-logs');
    } catch (error) {
        console.error('Error deleting care log:', error);
        res.status(400).send('Error deleting log');
    }
});


// ########################################
// ########## RESET DATABASE

// Reset all database tables using the PL.sql reset entry point
app.post('/reset-database', async function (req, res) {
    try {
        await db.query('CALL sp_ResetDatabase();');

        res.redirect('/');
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send('Error resetting database.');
    }
});


// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
        PORT +
        '; press Ctrl-C to terminate.'
    );
});
