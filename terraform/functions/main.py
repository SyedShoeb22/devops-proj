import googleapiclient.discovery

PROJECT = "your-project-id"   # Replace
ZONE = "us-central1-a"        # Replace
INSTANCE = "devops-instance"  # Replace

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
