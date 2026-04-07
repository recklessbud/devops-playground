import boto3
import json


def lambda_handler(event, context):
    bucket_name = event['bucket_name']
    
    s3 = boto3.client('s3')
     
    response = s3.list_objects_v2(Bucket=bucket_name)
    
    if 'Contents' not in response:
        return {
            'statusCode': 200,
            'body': json.dumps({ 
                'bucket': bucket_name,
                'objects': [], 
                'count': 0
            })
        }
     
    objects = [obj['Key'] for obj in response['Contents']]
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'bucket': bucket_name,
            'objects': objects,
            'count': len(objects)
        })
    }