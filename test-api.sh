#!/bin/bash

echo "🧪 Testing eMAG Bank API Endpoints"
echo "=================================="

BASE_URL="http://localhost:8080"

# Test 1: Health Check
echo "1. Testing Health Check..."
curl -s "$BASE_URL/actuator/health" | jq . || echo "Health check failed"

echo -e "\n"

# Test 2: Get Clients
echo "2. Testing GET /api/clients..."
curl -s "$BASE_URL/api/clients" | jq . || echo "Failed to get clients"

echo -e "\n"

# Test 3: Get Products
echo "3. Testing GET /api/products..."
curl -s "$BASE_URL/api/products" | jq . || echo "Failed to get products"

echo -e "\n"

# Test 4: Create a new client
echo "4. Testing POST /api/clients..."
TIMESTAMP=$(date +%s)
CLIENT_RESPONSE=$(curl -s -X POST "$BASE_URL/api/clients" \
  -H "Content-Type: application/json" \
  -d "{
    \"cnp\": \"${TIMESTAMP}001\",
    \"firstName\": \"John\",
    \"lastName\": \"Doe\",
    \"email\": \"john.doe.${TIMESTAMP}@example.com\"
  }")

echo "Client created:"
echo "$CLIENT_RESPONSE" | jq . || echo "$CLIENT_RESPONSE"

# Extract client ID for further tests
CLIENT_ID=$(echo "$CLIENT_RESPONSE" | jq -r '.id' 2>/dev/null)
echo "Extracted CLIENT_ID: $CLIENT_ID"

echo -e "\n"

# Test 5: Create a new product
echo "5. Testing POST /api/products..."
PRODUCT_RESPONSE=$(curl -s -X POST "$BASE_URL/api/products" \
  -H "Content-Type: application/json" \
  -d "{
    \"code\": \"TEST-${TIMESTAMP}\",
    \"name\": \"Test Product ${TIMESTAMP}\",
    \"price\": 150.75
  }")

echo "Product created:"
echo "$PRODUCT_RESPONSE" | jq . || echo "$PRODUCT_RESPONSE"

# Extract product ID for further tests
PRODUCT_ID=$(echo "$PRODUCT_RESPONSE" | jq -r '.id' 2>/dev/null)
echo "Extracted PRODUCT_ID: $PRODUCT_ID"

echo -e "\n"

# Test 6: Get specific client
if [ "$CLIENT_ID" != "null" ] && [ "$CLIENT_ID" != "" ]; then
  echo "6. Testing GET /api/clients/$CLIENT_ID..."
  curl -s "$BASE_URL/api/clients/$CLIENT_ID" | jq . || echo "Failed to get specific client"
  echo -e "\n"
else
  echo "6. Skipping GET specific client test - no valid CLIENT_ID available"
  echo -e "\n"
fi

# Test 7: Get specific product
if [ "$PRODUCT_ID" != "null" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "7. Testing GET /api/products/$PRODUCT_ID..."
  curl -s "$BASE_URL/api/products/$PRODUCT_ID" | jq . || echo "Failed to get specific product"
  echo -e "\n"
else
  echo "7. Skipping GET specific product test - no valid PRODUCT_ID available"
  echo -e "\n"
fi

# Test 8: Attach product to client
if [ "$CLIENT_ID" != "null" ] && [ "$PRODUCT_ID" != "null" ] && [ "$CLIENT_ID" != "" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "8. Testing POST /api/clients/$CLIENT_ID/products/$PRODUCT_ID..."
  curl -s -X POST "$BASE_URL/api/clients/$CLIENT_ID/products/$PRODUCT_ID" | jq . || echo "Failed to attach product to client"
  echo -e "\n"
else
  echo "8. Skipping attach product test - no valid CLIENT_ID or PRODUCT_ID available"
  echo -e "\n"
fi

# Test 9: Search products
echo "9. Testing GET /api/products/search..."
curl -s "$BASE_URL/api/products/search?q=test&active=true" | jq . || echo "Failed to search products"

echo -e "\n"

echo "✅ API Testing Complete!"
