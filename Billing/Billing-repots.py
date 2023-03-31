import boto3
import pandas as pd


client = boto3.client('ce', region_name='us-east-1')

response = client.get_cost_and_usage(
    TimePeriod={
        'Start': '2023-03-01',
        'End': '2023-03-14'
    },
    Granularity='MONTHLY',
    Metrics=[
        'AmortizedCost',
    ]
)
print (response)
#df = pd.json_normalize(response)
df = pd.json_normalize(response, "ResultsByTime").drop('Groups' ,axis='columns')
print(df.to_string(index=False))
