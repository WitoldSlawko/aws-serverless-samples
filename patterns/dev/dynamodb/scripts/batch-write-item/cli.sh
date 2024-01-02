#!/bin/bash

aws dynamodb batch-write-item \
    --request-items file://expression.json \
    --return-consumed-capacity INDEXES \
    --return-item-collection-metrics SIZE