import boto3
import json

ec2_instance = boto3.resource('ec2', region_name='us-west-1')
def lambda_handler(event, context):
    instances = ec2_instance.instances.filter(Filters=[
        {
            'Name': 'instance-state-name',
            'Values': ['stopped']
        },
        {
            'Name': 'tag:Env',
            'Values':['Test']
        }
    ])
    for instance in instances:
        id = instance.id
        ec2_instance.instances.filter(InstanceIds=[id]).start()
        print("Instance ID is started :- " + instance.id)
    return "success"