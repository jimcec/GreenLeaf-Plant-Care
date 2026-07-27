// Citation for the following code:
// Date: 7/27/2026
// Copied from CS340 Exploration - Web Application Technology
// Source URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-web-application-technology-2?module_item_id=26923351



// Get an instance of mysql we can use in the app
let mysql = require('mysql2')
require('dotenv').config(); // Load the environment variables

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : process.env.DB_HOST,
    user              : process.env.DB_USER,
    password          : process.env.DB_PASSWORD,
    database          : process.env.DB_NAME
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;