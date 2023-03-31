import json
import boto3
import os
import logging
import urllib
from botocore.exceptions import ClientError
import requests
import datetime
from smart_open import open
import csv
from botocore.client import Config
import base64
import argparse

## this implementation uses the executors credentials and saves the manifest file locally to be shared with external collaborators
## normal usage is: python presign_manifest.py --path s3://x/y/z/

def create_presigned_url(full_object, s3, expiration=604800):
    # Generate a presigned URL for the Manifest S3 object
    try:
        bucket_name = full_object.split('/', 1)[0]
        object_name = full_object.split('/', 1)[1]
        response = s3.generate_presigned_url('get_object', Params={
                                            'Bucket': bucket_name, 
                                            'Key': object_name}, 
                                            ExpiresIn=expiration)
    except ClientError as e:
        logging.error(e)
        return None
    return response
    
def list_objects(object_name, s3):
    obj_split = object_name[5:].split('/', 1)
    keys = []

    count = 1
    kwargs = {'Bucket': obj_split[0], 'Prefix': obj_split[1]}
    contin = True
    ## List objects in path
    while contin == True:
        resp = s3.list_objects_v2(**kwargs)

        ## Create presigned URL for each object
        for obj in resp['Contents']:
            tmp = {
                'id': count,
                'image_url': create_presigned_url(obj_split[0]+'/'+obj['Key'], s3)
            }
            count = count + 1

            ## Append presigned URL to list
            keys.append(tmp)
            try:
                kwargs['ContinuationToken'] = resp['NextContinuationToken']
            except KeyError:
                contin = False
    dates = str(datetime.datetime.now())

    ## Write list of presigned URLs to CSV in S3
    with open('./'+obj_split[1].replace('/','')+dates.split(' ')[0]+dates.split(' ')[1].replace(':',"-").replace('.','-')+'.csv', 'w') as c_out:
        writer = csv.writer(c_out, delimiter=',',
                            quotechar='"', quoting=csv.QUOTE_NONE)
        writer.writerow(keys[0].keys())
        for row in keys:
            writer.writerow(row.values())

    ## Presign the Manifest of Presigned URLs
    download = 'Manifest File created at: ./'+obj_split[1].replace('/','')+dates.split(' ')[0]+dates.split(' ')[1].replace(':',"-").replace('.','-')+'.csv'
    print(download)
    return download

def main(args):
    s3 = boto3.client('s3', 
        config=Config(signature_version='s3v4')
    )
    path = args.path
    response_str = list_objects(path, s3)

    return response_str


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Recursively append canonical IDs to all object ACLs in a bucket"
    )
    parser.add_argument(
        "--path",
        help="<required> S3 Bucket Path.",
        required=True
    )
    main(parser.parse_args())

# def test():
#   payload = {
#           "body": {
#             "token": "7zVpMLQd4vBd7d4nLkkzpD5l",
#             "user_name": 'elyud',
#             "text": [
#               'read',
#               's3://breeding-scratch-space/shared/figure8-out/D_P_Val_03_20_1/'
#             ],
#             "context": 'figure8'
#           }
#         }
#   lambda_handler(payload, 'hi')

# test()
