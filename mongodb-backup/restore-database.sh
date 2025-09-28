#!/bin/bash

echo "🔄 Restoring MongoDB Database"
echo "============================"

# Restore all collections
echo "Restoring clients..."
mongorestore --db=retaildb --collection=clients retaildb/clients.bson

echo "Restoring products..."
mongorestore --db=retaildb --collection=products retaildb/products.bson

echo "Restoring client_products..."
mongorestore --db=retaildb --collection=client_products retaildb/client_products.bson

echo "Restoring client_history..."
mongorestore --db=retaildb --collection=client_history retaildb/client_history.bson

echo "✅ Database restored successfully!"
