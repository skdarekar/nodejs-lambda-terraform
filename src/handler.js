// handler.js
exports.handler = async (event, context) => {
    // Your Lambda function logic goes here
    console.log('Lambda function executed successfully');
 
    // You can return a response if needed
    return {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
 };
 