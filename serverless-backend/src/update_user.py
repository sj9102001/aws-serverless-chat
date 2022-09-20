import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
table_name = 'User'
user_table = dynamo.Table(table_name)


def lambda_handler(event, context):
    print(event)

    if event['httpMethod'] != 'POST':   
        statusCode = 400
        message = {
            'Response':'Bad Request'
        }
        headers = {
            'Content-Type':'application/json'
        }

        return {
        'statusCode':statusCode, 
        'body':json.dumps(message),
        'headers':headers
        }

    data = json.loads(event['body'])

    if data.get('UserId') is None:
        return {
        'statusCode':400, 
        'body':json.dumps({
            'Response':'missing userId'
            }
        ),
        'headers':{
            'Content-Type':'application/json'
            }
        }

    userId = data.get('UserId')
    name = data.get('Name').lower()
    resp = {}

    try:
        response = user_table.update_item(
            TableName=table_name,
            Key={
                'UserId': userId
            },
            UpdateExpression='SET #nm = :name',
            ExpressionAttributeValues={
                ':name': name
            },
            ExpressionAttributeNames={
                "#nm": "Name"
            }
        )
        statusCode = 200
        message = {
            'Response':'User updated succesfully'
        }
        headers = {
            'Content-Type':'application/json'
        }
        resp = {
            'statusCode':statusCode, 
            'body':json.dumps(message),
            'headers':headers
        }
    except botocore.exceptions.ClientError as er:
        print(er)
        statusCode = 502
        message = {
            'Response':'Server error'
        }
        headers = {
            'Content-Type':'application/json'
        }
        resp = {
            'statusCode':statusCode, 
            'body':json.dumps(message),
            'headers':headers
        }
    except:
        return {
        'statusCode':500, 
        'body':json.dumps({
            'Response':'Server error'
            }
        ),
        'headers':{
            'Content-Type':'application/json'
            }
        }

    return resp 