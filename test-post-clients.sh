#!/bin/bash

echo "🧪 Testing POST Operations for Clients and Products"
echo "=================================================="

BASE_URL="http://localhost:8080"

# First, let's get the existing product IDs to attach to clients
echo "1. Getting existing products..."
PRODUCTS_RESPONSE=$(curl -s "$BASE_URL/api/products")
echo "$PRODUCTS_RESPONSE" | jq .

# Extract product IDs (we'll use the first few)
PRODUCT_ID_1=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[0].id' 2>/dev/null)
PRODUCT_ID_2=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[1].id' 2>/dev/null)
PRODUCT_ID_3=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[2].id' 2>/dev/null)
PRODUCT_ID_4=$(echo "$PRODUCTS_RESPONSE" | jq -r '.[3].id' 2>/dev/null)

echo -e "\nProduct IDs found:"
echo "Product 1: $PRODUCT_ID_1"
echo "Product 2: $PRODUCT_ID_2"
echo "Product 3: $PRODUCT_ID_3"
echo "Product 4: $PRODUCT_ID_4"

echo -e "\n"

# Create Client 1: Maria Garcia (will have 2 products)
echo "2. Creating Client 1: Maria Garcia..."
CLIENT1_RESPONSE=$(curl -s -X POST "$BASE_URL/api/clients" \
  -H "Content-Type: application/json" \
  -d '{
    "cnp": "1111111111111",
    "firstName": "Maria",
    "lastName": "Garcia",
    "email": "maria.garcia@example.com"
  }')

echo "Client 1 created:"
echo "$CLIENT1_RESPONSE" | jq . || echo "$CLIENT1_RESPONSE"

CLIENT1_ID=$(echo "$CLIENT1_RESPONSE" | jq -r '.id' 2>/dev/null)

echo -e "\n"

# Create Client 2: John Smith (will have 3 products)
echo "3. Creating Client 2: John Smith..."
CLIENT2_RESPONSE=$(curl -s -X POST "$BASE_URL/api/clients" \
  -H "Content-Type: application/json" \
  -d '{
    "cnp": "2222222222222",
    "firstName": "John",
    "lastName": "Smith",
    "email": "john.smith@example.com"
  }')

echo "Client 2 created:"
echo "$CLIENT2_RESPONSE" | jq . || echo "$CLIENT2_RESPONSE"

CLIENT2_ID=$(echo "$CLIENT2_RESPONSE" | jq -r '.id' 2>/dev/null)

echo -e "\n"

# Create Client 3: Sarah Johnson (will have 4 products)
echo "4. Creating Client 3: Sarah Johnson..."
CLIENT3_RESPONSE=$(curl -s -X POST "$BASE_URL/api/clients" \
  -H "Content-Type: application/json" \
  -d '{
    "cnp": "3333333333333",
    "firstName": "Sarah",
    "lastName": "Johnson",
    "email": "sarah.johnson@example.com"
  }')

echo "Client 3 created:"
echo "$CLIENT3_RESPONSE" | jq . || echo "$CLIENT3_RESPONSE"

CLIENT3_ID=$(echo "$CLIENT3_RESPONSE" | jq -r '.id' 2>/dev/null)

echo -e "\n"

# Create Client 4: Alex Brown (will have 0 products - empty case)
echo "5. Creating Client 4: Alex Brown (no products)..."
CLIENT4_RESPONSE=$(curl -s -X POST "$BASE_URL/api/clients" \
  -H "Content-Type: application/json" \
  -d '{
    "cnp": "4444444444444",
    "firstName": "Alex",
    "lastName": "Brown",
    "email": "alex.brown@example.com"
  }')

echo "Client 4 created:"
echo "$CLIENT4_RESPONSE" | jq . || echo "$CLIENT4_RESPONSE"

CLIENT4_ID=$(echo "$CLIENT4_RESPONSE" | jq -r '.id' 2>/dev/null)

echo -e "\n"

# Now attach products to clients
if [ "$CLIENT1_ID" != "null" ] && [ "$CLIENT1_ID" != "" ]; then
  echo "6. Attaching 2 products to Maria Garcia (Client 1)..."
  
  if [ "$PRODUCT_ID_1" != "null" ] && [ "$PRODUCT_ID_1" != "" ]; then
    echo "  - Attaching Product 1..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT1_ID/products/$PRODUCT_ID_1" | jq . || echo "Failed to attach product 1"
  fi
  
  if [ "$PRODUCT_ID_2" != "null" ] && [ "$PRODUCT_ID_2" != "" ]; then
    echo "  - Attaching Product 2..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT1_ID/products/$PRODUCT_ID_2" | jq . || echo "Failed to attach product 2"
  fi
fi

echo -e "\n"

if [ "$CLIENT2_ID" != "null" ] && [ "$CLIENT2_ID" != "" ]; then
  echo "7. Attaching 3 products to John Smith (Client 2)..."
  
  if [ "$PRODUCT_ID_1" != "null" ] && [ "$PRODUCT_ID_1" != "" ]; then
    echo "  - Attaching Product 1..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT2_ID/products/$PRODUCT_ID_1" | jq . || echo "Failed to attach product 1"
  fi
  
  if [ "$PRODUCT_ID_2" != "null" ] && [ "$PRODUCT_ID_2" != "" ]; then
    echo "  - Attaching Product 2..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT2_ID/products/$PRODUCT_ID_2" | jq . || echo "Failed to attach product 2"
  fi
  
  if [ "$PRODUCT_ID_3" != "null" ] && [ "$PRODUCT_ID_3" != "" ]; then
    echo "  - Attaching Product 3..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT2_ID/products/$PRODUCT_ID_3" | jq . || echo "Failed to attach product 3"
  fi
fi

echo -e "\n"

if [ "$CLIENT3_ID" != "null" ] && [ "$CLIENT3_ID" != "" ]; then
  echo "8. Attaching 4 products to Sarah Johnson (Client 3)..."
  
  if [ "$PRODUCT_ID_1" != "null" ] && [ "$PRODUCT_ID_1" != "" ]; then
    echo "  - Attaching Product 1..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT3_ID/products/$PRODUCT_ID_1" | jq . || echo "Failed to attach product 1"
  fi
  
  if [ "$PRODUCT_ID_2" != "null" ] && [ "$PRODUCT_ID_2" != "" ]; then
    echo "  - Attaching Product 2..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT3_ID/products/$PRODUCT_ID_2" | jq . || echo "Failed to attach product 2"
  fi
  
  if [ "$PRODUCT_ID_3" != "null" ] && [ "$PRODUCT_ID_3" != "" ]; then
    echo "  - Attaching Product 3..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT3_ID/products/$PRODUCT_ID_3" | jq . || echo "Failed to attach product 3"
  fi
  
  if [ "$PRODUCT_ID_4" != "null" ] && [ "$PRODUCT_ID_4" != "" ]; then
    echo "  - Attaching Product 4..."
    curl -s -X POST "$BASE_URL/api/clients/$CLIENT3_ID/products/$PRODUCT_ID_4" | jq . || echo "Failed to attach product 4"
  fi
fi

echo -e "\n"

# Client 4 (Alex Brown) gets 0 products - that's our empty case

echo "9. Final verification - Getting all clients..."
curl -s "$BASE_URL/api/clients" | jq .

echo -e "\n✅ POST Operations Complete!"
echo "Summary:"
echo "- Maria Garcia: 2 products"
echo "- John Smith: 3 products" 
echo "- Sarah Johnson: 4 products"
echo "- Alex Brown: 0 products"
