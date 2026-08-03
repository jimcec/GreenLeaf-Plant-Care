# 🌿 GreenLeaf Plant Care

GreenLeaf Plant Care is a full-stack web application developed for Oregon State University's CS340 Database Systems course. The application helps users organize and manage their indoor and outdoor plant collections by tracking plants, species, growing locations, gardening inventory, and plant care history.

## Features

- 🌱 Manage individual plants
- 🌿 Store plant species information
- 📍 Organize growing locations
- 🧪 Track fertilizers, soil, pesticides, and other inventory
- 📝 Record plant care events such as:
  - Watering
  - Fertilizing
  - Pest treatment
  - Pruning
  - Repotting
- 🔄 Restore the database to its original sample data with a single click

## Database Design

The project contains six entities:

- Users
- Plants
- PlantSpecies
- Locations
- Inventories
- PlantCareLogs

The application demonstrates:

- One-to-Many relationships
- A Many-to-Many relationship between Plants and Inventories using PlantCareLogs as the intersection table
- Stored procedures for CREATE, UPDATE, DELETE, and RESET operations

## Technologies Used

- Node.js
- Express.js
- Handlebars
- MariaDB / MySQL
- HTML5
- CSS3
- JavaScript

## Project Structure

```
.
├── app.js
├── database/
│   ├── DDL.sql
│   ├── DML.sql
│   └── PL.sql
├── public/
├── views/
├── package.json
└── README.md
```

## Installation

1. Clone the repository

```bash
git clone https://github.com/<your-username>/<repository>.git
```

2. Install dependencies

```bash
npm install
```

3. Configure your database connection.

Create or edit the database configuration file with your own database credentials.

4. Build the database

Import:

- `DDL.sql`
- `PL.sql`

The DDL creates the schema and populates the database with sample data.

5. Start the application

```bash
npm start
```

or

```bash
node app.js
```

## Course Information

Developed as the final portfolio project for:

**CS340 — Introduction to Databases**

Oregon State University

## Authors

- Cameron Kuykendall
- James Cecconi

## License

This repository is provided for educational and portfolio purposes.
