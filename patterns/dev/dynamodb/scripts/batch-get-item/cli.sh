#!/bin/bash

aws dynamodb batch-write-item \
    --request-items file://expression.json \
    --return-consumed-capacity TOTAL 