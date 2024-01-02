import sys
sys.path.append('./py-deps')
import boto3

dynamodb = boto3.client("dynamodb")

response = dynamodb.batch_get_item(
    RequestItems={
        "ShopStore": {
            "Keys": [
            {
                "Title": {"S": "Book 101 Title"},
                "Id": {"N": "101"}
            },
            {
                "Title": {"S": "18-Bike-201"},
                "Id": {"N": "201"}
            }
        ],
        "ProjectionExpression":"Price"
        }
    }
)["Responses"]["ShopStore"]

print(response)
