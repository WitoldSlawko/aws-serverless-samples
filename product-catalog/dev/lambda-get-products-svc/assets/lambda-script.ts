import * as AWS from 'aws-sdk'
import { APIGatewayEvent, Context } from 'aws-lambda';

const dynamoDbName = process.env.DYNAMODB_NAME

const dynamodb = new AWS.DynamoDB()

export const handler = async(event: APIGatewayEvent, context: Context, callback): Promise<any> => {
    try {

        const params = {
            TableName: dynamoDbName
        }

        const dynamoDbItems = await dynamodb.scan(params).promise()

        return {
            statusCode: 200,
            body: JSON.stringify(dynamoDbItems.Items)
        }
    } catch (error) {
        console.error(error);
        callback(error, {
            statusCode: error.statusCode
        });
      }
}
