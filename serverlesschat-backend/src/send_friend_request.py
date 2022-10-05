import json
import boto3
import botocore.exceptions

dynamo = boto3.resource('dynamodb')
table_name = 'Friend'
friend_table = dynamo.Table(table_name)


def add_to_received_requests(requestSentTo, requestSentBy):
    # add requestSentBy to requestSentTo's receivedRequest attribute
    try:
        friend_table.update_item(
            TableName=table_name,
            Key={
                'UserId': requestSentTo
            },
            UpdateExpression='SET #rr = list_append(if_not_exists(#rr, :empty_list), :requestSentBy)',
            ExpressionAttributeValues={
                ':requestSentBy': [requestSentBy],
                ':empty_list':  []
            },
            ExpressionAttributeNames={
                "#rr": "ReceivedRequests"
            }
        )

        return {
            'toContinue': True
        }
    except botocore.exceptions.ClientError as e:
        print(e)
        return {
            'toContinue': False
        }
    except:
        return {
            'toContinue': False
        }
def add_to_sent_requests(requestSentTo, requestSentBy):
    # add requestSentTo to requestSentBy's sentRequests attribute
    try:
        friend_table.update_item(
            TableName=table_name,
            Key={
                'UserId': requestSentBy
            },
            UpdateExpression='SET #sr = list_append(if_not_exists(#sr,:empty_list), :requestSentTo)',
            ExpressionAttributeValues={
                ':requestSentTo': [requestSentTo],
                ':empty_list': []
            },
            ExpressionAttributeNames={
                "#sr": "SentRequests"
            }
        )

        return {
            'isSuccesful': True
        }
    except botocore.exceptions.ClientError as e:
        print(e)
        return {
            'isSuccesful': False
        }
    except:
        return {
            'toContinue': False
        }

def lambda_handler(event, context):
    print(event)
    data = json.loads(event['body'])

    if data.get('sentTo') is None or data.get('sentBy') is None:
        return {
            'statusCode': 400,
            'body': json.dumps({'Response':'Bad request, either of sentBy or sentTo is missing'}),
            'headers': {
                'Content-Type':'application/json'
            }
        }

    requestSentTo = data['sentTo']
    requestSentBy = data['sentBy']
    # From PARAMS, ADD sentBy to ReceivedRequests of sentTo
    # From PARAMS, ADD sentTo to SentRequests of sentBy 

    resp = {}
    response_atrr = add_to_received_requests(requestSentTo, requestSentBy)
    
    if(response_atrr.get('toContinue') == True):
        response_atsr = add_to_sent_requests(requestSentTo, requestSentBy)
        
        if(response_atsr.get('isSuccesful') == True):
            return {
                'statusCode': 200,
                'body':json.dumps({'Response':'Succesfully sent friend request'}),
                'headers': {
                   'Content-Type':'application/json'
                }        
            }       
        else:
            resp = {
            'statusCode': 400,
            'body':json.dumps({'Response':'Failed to send friend request'}),
            'headers': {
               'Content-Type':'application/json'
            }   
        }    
    else:
        resp = {
            'statusCode': 400,
            'body':json.dumps({'Response':'Failed to send friend request'}),
            'headers': {
               'Content-Type':'application/json'
            }   
        }
    return resp