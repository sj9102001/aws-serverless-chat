import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
table_name = 'User'
user_table = dynamo.Table(table_name)

def user_detail(data):
    resp = {}

    if data.get('UserId') is None:
        statusCode = 400
        message = {
            'Response':'Bad Request, Missing userId'
        }
        headers = {
            'Content-Type':'application/json'
        }
        return {
            'statusCode':statusCode,
            'body':json.dumps(message),
            'headers':headers
        }

    userId = data.get('UserId')

    try:
        response = user_table.get_item(
            TableName=table_name,
            Key={
                'UserId': userId
            }
        )
        print(response)
        statusCode = 201
        message = {
            'Response':response['Item']
        }   
        headers = {
            'Content-Type':'application/json'
        }
        resp = {
        'statusCode':statusCode, 
        'body':json.dumps(message),
        'headers':headers
        }
    except botocore.exceptions.ClientError as e:
        print(e)
        statusCode = 400
        message = {
            'Response':'Error occured.'
        }
        headers = {
            'Content-Type':'application/json'
        }
        resp = {
            'statusCode':statusCode, 
            'body':json.dumps(message),
            'headers':headers
        }                

    return resp


def lambda_handler(event, context):
    print(event)

    if 'body' not in event or event['httpMethod'] != 'POST':
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
    return user_detail(data) 
