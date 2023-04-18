S3logbucketname='buket-name'
region='us-east-1'

  # List buckets in this account
  buckets="$(aws s3 ls | awk '{print $3}')"
  
  # Put bucket logging on each bucket
  for bucket in $buckets
    do 
      aws s3api put-bucket-logging --bucket $bucket --bucket-logging-status '{"LoggingEnabled":{"TargetPrefix":"S3-Access-logs/'$i'/","TargetBucket":"'S3logbucketname'"}}'
      echo "$bucket done"
    done
