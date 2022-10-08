import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
friend_table_name = 'Friend'
friend_table = dynamo.Table(friend_table_name)

user_table_name = 'User'
user_table = dynamo.Table(user_table_name)

def populate_response(data):
    print(data)
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

    if data["Item"].get("ReceivedRequests") is not None:
        user_id_list = []
        for item in data["Item"]["ReceivedRequests"]:
            user_id_list.append(item)

        data["Item"]["ReceivedRequests"].clear();        


        for user_id in user_id_list:
            item = {}
            res = user_table.get_item(
            TableName=user_table_name,
            Key={
                    'UserId': user_id
                }
            )

            name = res['Item'].get("Name","")
            bio = res['Item'].get("Bio","")
            email = res['Item'].get('Email')

            item["UserId"] = user_id
            item["Email"] = email
            item["Name"] = name
            item["Bio"] = bio

            data["Item"]["ReceivedRequests"].append(item)

    if data["Item"].get("SentRequests") is not None:
        user_id_list = []
        for item in data["Item"]["SentRequests"]:
            user_id_list.append(item)

        data["Item"]["SentRequests"].clear();        
        
        
        for user_id in user_id_list:
            item = {}
            res = user_table.get_item(
            TableName=user_table_name,
            Key={
                    'UserId': user_id
                }
            )

            name = res['Item'].get("Name","")
            bio = res['Item'].get("Bio","")
            email = res['Item'].get('Email')

            item["UserId"] = user_id
            item["Email"] = email
            item["Name"] = name
            item["Bio"] = bio

            data["Item"]["SentRequests"].append(item)


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
        print(response)
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