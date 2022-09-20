import json
import uuid
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')

user_table_name = 'User'
user_table = dynamo.Table(user_table_name)

add_friend_table_name = 'AddFriend'
add_friend_table = dynamo.Table(add_friend_table_name)

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
    chatroomid = uuid.uuid4()
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
            'chatroomid': chatroomid,
            'toContinue': True
        }
    except botocore.exceptions.ClientError as e:
        print(e)
        return {
            'toContinue': False
        }



def update_user_friendlist(userOneId, userTwoId, chatroomId):
    # Add userTwoId, chatroomId in the user FriendList of userOneId
    try:
        user_table.update_item(
            TableName=user_table_name,
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


def remove_from_sent():
    # Remove "user" from sentRequest of "acceptedUser"   
    try:
        
    except botocore.exceptions.ClientError as e:
        print(e)
        return bad_response()

def remove_from_received():
    # Remove "acceptedUser" from receivedRequest of "user"
    pass

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

    acceptor = data.get('user')
    acceptee = data.get('acceptedUser')

    toContinue = True

    create_chatroom_response = create_chatroom(acceptor, acceptee)

    chatroomId = create_chatroom_response.get('chatroomId')
    toContinue = create_chatroom_response.get('toContinue')

    if toContinue == True:
        update_user_friendlist_response = update_user_friendlist(acceptor, acceptee, chatroomId)
        toContinue = update_user_friendlist_response.get('toContinue')
    else:
        return bad_response()
    
    if toContinue == True:
        update_user_friendlist_response = update_user_friendlist(acceptee, acceptor, chatroomId)
        toContinue = update_user_friendlist_response.get('toContinue')
    else:
        return bad_response()

    if toContinue == True:
        remove_from_sent_response = remove_from_sent()
        toContinue = remove_from_sent_response.get('toContinue')
    else:
        return bad_response()

    if toContinue == True:
        remove_from_received_response = remove_from_received()
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

# PARAMS={
#     'user':'userId',
#     'acceptedUser':'userIdOfAccepted'
# }