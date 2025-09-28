#!/bin/bash

echo "🧪 Testing Client History Functionality"
echo "======================================"

BASE_URL="http://localhost:8080"

# Test 1: Health Check
echo "1. Testing Health Check..."
curl -s "$BASE_URL/actuator/health" | jq . || echo "Health check failed"

echo -e "\n"

# Test 2: Check client history before any deletions
echo "2. Checking client history before deletions..."
curl -s "$BASE_URL/api/client-history" | jq . || echo "Failed to get client history"

echo -e "\n"

# Test 3: Get a client to delete
echo "3. Getting a client to delete..."
CLIENTS_RESPONSE=$(curl -s "$BASE_URL/api/clients")
CLIENT_ID=$(echo "$CLIENTS_RESPONSE" | jq -r '.[-1].id' 2>/dev/null)
echo "Using CLIENT_ID for deletion: $CLIENT_ID"

if [ "$CLIENT_ID" != "null" ] && [ "$CLIENT_ID" != "" ]; then
  echo "Client details before deletion:"
  curl -s "$BASE_URL/api/clients/$CLIENT_ID" | jq . || echo "Failed to get client details"
  echo -e "\n"
  
  # Test 4: Delete the client
  echo "4. Deleting client $CLIENT_ID..."
  curl -s -X DELETE "$BASE_URL/api/clients/$CLIENT_ID" || echo "Failed to delete client"
  echo -e "\n"
  
  # Test 5: Verify client is deleted from main list
  echo "5. Verifying client deletion from main list..."
  curl -s "$BASE_URL/api/clients/$CLIENT_ID" | jq . || echo "Client successfully deleted (404 expected)"
  echo -e "\n"
  
  # Test 6: Check client history after deletion
  echo "6. Checking client history after deletion..."
  curl -s "$BASE_URL/api/client-history" | jq . || echo "Failed to get client history"
  echo -e "\n"
else
  echo "No valid CLIENT_ID available for testing"
fi

echo "✅ Client History Testing Complete!"
