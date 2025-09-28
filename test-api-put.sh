#!/bin/bash

echo "🧪 Testing eMAG Bank API PUT Operations"
echo "======================================"

BASE_URL="http://localhost:8080"

# Test 1: Health Check
echo "1. Testing Health Check..."
curl -s "$BASE_URL/actuator/health" | jq . || echo "Health check failed"

echo -e "\n"

# Test 2: Get existing clients to work with
echo "2. Getting existing clients..."
CLIENTS_RESPONSE=$(curl -s "$BASE_URL/api/clients")
echo "$CLIENTS_RESPONSE" | jq . || echo "Failed to get clients"

# Extract random client ID from first 3 clients for testing
RANDOM_INDEX=$((RANDOM % 3))
CLIENT_ID=$(echo "$CLIENTS_RESPONSE" | jq -r ".[$RANDOM_INDEX].id" 2>/dev/null)
RANDOM_NUMBER=$((RANDOM % 69 + 1))
echo "Using CLIENT_ID for updates (index $RANDOM_INDEX): $CLIENT_ID"
echo "Random number for updates: $RANDOM_NUMBER"

echo -e "\n"

# Test 3: Get existing products to work with
echo "3. Getting existing products..."
PRODUCTS_RESPONSE=$(curl -s "$BASE_URL/api/products")
echo "$PRODUCTS_RESPONSE" | jq . || echo "Failed to get products"

# Extract random product ID from first 3 products for testing
RANDOM_PRODUCT_INDEX=$((RANDOM % 3))
PRODUCT_ID=$(echo "$PRODUCTS_RESPONSE" | jq -r ".[$RANDOM_PRODUCT_INDEX].id" 2>/dev/null)
echo "Using PRODUCT_ID for updates (index $RANDOM_PRODUCT_INDEX): $PRODUCT_ID"

echo -e "\n"

# Test 4: Update client information
if [ "$CLIENT_ID" != "null" ] && [ "$CLIENT_ID" != "" ]; then
  echo "4. Testing PUT /api/clients/$CLIENT_ID (update client info)..."
  TIMESTAMP=$(date +%s)
  curl -s -X PUT "$BASE_URL/api/clients/$CLIENT_ID" \
    -H "Content-Type: application/json" \
    -d "{
      \"id\": \"$CLIENT_ID\",
      \"cnp\": \"1234567890123\",
      \"firstName\": \"UpdatedFirstName${RANDOM_NUMBER}\",
      \"lastName\": \"UpdatedLastName${RANDOM_NUMBER}\",
      \"email\": \"updated.${TIMESTAMP}@example.com\",
      \"status\": \"ACTIVE\",
      \"productIds\": []
    }" | jq . || echo "Failed to update client"
  echo -e "\n"
else
  echo "4. No valid CLIENT_ID available for update test"
  echo -e "\n"
fi

# Test 5: Update product information
if [ "$PRODUCT_ID" != "null" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "5. Testing PUT /api/products/$PRODUCT_ID (update product info)..."
  TIMESTAMP=$(date +%s)
  curl -s -X PUT "$BASE_URL/api/products/$PRODUCT_ID" \
    -H "Content-Type: application/json" \
    -d "{
      \"id\": \"$PRODUCT_ID\",
      \"code\": \"P-001\",
      \"name\": \"Updated Product Name${RANDOM_NUMBER}\",
      \"price\": 199.99,
      \"active\": true,
      \"type\": null,
      \"status\": \"ACTIVE\"
    }" | jq . || echo "Failed to update product"
  echo -e "\n"
else
  echo "5. No valid PRODUCT_ID available for update test"
  echo -e "\n"
fi

# Test 6: Verify client update by getting the specific client
if [ "$CLIENT_ID" != "null" ] && [ "$CLIENT_ID" != "" ]; then
  echo "6. Verifying client update - GET /api/clients/$CLIENT_ID..."
  curl -s "$BASE_URL/api/clients/$CLIENT_ID" | jq . || echo "Failed to get updated client"
  echo -e "\n"
else
  echo "6. Cannot verify client update - no CLIENT_ID available"
  echo -e "\n"
fi

# Test 7: Verify product update by getting the specific product
if [ "$PRODUCT_ID" != "null" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "7. Verifying product update - GET /api/products/$PRODUCT_ID..."
  curl -s "$BASE_URL/api/products/$PRODUCT_ID" | jq . || echo "Failed to get updated product"
  echo -e "\n"
else
  echo "7. Cannot verify product update - no PRODUCT_ID available"
  echo -e "\n"
fi

# Test 8: Test updating client with partial data (only email)
if [ "$CLIENT_ID" != "null" ] && [ "$CLIENT_ID" != "" ]; then
  echo "8. Testing partial client update (email only)..."
  TIMESTAMP=$(date +%s)
  curl -s -X PUT "$BASE_URL/api/clients/$CLIENT_ID" \
    -H "Content-Type: application/json" \
    -d "{
      \"id\": \"$CLIENT_ID\",
      \"cnp\": \"1234567890123\",
      \"firstName\": \"UpdatedFirstName${RANDOM_NUMBER}\",
      \"lastName\": \"UpdatedLastName${RANDOM_NUMBER}\",
      \"email\": \"partial.update.${TIMESTAMP}@example.com\",
      \"status\": \"ACTIVE\",
      \"productIds\": []
    }" | jq . || echo "Failed to partially update client"
  echo -e "\n"
else
  echo "8. Cannot test partial update - no CLIENT_ID available"
  echo -e "\n"
fi

# Test 9: Test updating product with partial data (only price)
if [ "$PRODUCT_ID" != "null" ] && [ "$PRODUCT_ID" != "" ]; then
  echo "9. Testing partial product update (price only)..."
  curl -s -X PUT "$BASE_URL/api/products/$PRODUCT_ID" \
    -H "Content-Type: application/json" \
    -d "{
      \"id\": \"$PRODUCT_ID\",
      \"code\": \"P-001\",
      \"name\": \"Updated Product Name${RANDOM_NUMBER}\",
      \"price\": 299.99,
      \"active\": true,
      \"type\": null,
      \"status\": \"ACTIVE\"
    }" | jq . || echo "Failed to partially update product"
  echo -e "\n"
else
  echo "9. Cannot test partial update - no PRODUCT_ID available"
  echo -e "\n"
fi

# Test 10: Final verification - get all clients and products to see changes
echo "10. Final verification - getting all clients..."
curl -s "$BASE_URL/api/clients" | jq . || echo "Failed to get all clients"

echo -e "\n"

echo "11. Final verification - getting all products..."
curl -s "$BASE_URL/api/products" | jq . || echo "Failed to get all products"

echo -e "\n"

echo "✅ PUT Operations Testing Complete!"
