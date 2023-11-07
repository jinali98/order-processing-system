export const lambdaHandler = async (event) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      test: "Hello World",
    }),
    headers: {
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      "Access-Control-Allow-Credentials": true,
      "Content-Type": "application/json",
    },
  };
  return response;
};
