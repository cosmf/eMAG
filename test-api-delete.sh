#!/bin/bash

echo "🧪 Testing eMAG Bank API DELETE Operations"
echo "=========================================="

BASE_URL="http://localhost:8080"

# Test 1: Health Check
echo "1. Testing Health Check..."
curl -s "$BASE_URL/actuator/health" | jq . || echo "Health check failed"

echo -e "\n"

# Test 2: Get existing clients to work with
echo "2. Getting existing clients..."
CLIENTS_RESPONSE=$(curl -s "$BASE_URL/api/clients")
echo "$CLIENTS_RESPONSE" | jq . || echo "Failed to get clients"

# Extract client IDs for testing (find clients with products attached)
CLIENT_ID_1=$(echo "$CLIENTS_RESPONSE" | jq -r '.[] | select(.productIds | length > 0) | .id' 2>/dev/null | head -1)
CLIENT_ID_2=$(echo "$CLIENTS_RESPONSE" | jq -r '.[] | select(.productIds | length > 0) | .id' 2>/dev/null | head -2 | tail -1)

# If no clients with products, use last clients
if [ "$CLIENT_ID_1" == "" ]; then
  CLIENT_ID_1=$(echo "$CLIENTS_RESPONSE" | jq -r '.[-2].id' 2>/dev/null)
fi
if [ "$CLIENT_ID_2" == "" ]; then
  CLIENT_ID_2=$(echo "$CLIENTS_RESPONSE" | jq -r '.[-1].id' 2>/dev/null)
fi

echo "Using CLIENT_ID_1 for deletion: $CLIENT_ID_1"
echo "Using CLIENT_ID_2 for deletion: $CLIENT_ID_2"

echo -e "\n"

# Test 3: Get existing products to work with
echo "3. Getting existing products..."
PRODUCTS_RESPONSE=$(curl -s "$BASE_URL/api/products")
echo "$PRODUCTS_RESPONSE" | jq . || echo "Failed to get products"

# Extract product IDs for testing (use last few products)
PRODUCT_ID_1=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[-2].id' 2>/dev/null)  # Second to last
PRODUCT_ID_2=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[-1].id' 2>/dev/null)  # Last product
echo "Using PRODUCT_ID_1 for deletion: $PRODUCT_ID_1"
echo "Using PRODUCT_ID_2 for deletion: $PRODUCT_ID_2"

echo -e "\n"

# Test 4: Check client history before any deletions
echo "4. Checking client history before deletions..."
curl -s "$BASE_URL/api/client-history" | jq . || echo "Failed to get client history (endpoint might not exist yet)"

echo -e "\n"

# Test 5: Delete a product (should be completely removed)
if [ "$PRODUCT_ID_1" != "null" ] && [ "$PRODUCT_ID_1" != "" ]; then
  echo "5. Testing DELETE /api/products/$PRODUCT_ID_1 (product should be completely removed)..."
  curl -s -X DELETE "$BASE_URL/api/products/$PRODUCT_ID_1" || echo "Failed to delete product"
  echo -e "\n"
  
  # Verify product is deleted
  echo "5a. Verifying product deletion - GET /api/products/$PRODUCT_ID_1..."
  curl -s "$BASE_URL/api/products/$PRODUCT_ID_1" | jq . || echo "Product successfully deleted (404 expected)"
  echo -e "\n"
else
  echo "5. No valid PRODUCT_ID_1 available for deletion test"
  echo -e "\n"
fi

# Test 6: Delete a client (should be added to history, not completely removed)
if [ "$CLIENT_ID_1" != "null" ] && [ "$CLIENT_ID_1" != "" ]; then
  echo "6. Testing DELETE /api/clients/$CLIENT_ID_1 (client should be added to history)..."
  curl -s -X DELETE "$BASE_URL/api/clients/$CLIENT_ID_1" || echo "Failed to delete client"
  echo -e "\n"
  
  # Verify client is deleted from main list
  echo "6a. Verifying client deletion - GET /api/clients/$CLIENT_ID_1..."
  curl -s "$BASE_URL/api/clients/$CLIENT_ID_1" | jq . || echo "Client successfully deleted from main list (404 expected)"
  echo -e "\n"
else
  echo "6. No valid CLIENT_ID_1 available for deletion test"
  echo -e "\n"
fi

# Test 7: Check client history after client deletion
echo "7. Checking client history after client deletion..."
curl -s "$BASE_URL/api/client-history" | jq . || echo "Failed to get client history"

echo -e "\n"

# Test 8: Try to delete a non-existent product (should return 404)
echo "8. Testing DELETE /api/products/non-existent-id (should return 404)..."
curl -s -X DELETE "$BASE_URL/api/products/non-existent-id" || echo "Expected 404 for non-existent product"
echo -e "\n"

# Test 9: Try to delete a non-existent client (should return 404)
echo "9. Testing DELETE /api/clients/non-existent-id (should return 404)..."
curl -s -X DELETE "$BASE_URL/api/clients/non-existent-id" || echo "Expected 404 for non-existent client"
echo -e "\n"

# Test 10: Delete another product to test multiple deletions
if [ "$PRODUCT_ID_2" != "null" ] && [ "$PRODUCT_ID_2" != "" ]; then
  echo "10. Testing DELETE /api/products/$PRODUCT_ID_2 (second product deletion)..."
  curl -s -X DELETE "$BASE_URL/api/products/$PRODUCT_ID_2" || echo "Failed to delete second product"
  echo -e "\n"
else
  echo "10. No valid PRODUCT_ID_2 available for second deletion test"
  echo -e "\n"
fi

# Test 11: Delete another client to test multiple client deletions
if [ "$CLIENT_ID_2" != "null" ] && [ "$CLIENT_ID_2" != "" ]; then
  echo "11. Testing DELETE /api/clients/$CLIENT_ID_2 (second client deletion)..."
  curl -s -X DELETE "$BASE_URL/api/clients/$CLIENT_ID_2" || echo "Failed to delete second client"
  echo -e "\n"
else
  echo "11. No valid CLIENT_ID_2 available for second deletion test"
  echo -e "\n"
fi

# Test 12: Final verification - get remaining clients and products
echo "12. Final verification - getting remaining clients..."
curl -s "$BASE_URL/api/clients" | jq . || echo "Failed to get remaining clients"

echo -e "\n"

echo "13. Final verification - getting remaining products..."
curl -s "$BASE_URL/api/products" | jq . || echo "Failed to get remaining products"

echo -e "\n"

echo "14. Final verification - getting client history..."
curl -s "$BASE_URL/api/client-history" | jq . || echo "Failed to get client history"

echo -e "\n"

echo "✅ DELETE Operations Testing Complete!"
echo ""
echo "📋 Summary:"
echo "- Products should be completely removed from the database"
echo "- Clients should be removed from the main list but added to client history"
echo "- Client history should contain records of deleted clients"
