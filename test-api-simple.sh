#!/bin/bash

echo "🧪 Testing eMAG Bank API Endpoints (Using Existing Data)"
echo "======================================================="

BASE_URL="http://localhost:8080"

# Test 1: Health Check
echo "1. Testing Health Check..."
curl -s "$BASE_URL/actuator/health" | jq . || echo "Health check failed"

echo -e "\n"

# Test 2: Get Clients
echo "2. Testing GET /api/clients..."
CLIENTS_RESPONSE=$(curl -s "$BASE_URL/api/clients")
echo "$CLIENTS_RESPONSE" | jq . || echo "Failed to get clients"

# Extract first client ID for testing
CLIENT_ID=$(echo "$CLIENTS_RESPONSE" | jq -r '.[0].id' 2>/dev/null)
echo "Using CLIENT_ID: $CLIENT_ID"

echo -e "\n"

# Test 3: Get Products
echo "3. Testing GET /api/products..."
PRODUCTS_RESPONSE=$(curl -s "$BASE_URL/api/products")
echo "$PRODUCTS_RESPONSE" | jq . || echo "Failed to get products"

# Extract first product ID for testing
PRODUCT_ID=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[0].id' 2>/dev/null)
echo "Using PRODUCT_ID: $PRODUCT_ID"

echo -e "\n"

# Test 4: Get specific client
if [ "$CLIENT_ID" != "null" ] && [ "$CLIENT_ID" != "" ]; then
  echo "4. Testing GET /api/clients/$CLIENT_ID..."
  curl -s "$BASE_URL/api/clients/$CLIENT_ID" | jq . || echo "Failed to get specific client"
  echo -e "\n"
else
  echo "4. No valid CLIENT_ID available"
  echo -e "\n"
fi

# Test 5: Get specific product
if [ "$PRODUCT_ID" != "null" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "5. Testing GET /api/products/$PRODUCT_ID..."
  curl -s "$BASE_URL/api/products/$PRODUCT_ID" | jq . || echo "Failed to get specific product"
  echo -e "\n"
else
  echo "5. No valid PRODUCT_ID available"
  echo -e "\n"
fi

# Test 6: Attach product to client
if [ "$CLIENT_ID" != "null" ] && [ "$PRODUCT_ID" != "null" ] && [ "$CLIENT_ID" != "" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "6. Testing POST /api/clients/$CLIENT_ID/products/$PRODUCT_ID..."
  curl -s -X POST "$BASE_URL/api/clients/$CLIENT_ID/products/$PRODUCT_ID" | jq . || echo "Failed to attach product to client"
  echo -e "\n"
else
  echo "6. Cannot test attach - missing CLIENT_ID or PRODUCT_ID"
  echo -e "\n"
fi

# Test 7: Search products
echo "7. Testing GET /api/products/search..."
curl -s "$BASE_URL/api/products/search?q=test&active=true" | jq . || echo "Failed to search products"

echo -e "\n"

# Test 8: Create a new client with unique data
echo "8. Testing POST /api/clients (with unique data)..."
TIMESTAMP=$(date +%s)
curl -s -X POST "$BASE_URL/api/clients" \
  -H "Content-Type: application/json" \
  -d "{
    \"cnp\": \"${TIMESTAMP}999\",
    \"firstName\": \"TestUser\",
    \"lastName\": \"${TIMESTAMP}\",
    \"email\": \"testuser.${TIMESTAMP}@example.com\"
  }" | jq . || echo "Failed to create client"

echo -e "\n"

# Test 9: Create a new product with unique data
echo "9. Testing POST /api/products (with unique data)..."
curl -s -X POST "$BASE_URL/api/products" \
  -H "Content-Type: application/json" \
  -d "{
    \"code\": \"UNIQUE-${TIMESTAMP}\",
    \"name\": \"Unique Product ${TIMESTAMP}\",
    \"price\": 99.99
  }" | jq . || echo "Failed to create product"

echo -e "\n"

echo "✅ API Testing Complete!"
