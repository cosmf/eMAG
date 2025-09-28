#!/bin/bash

echo "🔄 Importing MongoDB Database from JSON"
echo "======================================"

# Import collections from JSON
echo "Importing clients..."
mongoimport --db=retaildb --collection=clients --file=clients.json --jsonArray

echo "Importing products..."
mongoimport --db=retaildb --collection=products --file=products.json --jsonArray

echo "Importing client_products..."
mongoimport --db=retaildb --collection=client_products --file=client_products.json --jsonArray

echo "Importing client_history..."
mongoimport --db=retaildb --collection=client_history --file=client_history.json --jsonArray

echo "✅ Database imported successfully!"
