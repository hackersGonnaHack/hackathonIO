import json
import boto3
import uuid
import time

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
    table = dynamodb.Table('mercedes_comments')
    
    error_code = event["error_code"]
    comment = event["comment"]
    name = event["name"]
    
    table.update_item(
    Key={
        'error_code': error_code
    },
    UpdateExpression='SET comments = list_append(if_not_exists(comments, :empty_list), :comment_obj)',
    ExpressionAttributeValues={
        ":comment_obj": [
            {
                'id': str(uuid.uuid4()),
                'name': name,
                'date': int(time.time()),
                'comment': comment
            }
        ],
            ":empty_list":[]
        }
    )

    return {
        'statusCode': 200
    }

