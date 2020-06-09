FROM amazonlinux:latest

RUN set -xe \
	&& yum update -y \
	&& yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& yum install -y epel-release \
	&& yum install -y curl wget git unzip ShellCheck \
	&& wget https://github.com/liamg/tfsec/releases/download/v0.21.0/tfsec-linux-amd64 -O /usr/local/bin/tfsec \
	&& curl -L "$(curl -L https://github.com/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip \
	&& unzip tflint.zip && rm tflint.zip && mv tflint /usr/local/bin/tflint \
	&& wget https://raw.githubusercontent.com/sskalnik/tf-updater/master/get-latest-terraform.sh -O /usr/local/bin/get-latest-terraform.sh
