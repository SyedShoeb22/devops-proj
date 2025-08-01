import os
import googleapiclient.discovery

PROJECT = os.environ.get("PROJECT")
ZONE = os.environ.get("ZONE")
INSTANCE = os.environ.get("INSTANCE")

def start_vm(request):
    compute = googleapiclient.discovery.build('compute', 'v1')
    compute.instances().start(project=PROJECT, zone=ZONE, instance=INSTANCE).execute()
    return "VM Started"

def stop_vm(request):
    compute = googleapiclient.discovery.build('compute', 'v1')
    compute.instances().stop(project=PROJECT, zone=ZONE, instance=INSTANCE).execute()
    return "VM Stopped"

def delete_vm(request):
    compute = googleapiclient.discovery.build('compute', 'v1')
    compute.instances().delete(project=PROJECT, zone=ZONE, instance=INSTANCE).execute()
    return "VM Deleted"
