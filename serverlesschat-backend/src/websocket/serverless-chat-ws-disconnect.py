import boto3

dynamo = boto3.resource('dynamodb')

connectionUserTableName = 'ConnectionUser'
connectionUserTable = dynamo.Table(connectionUserTableName)

def lambda_handler(event, context):
    print(event)
    # remove connectionId, userId to UserConnection, ConnectionUser table
    connectionId = event['requestContext']['connectionId']
    
    response_cu = connectionUserTable.delete_item(TableName=connectionUserTableName,
        Key={
            'ConnectionId':connectionId
        }
    )
    
    return {
        'statusCode': 200,
    }
