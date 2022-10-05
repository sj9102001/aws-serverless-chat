import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
friend_table_name = 'Friend'
friend_table = dynamo.Table(friend_table_name)

user_table_name = 'User'
user_table = dynamo.Table(user_table_name)

def populate_response(data):
    for item in data["Item"]["FriendList"]:
        user_id = item["UserId"]

        # Get user details with userId: user_id
        res = user_table.get_item(
            TableName=user_table_name,
            Key={
                'UserId': user_id
            }
        )

        name = res['Item'].get("Name","")
        bio = res['Item'].get("Bio","")
        email = res['Item'].get('Email')

        item["Email"] = email
        item["Name"] = name
        item["Bio"] = bio

    return data['Item']

def fetch_friends(data):
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
        response = friend_table.get_item(
            TableName=friend_table_name,
            Key={
                'UserId': userId
            }
        )
        populated_response = populate_response(response)
        statusCode = 201
        message = {
            'Response':populated_response
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
    return fetch_friends(data)  