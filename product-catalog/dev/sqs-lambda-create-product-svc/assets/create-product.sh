#!/bin/bash

# curl -X POST https://bvhleyeimg.execute-api.eu-west-1.amazonaws.com/create-product \
curl -s -X POST https://product-catalog.witold-demo.com/create-product \
    -H 'content-type: application/json' \
    -H "timestamp: $(date +%s)" \
    -d '{"productName":"Milk", "price": "1.23", "productCategory": "dairy"}'
