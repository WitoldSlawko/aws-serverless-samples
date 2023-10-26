import * as AWS from 'aws-sdk'
import { SQSEvent, Context } from 'aws-lambda';

const dynamoDbName = process.env.DYNAMODB_NAME

const dynamodb = new AWS.DynamoDB()

export const handler = async(event: SQSEvent, context: Context, callback): Promise<any> => {
    try {
        for (const e of event.Records) {

            const payload = JSON.parse(e.body)

            const params = {
                Item: {
                 "productName": {
                   S: payload.productName
                  }, 
                 "price": {
                   N: payload.price
                  }
                },
                TableName: dynamoDbName
            }

            const validatedParams = payload.productCategory != undefined ? {
                Item: Object.assign(params.Item, {
                    "productCategory": {
                        S: payload.productCategory
                }}),
                TableName: dynamoDbName
            } : params

            await dynamodb.putItem(validatedParams).promise()

        }
        callback(null, {
            statusCode: 200
        });
    } catch (error) {
        console.error(error);
        callback(error, {
            statusCode: error.statusCode
        });
      }
}
