import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
table_name = 'User'
user_table = dynamo.Table(table_name)

friend_table_name = 'Friend'
friend_table = dynamo.Table(friend_table_name)

def add_user(data):
    resp = {}

    if data.get('Email') is None or data.get('UserId') is None:
        statusCode = 400
        message = {
            'Response':'Bad Request, Missing either userId or email'
        }
        headers = {
            'Content-Type':'application/json'
        }
        return {
            'statusCode':statusCode,
            'body':json.dumps(message),
            'headers':headers
        }

    params = {
        'UserId':data.get('UserId'),
        'Email':data.get('Email')
    }

    try:
        response = user_table.put_item(
            TableName=table_name,
            Item=params,
            ConditionExpression=f"attribute_not_exists(UserId)",
        )
        res = friend_table.put_item(
            TableName=friend_table_name,
            Item={
                'UserId': data.get('UserId')
            },
            ConditionExpression=f"attribute_not_exists(UserId)",
        )
        statusCode = 201
        message = {
            'Response':'User created'
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
        if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
            statusCode = 201
            message = {
                'Response':'User already exist.'
            }
            headers = {
                'Content-Type':'application/json'
            }
            resp = {
                'statusCode':statusCode, 
                'body':json.dumps(message),
                'headers':headers
            }
        else:
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
    return add_user(data) 
