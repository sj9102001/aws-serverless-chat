import json
import uuid
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')

friend_table_name = 'Friend'
friend_table = dynamo.Table(friend_table_name)

chatroom_table_name = 'ChatRoom'
chatroom_table = dynamo.Table(chatroom_table_name)

def bad_response():
    return {
        'statusCode': 400,
        'body': json.dumps({'Response':'Failed while accepting request, try again later!'}),
        'headers': {
            'Content-Type':'application/json'
        }
    }

def create_chatroom(userOne, userTwo):
    # create chatroom for both the users and store the id
    chatroomid = str(uuid.uuid4())
    try:
        chatroom_table.put_item(
            Item={
                'ChatRoomId': chatroomid,
                'UserOne': userOne,
                'UserTwo': userTwo,
                'Messages': []
            }
        )
        return {
            'chatroomId': chatroomid,
            'toContinue': True
        }
    except botocore.exceptions.ClientError as e:
        print(e)
        return {
            'toContinue': False
        }


# add the data to friend table itself
def update_user_friendlist(userOneId, userTwoId, chatroomId):
    # Add userTwoId, chatroomId in the user FriendList of userOneId
    try:
        friend_table.update_item(
            TableName=friend_table_name,
            Key={
                'UserId': userOneId
            },
            UpdateExpression='SET #fl = list_append(if_not_exists(#fl, :empty_list), :requestSentBy)',
            ExpressionAttributeValues={
                ':requestSentBy': [{'UserId':userTwoId,'ChatRoomId':chatroomId}],
                ':empty_list':  []
            },
            ExpressionAttributeNames={
                "#fl": "FriendList"
            }
        )
        return {'toContinue':True}
    except botocore.exceptions.ClientError as e:
        print(e)
        return {'toContinue':False}
    except:
        return {'toContinue':False}


def remove_from_list(userOne,userTwo,remove_from):
    try:
        r = friend_table.get_item(
            TableName=friend_table_name,
            Key={
                "UserId": userOne
            }
        )
        if remove_from == 'SENT_REQUESTS':
            response_list = r['Item']['SentRequests']
        else:
            response_list = r['Item']['ReceivedRequests']
        print(response_list)
        
        request_index = response_list.index(userTwo)
        print(request_index)

        if remove_from == 'SENT_REQUESTS':
            query = "REMOVE SentRequests[%d]" % (request_index)
        else:
            query = "REMOVE ReceivedRequests[%d]" % (request_index)

        friend_table.update_item(
            TableName=friend_table_name,
            Key={
                'UserId': userOne
            },
            UpdateExpression=query
        )
        return {'toContinue':True}
    except botocore.exceptions.ClientError as e:
        print(e)
        return {'toContinue':False}


def lambda_handler(event, context):
    print(event)
    data = json.loads(event['body'])

    if data.get('user') is None or data.get('acceptedUser') is None:
        return {
            'statusCode': 400,
            'body': json.dumps({'Response':'Bad request'}),
            'headers': {
                'Content-Type':'application/json'
            }
        }

    acceptorUserId = data.get('user')
    accepteeUserId = data.get('acceptedUser')

    toContinue = True

    # Creating chatroom for both the users and fetching chatroomId
    create_chatroom_response = create_chatroom(acceptorUserId, accepteeUserId)

    chatroomId = create_chatroom_response['chatroomId']
    toContinue = create_chatroom_response.get('toContinue')

    print(chatroomId)

    # Updating both the users friendlist
    if toContinue == True:
        update_user_friendlist_response = update_user_friendlist(acceptorUserId, accepteeUserId, chatroomId)
        toContinue = update_user_friendlist_response.get('toContinue')
    else:
        return bad_response()

    if toContinue == True:
        update_user_friendlist_response = update_user_friendlist(accepteeUserId, acceptorUserId, chatroomId)
        toContinue = update_user_friendlist_response.get('toContinue')
    else:
        return bad_response()

    # Remove "acceptorUserId" from sentRequest of "accepteeUserId"   
    if toContinue == True:
        remove_from_sent_response = remove_from_list(accepteeUserId,acceptorUserId,'SENT_REQUESTS')
        toContinue = remove_from_sent_response.get('toContinue')
    else:
        return bad_response()

    # Remove "accepteeUserId" from ReceivedRequests of "acceptorUserId"
    if toContinue == True:
        remove_from_received_response = remove_from_list(acceptorUserId,accepteeUserId,"RECEIVED_REQUESTS")
    else:
        return bad_response()

    if remove_from_received_response.get('toContinue') is False:
        return bad_response()

    return {
        'statusCode':200, 
        'body':json.dumps({"Response":"Accepted friend request succesfully"}),
        'headers':{
            'Content-Type':'application/json'
        }
    }
