import * as AWS from 'aws-sdk'

const getCallerIdentity = () => {
    const sts = new AWS.STS()
    const params = {}
    return sts.getCallerIdentity(params).promise()
}

const query = (dynamodb, params) => {
    return dynamodb.query(params).promise()
}

//

(async () => {

    // const awsEnv = process.argv[2]
    // process.env.AWS_SDK_LOAD_CONFIG=1
    // const creds = new AWS.SharedIniFileCredentials({profile: process.env.AWS_PROFILE})

    const dynamodb = new AWS.DynamoDB({
        region: "eu-west-1"
    });

    const params = {
        ExpressionAttributeValues: {
            ":v1": {
                N: "101"
            }
        }, 
        KeyConditionExpression: "Id = :v1", 
        ProjectionExpression: "Price", 
        TableName: "ShopStore"
    }

    const queryItems = (await query(dynamodb, params)).Items

    console.log(queryItems)

})();
