# MongoDB Database Backup

This directory contains a backup of the eMAG Bank simulation database.

## Files:
- `retaildb/clients.bson` - Client records
- `retaildb/products.bson` - Product records  
- `retaildb/client_products.bson` - Client-Product relationships
- `retaildb/client_history.bson` - Client deletion history
- `restore-database.sh` - Script to restore the database

## How to Restore:
1. Make sure MongoDB is running
2. Run: `./restore-database.sh`
3. The database will be restored to `retaildb` database

## Created on:
Mon Sep 29 02:37:00 EEST 2025
