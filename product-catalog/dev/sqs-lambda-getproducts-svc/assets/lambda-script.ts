export const handler = async(event, context, callback): Promise<any> => {

    console.log('event')
    console.log(event)

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: event
        }),
    };
}
