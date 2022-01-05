.DEFAULT_GOAL := run

ansible_image = bongli/ansible:2.10
ansible_dir = $(shell pwd)

.PHONY := docker
docker:
	if docker --version &> /dev/null; then   echo "docker installed"; else $(MAKE)  install_docker; fi

.PHONY := install_docker
install_docker:
	if grep -i "debian"  /etc/os-release &> /dev/null;then dpkg -i roles/docker/files/debian/docker-ce/*;   elif grep -i "redhat" /etc/os-release &>/dev/null;then yum -y install roles/docker/files/redhat/dependence/* || echo ""; yum -y install roles/docker/files/redhat/docker-ce/*;   fi
	mkdir /etc/docker
	echo '{ "exec-opts": ["native.cgroupdriver=systemd"] }' > /etc/docker/daemon.json
	systemctl restart docker
	docker load -i ansible_images.tar.gz

.PHONY := run
run: docker
	docker run --name ansible-lil --rm -v ${ansible_dir}:/root/ansible -itd ${ansible_image} /bin/sh -c "cd /root/ansible;ansible-playbook main.yaml -e @global.yaml &> run.log"

.PHONY := stop
stop:
	docker stop ansible-lil
