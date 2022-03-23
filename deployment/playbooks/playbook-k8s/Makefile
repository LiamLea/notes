.DEFAULT_GOAL := run

ansible_image = bongli/ansible:debian-2.10
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
	docker run --rm --network host --name ansible-lil -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook init_localhost.yaml -e @global.yaml"

.PHONY := run
run: docker
	$(MAKE) init_localhost
	docker run --rm --network host --name ansible-lil -v ${ansible_dir}:/root/ansible -itd ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook main.yaml -e @global.yaml &> run.log"

.PHONY := test
test: docker
	docker run --rm --network host --name ansible-lil-test -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook test.yaml -e @global.yaml"

.PHONY := stop
stop:
	docker stop ansible-lil

.PHONY := list_images
list_images:
	docker run --rm --network host --name ansible-lil-list -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook list_images.yaml -e @global.yaml"

.PHONY := check
check:
	docker run --rm --network host --name ansible-lil-check -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible all -m ping"

.PHONY := install_harbor
install_harbor:
	docker run --rm --network host --name ansible-lil-harbor -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/bash -c "cd /root/ansible;ansible-playbook -i inventory/harbor_hosts install_harbor.yaml -e @global.yaml"
