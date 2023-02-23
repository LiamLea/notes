.DEFAULT_GOAL := run

ansible_image = liamlea/ansible:debian-2.10
ansible_dir = $(shell pwd)
docker_version = $(shell grep -Ev '^\s*\#|^\s*$$' global.yaml | grep -A 2 '^docker' | grep 'version' | awk '{print $$2}')

TASKS = init_localhost test install_harbor push_images download_packages operation
TASKS_1 = storageclass basic monitor log service devops service_mesh

.PHONY := docker
docker:
	if docker --version &> /dev/null; then   echo "docker installed"; else $(MAKE)  install_docker; fi

.PHONY := install_docker
install_docker:
	if grep -i "debian"  /etc/os-release &> /dev/null;then apt-get -y install docker-ce=${docker_version};   elif grep -i "redhat" /etc/os-release &>/dev/null;then yum -y install docker-ce-${docker_version};   fi
	systemctl restart docker
	systemctl enable docker

.PHONY := run
run: docker
	$(MAKE) init_localhost
	docker run --rm --network host --name ansible-lil -v ${ansible_dir}:/root/ansible -itd ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/main.yaml  -e @vars/global.yaml -e @vars/password.yaml &> run.log"

.PHONY := stop
stop:
	docker stop ansible-lil

.PHONY := check
check: docker
	docker run --rm --network host --name ansible-lil-check -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible all -m ping"

.PHONY := ${TASKS}
${TASKS}: docker
	docker run --rm --network host --name ansible-lil-$@ -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/$@.yaml -e @vars/global.yaml -e @vars/password.yaml -e ansible_image=${ansible_image}"

.PHONY := ${TASKS_1}
${TASKS_1}: docker
	docker run --rm --network host --name ansible-lil-$@ -e ANSIBLE_JINJA2_NATIVE=1 -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_$@.yaml -e @vars/global.yaml -e @vars/password.yaml"

.PHONY := list_images
list_images: docker
	docker run --rm --network host --name ansible-lil-list -e ANSIBLE_JINJA2_NATIVE=1 -v ${ansible_dir}/roles/k8s/files/helm:/bin/helm -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "chmod +x /bin/helm;cd /root/ansible;ansible-playbook playbooks/list_images.yaml -e @vars/global.yaml -e @vars/password.yaml"

.PHONY := download_charts
download_charts: docker
	docker run --rm --network host --name ansible-lil-download_charts -v ${ansible_dir}/roles/k8s/files/helm:/bin/helm -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "chmod +x /bin/helm;python3 /root/ansible/scripts/download_charts.py"
