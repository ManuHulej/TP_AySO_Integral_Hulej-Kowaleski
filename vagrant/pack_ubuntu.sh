#!/bin/bash

echo "Actualizacion desde repositorio"
sudo apt-get update

echo "Instalacion de ded paquetes"
sudo apt-get install -y tree ansible ca-certificates curl < /dev/null >  /dev/null
sudo apt install git -y
sudo dnf install sshpass -y
sudo apt-get install -y nginx
sudo systemctl enable --now nginx

echo "Desinstalando posibles versiones conflifctivas"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

echo "Establezca el de Docker apt repositorio"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo " Add the repository to Apt sources:"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "  Actualiza la lista de paquetes disponibles desde los repositorios"
sudo apt-get update > /dev/null

echo " Instalo todos los paquetes de docker"
sudo apt-get install -y  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo " Añado el grupo docker al usuario"
sudo usermod -a -G docker vagrant

echo " Seteo en enable y starteo el servicio de docker"
sudo systemctl enable --now docker
