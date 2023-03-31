import boto3
import pandas as pd
client = boto3.client('sagemaker')

response = client.list_apps(
    MaxResults=100,
    SortOrder='Ascending',
    SortBy='CreationTime',
    DomainIdEquals='<Domain-Name>',
)
df = pd.json_normalize(response, record_path=['Apps'], sep='|').set_axis(['DomainId', 'UserProfileName', 'AppName', 'AppType', 'Status', 'CreationTime' ], axis=1)
df = df[df.Status=='InService']
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', -1)
print(df.sort_values(by=['UserProfileName']))
