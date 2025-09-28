# eMAG Bank Database Export

This directory contains a JSON export of the eMAG Bank simulation database.

## Files:
- `clients.json` - All client records
- `products.json` - All product records  
- `client_products.json` - Client-Product relationships
- `client_history.json` - Client deletion history
- `import-database.sh` - Script to import the data

## How to Import on Another Device:
1. Make sure MongoDB is running
2. Navigate to this directory
3. Run: `./import-database.sh`
4. The database will be imported to `retaildb` database

## Created on:
Mon Sep 29 02:41:52 EEST 2025
