FROM amazonlinux:latest

RUN set -xe \
	&& yum update -y \
	&& yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	&& yum install -y epel-release \
	&& yum install -y install curl git unzip \
	&& wget https://raw.githubusercontent.com/sskalnik/tf-updater/master/get-latest-terraform.sh -O /usr/local/bin/get-latest-terraform.sh
