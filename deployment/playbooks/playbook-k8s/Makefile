.DEFAULT_GOAL := run

ansible_image = liamlea/ansible:debian-2.10
ansible_dir = $(shell pwd)
docker_version = $(shell grep -Ev '^\s*\#|^\s*$$' global.yaml | grep -A 2 '^docker' | grep 'version' | awk '{print $$2}')

.PHONY := docker
docker:
	if docker --version &> /dev/null; then   echo "docker installed"; else $(MAKE)  install_docker; fi

.PHONY := install_docker
install_docker:
	if grep -i "debian"  /etc/os-release &> /dev/null;then apt-get -y install docker-ce=${docker_version};   elif grep -i "redhat" /etc/os-release &>/dev/null;then yum -y install docker-ce-${docker_version};   fi
	systemctl restart docker
	systemctl enable docker

.PHONY := init_localhost
init_localhost: docker
	docker run --rm --network host --name ansible-lil -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/init_localhost.yaml -e @global.yaml"

.PHONY := run
run: docker
	$(MAKE) init_localhost
	docker run --rm --network host --name ansible-lil -v ${ansible_dir}:/root/ansible -itd ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/main.yaml -e @global.yaml &> run.log"

.PHONY := test
test: docker
	docker run --rm --network host --name ansible-lil-test -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/test.yaml -e @global.yaml"

.PHONY := storageclass
storageclass: docker
	docker run --rm --network host --name ansible-lil-storageclass -e ANSIBLE_JINJA2_NATIVE=1 -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_storageclass.yaml -e @global.yaml"

.PHONY := basic
basic: docker
	docker run --rm --network host --name ansible-lil-monitor -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_basic.yaml -e @global.yaml"

.PHONY := monitor
monitor: docker
	docker run --rm --network host --name ansible-lil-monitor -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_monitor.yaml -e @global.yaml"

.PHONY := log
log: docker
	docker run --rm --network host --name ansible-lil-log -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_log.yaml -e @global.yaml"

.PHONY := service
service: docker
	docker run --rm --network host --name ansible-lil-service -e ANSIBLE_JINJA2_NATIVE=1 -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_service.yaml -e @global.yaml"

.PHONY := devops
devops: docker
	docker run --rm --network host --name ansible-lil-devops -e ANSIBLE_JINJA2_NATIVE=1 -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/deploy_devops.yaml -e @global.yaml"

.PHONY := stop
stop:
	docker stop ansible-lil

.PHONY := list_images
list_images: docker
	docker run --rm --network host --name ansible-lil-list -e ANSIBLE_JINJA2_NATIVE=1 -v ${ansible_dir}/roles/k8s/files/helm:/bin/helm -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "chmod +x /bin/helm;cd /root/ansible;ansible-playbook playbooks/list_images.yaml -e @global.yaml"

.PHONY := download_charts
download_charts: docker
	docker run --rm --network host --name ansible-lil-download_charts -v ${ansible_dir}/roles/k8s/files/helm:/bin/helm -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "chmod +x /bin/helm;python3 /root/ansible/scripts/download_charts.py"

.PHONY := check
check: docker
	docker run --rm --network host --name ansible-lil-check -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible all -m ping"

.PHONY := install_harbor
install_harbor: docker
	docker run --rm --network host --name ansible-lil-harbor -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/install_harbor.yaml -e @global.yaml"

.PHONY := push_images
push_images: docker
	docker run --rm --network host --name ansible-lil-push -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/push_images.yaml"

.PHONY := download_packages
download_packages: docker
	docker run --rm --network host --name ansible-lil-download_packages -v ${ansible_dir}:/root/ansible -itd ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook playbooks/download_packages.yaml -e @global.yaml &> run.log"
