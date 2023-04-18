import boto3, sys
aws_profile_name = sys.argv[1]
session = boto3.session.Session(profile_name=aws_profile_name)
s3 = session.resource('s3')
for bucket in s3.buckets.all():
     print("Name: {}".format(bucket.name))
     print("Creation Date: {}".format(bucket.creation_date))
#     for object in bucket.objects.all():
#                 print("Object: {}".format(object))
