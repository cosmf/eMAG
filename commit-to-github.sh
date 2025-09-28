#!/bin/bash

echo "🚀 Committing eMAG Bank Project to GitHub"
echo "========================================"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
fi

# Add all files
echo "1. Adding all files to Git..."
git add .

# Create a comprehensive commit message
echo "2. Creating commit..."
git commit -m "🏦 eMAG Bank Simulation - Complete Implementation

✅ Features Implemented:
- Bank simulation with MongoDB backend
- Client and Product management with CRUD operations
- Client-Product relationships (banking products)
- Client deletion with cascade product removal
- Client history audit trail
- Comprehensive API testing suite

📊 Database Structure:
- Clients with status tracking
- Products with types (CURRENT_ACCOUNT, INVESTMENT_ACCOUNT, CREDIT_ACCOUNT)
- Client-Product junction table
- Client history for audit purposes

🧪 Testing:
- PUT operations with randomization
- DELETE operations with cascade logic
- Client history tracking
- Comprehensive API test scripts

📁 Files Added:
- Complete Spring Boot application
- MongoDB configuration
- API test scripts (PUT, DELETE, POST, GET)
- Database export/import scripts
- Postman collection for API testing

🎯 Business Logic:
- Product deletion: Complete removal
- Client deletion: Remove client + all products + add to history
- Proper audit trail for compliance

Created: $(date)
Ready for cross-device development!"

echo "3. Checking Git status..."
git status

echo ""
echo "✅ Ready to push to GitHub!"
echo ""
echo "Next steps:"
echo "1. Create a GitHub repository (if not exists)"
echo "2. Add remote: git remote add origin <your-repo-url>"
echo "3. Push: git push -u origin main"
echo ""
echo "📁 Database export included for cross-device sync!"
