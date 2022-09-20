import json

def validate(data):
    if data.get('message') is None or data.get('sentTo') is None or data.get('sentBy') is None or data.get('sentAt') is None or data.get('chatRoomId') is None:
        return False
    else:
        return True

def lambda_handler(event, context):
    # TODO implement
    print(event)
    data = json.loads(event['body'])
    
    print(data['message'])
    print(data['sentTo'])
    print(data['sentBy'])
    print(data['sentAt'])
    
    valResponse = validate(data)
    if valResponse is False:
        return {
            'statusCode': 200,
            'body': 'Invalid request'
        }

    # add the chat information in dynamoDB table(ChatRoom)



    return {
        'statusCode': 200,
        'body':'message sent'
    }

# ChatRoom PK - ChatRoomId, 

# ChatRoom -> {
#   ChatRoomId: String,
#   UserOne: String,
#   UserTwo: String,
#   Messages : [
#       "Time", "SentBy", "SentTo", "Message"
# ]
# }
