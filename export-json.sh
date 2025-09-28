#!/bin/bash

echo "🗄️ Exporting MongoDB Database as JSON"
echo "===================================="

# Create backup directory
BACKUP_DIR="database-export"
mkdir -p "$BACKUP_DIR"

# Export collections as JSON
echo "1. Exporting clients collection..."
mongoexport --db=retaildb --collection=clients --out="$BACKUP_DIR/clients.json" --pretty

echo "2. Exporting products collection..."
mongoexport --db=retaildb --collection=products --out="$BACKUP_DIR/products.json" --pretty

echo "3. Exporting client_products collection..."
mongoexport --db=retaildb --collection=client_products --out="$BACKUP_DIR/client_products.json" --pretty

echo "4. Exporting client_history collection..."
mongoexport --db=retaildb --collection=client_history --out="$BACKUP_DIR/client_history.json" --pretty

echo "5. Creating import script..."
cat > "$BACKUP_DIR/import-database.sh" << 'EOF'
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
EOF

chmod +x "$BACKUP_DIR/import-database.sh"

echo "6. Creating README..."
cat > "$BACKUP_DIR/README.md" << 'EOF'
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
EOF

echo "$(date)" >> "$BACKUP_DIR/README.md"

echo "✅ JSON export complete!"
echo "📁 Export directory: $BACKUP_DIR"
echo "📄 Files created:"
ls -la "$BACKUP_DIR/"
echo ""
echo "🚀 Ready to commit to GitHub!"
