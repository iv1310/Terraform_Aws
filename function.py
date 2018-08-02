import os
import boto3
idServer = os.environ['ids']
idMonitoring = os.environ['id']
def handler(event, context):
    region = 'ap-northeast-1'
    ec2 = boto3.client('ec2', region_name=region)
    ec2.start_instances(InstanceIds=[idServer, idMonitoring], DryRun=False)
    print "Stopping your instance.."

