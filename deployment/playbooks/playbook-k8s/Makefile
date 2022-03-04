.DEFAULT_GOAL := run

ansible_image = bongli/ansible:2.10
ansible_dir = $(shell pwd)
docker_version = $(shell grep -Ev '^\s*\#|^\s*$$' global.yaml | grep -A 2 '^docker' | grep 'version' | awk '{print $$2}')

.PHONY := docker
docker:
	if docker --version &> /dev/null; then   echo "docker installed"; else $(MAKE)  install_docker; fi

.PHONY := install_docker
install_docker:
	if grep -i "debian"  /etc/os-release &> /dev/null;then apt-get -y install docker-ce=${docker_version};   elif grep -i "redhat" /etc/os-release &>/dev/null;then yum -y install docker-ce-${docker_version};   fi
	mkdir /etc/docker
	echo '{ "exec-opts": ["native.cgroupdriver=systemd"] }' > /etc/docker/daemon.json
	systemctl restart docker

.PHONY := run
run: docker
	docker run --network host --name ansible-lil --rm -v ${ansible_dir}:/root/ansible -itd ${ansible_image} /bin/sh -c "cd /root/ansible;ansible-playbook main.yaml -e @global.yaml &> run.log"

.PHONY := test
test: docker
	docker run --network host --name ansible-lil --rm -v ${ansible_dir}:/root/ansible -it ${ansible_image} /bin/sh -c "cd /root/ansible;ansible-playbook test.yaml -e @global.yaml"

.PHONY := stop
stop:
	docker stop ansible-lil
