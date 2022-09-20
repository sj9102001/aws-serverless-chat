import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
table_name = 'User'
user_table = dynamo.Table(table_name)

def fetch_users():
    resp = {}

    try:
        response = user_table.scan()
        message=response['Items']
        statusCode = 200
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
    return resp 




def lambda_handler(event, context):
    print(event)

    if event['httpMethod'] != 'GET':   
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

    return fetch_users() 