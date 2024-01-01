#!/bin/bash

aws dynamodb batch-write-item \
    --request-items file://batch-get-item.json \
    --return-consumed-capacity TOTAL 