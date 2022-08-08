from yaml import load
from yaml import CLoader
from jinja2 import Environment,FileSystemLoader
import subprocess
import os

workdir = "/root/ansible"
filename = os.path.join(workdir, "global.yaml")

with open(filename, "r", encoding="utf8") as fobj:
    obj = load(fobj, Loader=CLoader)

loader = FileSystemLoader(workdir)
content = Environment(loader = loader).get_template("global.yaml").render(obj)


config = load(content, Loader=CLoader)

charts = []

i = 0
while True:
    if i == 0:
        dicts_list = [config]
    else:
        dicts_list = []
    for tmp_dict in dicts_list:
        for k, v in tmp_dict.items():
            if type(v) == dict:
                dicts_list.append(v)
            if k == "chart" and "path" in v:
                if not v.get("version", ""):
                    v["version"] = config["log"]["elastic"]["version"]
                charts.append(v)
    i = i + 1
    if not dicts_list:
        break

charts_dir = os.path.join(workdir, "charts")
if not os.path.isdir(charts_dir):
    os.mkdir(charts_dir)

proxy_env = {}
if config["chart"]["http_proxy"]["enabled"]:
    proxy_env = {
        "HTTP_PROXY": config["chart"]["http_proxy"]["server"],
        "HTTPS_PROXY": config["chart"]["http_proxy"]["server"]
    }

for chart in charts:
    command = "helm pull %s --repo %s --version %s --untar" %(chart["path"], chart["repo"], chart["version"])
    result = subprocess.run(command, shell = True, env = proxy_env, cwd = charts_dir, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode == 0:
        print("\n%s download successfully\n" %chart["path"])
    else:
        print("\n%s download failed: %s\n\tcommand: %s\n" %(chart["path"], result.stderr, command))
