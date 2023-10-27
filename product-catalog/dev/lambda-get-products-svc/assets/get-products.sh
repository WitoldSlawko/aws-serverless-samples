#!/bin/bash

# curl -X POST https://bvhleyeimg.execute-api.eu-west-1.amazonaws.com/get-products \
curl -s -X POST https://product-catalog.witold-demo.com/get-products \
    -H 'content-type: application/json'