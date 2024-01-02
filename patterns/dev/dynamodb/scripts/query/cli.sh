#!/bin/bash

aws dynamodb query \
    --table-name ShopStore \
    --projection-expression "Price" \
    --key-condition-expression "Id = :v1" \
    --expression-attribute-values file://query.json \
    --return-consumed-capacity TOTAL