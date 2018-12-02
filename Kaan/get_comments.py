import json
import boto3
from decimal import *

class DecimalEncoder(json.JSONEncoder):
            def default(self, obj):
                if isinstance(obj, Decimal):
                    return float(obj)
                return json.JSONEncoder.default(self, obj)

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
    table = dynamodb.Table('mercedes_comments')
    
    error_code = event["error_code"]
    
    response = table.get_item(
        Key={
            "error_code": error_code
        }
    )
    
    try:
        response = table.get_item(
            Key={
                "error_code": error_code
            }
        )
    except ClientError as e:
        res = {
            'statusCode': 501,
            'body': json.dumps({"message": e.response['Error']['Message']})
        }
    else:
        try:
            comments = response['Item']['comments']
        except:
            res = {
                'statusCode': 404,
                'body': json.dumps({"message": "error_code not found"})
            }
        else:
            """
            res = {
                'statusCode': 200,
                'body': json.dumps({"comments": comments}, cls=DecimalEncoder)
            }
            """
            res = comments
    
    return res

