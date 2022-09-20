import boto3

dynamo = boto3.resource('dynamodb')

connectionUserTableName = 'ConnectionUser'
connectionUserTable = dynamo.Table(connectionUserTableName)

def lambda_handler(event, context):
    print(event)
    # check is userId exists in header
    if 'userId' not in event['headers']:
        return {
            'statusCode': 400
        }
    
    # add connectionId, userId to UserConnection, ConnectionUser table
    connectionId = event['requestContext']['connectionId']
    userId = event['headers']['userId']
    
    params = {
        "UserId": userId,
        "ConnectionId":connectionId
    }
    
    response = connectionUserTable.put_item(TableName=connectionUserTableName,
        Item=params,
        ConditionExpression=f"attribute_not_exists(ConnectionId)"

    )
    
    return {
        'statusCode': 200,
    }
