import sys
sys.path.append('./py-deps')
import boto3

dynamodb = boto3.client("dynamodb")

response = dynamodb.query(
    ExpressionAttributeValues={
        ":v1": {
            "N": "101"
        }
    }, 
    KeyConditionExpression="Id = :v1", 
    ProjectionExpression="Price", 
    TableName="ShopStore"
)["Items"]

print(response)
