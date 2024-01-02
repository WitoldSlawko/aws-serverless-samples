import * as AWS from 'aws-sdk'

const getCallerIdentity = () => {
    const sts = new AWS.STS()
    const params = {}
    return sts.getCallerIdentity(params).promise()
}

const batchGetItem = (dynamodb, params) => {
    return dynamodb.batchGetItem(params).promise()
}

//

(async () => {

    // const awsEnv = process.argv[2]
    // process.env.AWS_SDK_LOAD_CONFIG=1
    // const creds = new AWS.SharedIniFileCredentials({profile: process.env.AWS_PROFILE})

    const dynamodb = new AWS.DynamoDB({
        region: "eu-west-1"
    });

    const tableName = "ShopStore"

    let params = {}
    params["RequestItems"] = {}

    params["RequestItems"][`${tableName}`] = {
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

    // const params = {
        // RequestItems: {
            // "ShopStore": {
            //     "Keys": [
            //         {
            //             "Title": {"S": "Book 101 Title"},
            //             "Id": {"N": "101"}
            //         },
            //         {
            //             "Title": {"S": "18-Bike-201"},
            //             "Id": {"N": "201"}
            //         }
            //     ],
            //     "ProjectionExpression":"Price"
            // }
        // }
    // }

    const batchedGotItems = (await batchGetItem(dynamodb, params))["Responses"][`${tableName}`]

    console.log(batchedGotItems)

})();
