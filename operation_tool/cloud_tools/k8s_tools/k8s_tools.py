# /bin/python

import subprocess
import os
import requests
import base64
import sys

# operations = {{ operations.k8s }}

operations = {
    "kube_config": "/root/.kube/config",
    "operations":{
        "label": {
            "enabled": True,
            "tasks": [
                  {
                    "namespaces": ["aaa"],
                    "controllers": [],
                    "labels": ["aa=11"],
                    "annotations": [],
                    "restart": True
                  }
            ]
        },
        "get_all": {
            "enabled": False,
            "export_dir": "/tmp/k8s"
        },
        "restore_global": {
            "enabled": False,
            "import_dir": "/tmp/k8s"
        },
        "list_images": {
            "enabled": False,
            "registry_url": "http://192.168.6.111:5000",
            "username": "admin",
            "password": "Harbor12345"
        }
    }
}

export_dir = operations["operations"]["get_all"]["export_dir"]
import_dir = operations["operations"]["restore_global"]["import_dir"]
kube_config = operations["kube_config"]

#http://192.168.1.1:5000
registry_url = operations["operations"]["list_images"]["registry_url"]
username_password = "%s:%s" %(operations["operations"]["list_images"]["username"], operations["operations"]["list_images"]["password"])

def run_shell(command, get_error = False, igonre_error = True):

    my_env = {
        "KUBECONFIG": kube_config
    }

    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env = my_env)
    if result.returncode != 0:
        if not igonre_error:
            raise Exception("failed to run: %s" %command)
        else:
            print("failed to run: %s" %command)

    if get_error:
        ret = [i for i in result.stderr.decode().split('\n') if i != '']
        return ret
    else:
        ret = [i for i in result.stdout.decode().split('\n') if i != '']
        return ret

def get_all():

    resources_exception = ["pods", "replicasets", "events", "controllerrevisions"]
    global_resources_exception = ["nodes", "apiservices", "componentstatuses"]

    #create directories
    try:
        os.mkdir(export_dir)
    except FileExistsError:
        pass
    namespaces = run_shell("kubectl get ns --no-headers=true | awk '{print $1}'")
    resources = run_shell("kubectl api-resources --namespaced=true --no-headers=true | awk '{print $1}'")
    resources = list(set(resources))
    for exception in resources_exception:
        resources.remove(exception)

    global_resources = run_shell("kubectl api-resources --namespaced=false --no-headers=true | awk '{print $1}'")
    global_resources = list(set(global_resources))
    for exception in global_resources_exception:
        global_resources.remove(exception)

    for ns in namespaces:
        try:
            os.mkdir(os.path.join(export_dir, ns))
        except FileExistsError:
            pass

        for resource in resources:
            instances = run_shell("kubectl get %s -n %s --no-headers=true  | awk '{print $1}'" %(resource, ns))
            if instances:
                try:
                    instances_dir = os.path.join(os.path.join(export_dir, ns), resource)
                    os.mkdir(instances_dir)
                except FileExistsError:
                    pass

                if resource.strip() == "serviceaccounts":
                    instances.remove("default")
                elif resource.strip() == "secrets":
                    command = 'kubectl get secrets -n %s -o=jsonpath=\'{.items[?(@.metadata.annotations.kubernetes\.io/service-account\.name=="default")].metadata.name}\' | tr " " "\\n"' %ns
                    secret_name = run_shell(command)
                    if secret_name:
                        instances.remove(secret_name[0])
                elif resource.strip() == "endpoints":
                    command = 'kubectl get services -n %s -o=jsonpath=\'{.items[?(@.spec.selector)].metadata.name}\' | tr " " "\\n"' %ns
                    service_names = run_shell(command)

                    for service in service_names:
                        if service in instances:
                            instances.remove(service)

                for instance in instances:
                    run_shell("kubectl get %s %s -n %s -o yaml > %s.yaml" %(resource, instance, ns, os.path.join(instances_dir, instance)))


    try:
        os.mkdir(os.path.join(export_dir, "global"))
    except FileExistsError:
        pass

    for resource in global_resources:
        instances = run_shell("kubectl get %s --no-headers=true  | awk '{print $1}'" %resource)
        if instances:
            try:
                instances_dir = os.path.join(os.path.join(export_dir, "global"), resource)
                os.mkdir(instances_dir)
            except FileExistsError:
                pass

            for instance in instances:
                run_shell("kubectl get %s %s -o yaml > %s.yaml" %(resource, instance, os.path.join(instances_dir, instance)))

def restore(resource_type, resources, rs_dir):
    present_resources = run_shell("kubectl get %s --no-headers=true | awk '{print $1}'" %resource_type)
    for resource in resources:
        if resource not in present_resources:
            try:
                run_shell("kubectl apply -f %s" % os.path.join(rs_dir, resource))
            except Exception:
                print("restore failed:  %s" % os.path.join(rs_dir, resource))
            else:
                print("restore succeeded:     %s" % os.path.join(rs_dir, resource))

def restore_global():
    """
    restore the listing resources:
        namespaces
        clusterrole
        clusterroledinding
        pv
    :return:
    """
    global_path = os.path.join(import_dir, "global")
    resources_type = ["namespaces", "clusterroles", "clusterrolebindings"]

    for rs_type in resources_type:
        restore(rs_type, os.listdir(os.path.join(global_path, rs_type)), os.path.join(global_path, rs_type))

def list_images():
    ret = []
    repo_url = registry_url.rstrip("/") + "/v2/_catalog"
    if username_password.strip():
        headers = {
            "Authorization": "Basic %s" %base64.b64encode(username_password.encode()).decode("utf-8")
        }
    else:
        headers = {}

    response = requests.get(repo_url, verify = False, headers = headers)
    repos = response.json()["repositories"]

    for repo in repos:
        image_url = registry_url.rstrip("/") + "/v2/%s" %repo + "/tags/list"
        response = requests.get(image_url, verify = False, headers = headers)
        tags = response.json()["tags"]
        if tags:
            for tag in tags:
                ret.append("%s:%s" %(repo, tag))
    for image in ret:
        print(image)

def label():

    for task in operations["operations"]["label"]["tasks"]:
        labels = " ".join(task["labels"])
        annotations = " ".join(task["annotations"])
        for ns in task["namespaces"]:
            if labels.strip() != "":
                run_shell("kubectl label ns %s %s" %(ns, labels))
            if annotations.strip() != "":
                run_shell("kubectl annotate ns %s %s" % (ns, annotations))
        for controller in task["controllers"]:
            if labels.strip() != "":
                run_shell("kubectl label %s %s %s -n %s" % (controller["type"], controller["name"],labels, controller["namespace"]))
            if annotations.strip() != "":
                run_shell("kubectl annotate %s %s %s -n %s" % (controller["type"], controller["name"],annotations, controller["namespace"]))
        if task["restart"]:
            for ns in task["namespaces"]:
                run_shell("for i in `kubectl get pods -n %s --no-headers=true | awk '{print $1}'`;do nohup kubectl delete pods $i -n %s & done" %(ns, ns))
            for controller in task["controllers"]:
                run_shell("for i in `kubectl get pods -n %s --no-headers=true | awk '{print $1}' | grep %s`;do nohup kubectl delete pods $i -n %s & done" %(controller["namespace"], controller["name"]))

if __name__ == '__main__':
    # import sys
    # arg_1 = sys.argv[1]
    # getattr(sys.modules[__name__], arg_1)()
    for operation in operations["operations"]:
        if operations["operations"][operation]["enabled"]:
            getattr(sys.modules[__name__], operation)()