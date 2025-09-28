#!/bin/bash

echo "🗄️ Exporting MongoDB Database for Cross-Device Sync"
echo "=================================================="

# Create backup directory
BACKUP_DIR="mongodb-backup"
mkdir -p "$BACKUP_DIR"

# Export all collections from retaildb database
echo "1. Exporting clients collection..."
mongodump --db=retaildb --collection=clients --out="$BACKUP_DIR"

echo "2. Exporting products collection..."
mongodump --db=retaildb --collection=products --out="$BACKUP_DIR"

echo "3. Exporting client_products collection..."
mongodump --db=retaildb --collection=client_products --out="$BACKUP_DIR"

echo "4. Exporting client_history collection..."
mongodump --db=retaildb --collection=client_history --out="$BACKUP_DIR"

echo "5. Creating database restore script..."
cat > "$BACKUP_DIR/restore-database.sh" << 'EOF'
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
EOF

chmod +x "$BACKUP_DIR/restore-database.sh"

echo "6. Creating README for database backup..."
cat > "$BACKUP_DIR/README.md" << 'EOF'
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
EOF

echo "$(date)" >> "$BACKUP_DIR/README.md"

echo "✅ Database export complete!"
echo "📁 Backup directory: $BACKUP_DIR"
echo "📄 Files created:"
ls -la "$BACKUP_DIR/retaildb/"
echo ""
echo "🚀 Ready to commit to GitHub!"
