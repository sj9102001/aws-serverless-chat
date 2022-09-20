import json

def lambda_handler(event, context):
    # TODO implement
    if 'action' not in event:
        print(event['requestContext']['action'])
    else:
        print(event['action'])
    return {
        'statusCode': 200
    }
