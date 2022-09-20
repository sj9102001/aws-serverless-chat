import json

# re module provides support
# for regular expressions
import re
import boto3
# importing Key to use in FilterExpression
from boto3.dynamodb.conditions import Key 
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
table_name = 'User'
user_table = dynamo.Table(table_name)

def search_user(name, isEmail):
    if isEmail is True:
        scan_kwargs = {
            'FilterExpression': Key('Email').eq(name),
        }
    else:
        scan_kwargs = {
            'FilterExpression': Key('Name').begins_with(name),
        }
    
    try:
        response_list = []
        done = False
        start_key = None

        while not done:
            if start_key:
                scan_kwargs['ExclusiveStartKey'] = start_key
            response = user_table.scan(**scan_kwargs)
            for item in response.get('Items', []):
                response_list.append(item)
            start_key = response.get('LastEvaluatedKey', None)
            done = start_key is None
    except botocore.exceptions.ClientError as e:
        print(e.response)
        return {'statusCode': 500, 'body':json.dumps({'Response': 'Please reach out to Support'})}
    

    if response_list:
        resp = {'statusCode': 200, 'body': json.dumps(response_list), 'headers': {'Content-Type':'application/json'}}
    else:
        resp = {'statusCode': 401, 'body': json.dumps({'Response': f"User don't exist with name: {name}"}), 'headers': {'Content-Type':'application/json'}}
    
    return resp


def lambda_handler(event, context):
    print(event)
    if 'pathParameters' not in event or event['httpMethod'] != 'GET':
        return {
            'statusCode': 400,
            'body': json.dumps({
                'Response': 'Bad Request'
            }),
            'headers': {
                'Content-Type':'application/json'
            }
        }

    searchQuery = event['pathParameters']['query']

    # Make a regular expression
    # for validating an Email
    regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'

    if(re.fullmatch(regex, searchQuery)):
        print('Valid email')
        # Search by email
        return search_user(str(searchQuery),True)
    else:
        print('Valid name')
        # Search by name
        return search_user(str(searchQuery).lower(),False)
