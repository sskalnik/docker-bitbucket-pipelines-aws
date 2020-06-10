FROM amazonlinux:latest

RUN set -xe \
	&& yum update -y \
	&& yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& yum install -y epel-release \
	&& yum install -y curl wget git unzip ShellCheck \
	&& curl -L "$(curl -Ls https://api.github.com/repos/liamg/tfsec/releases/latest | grep -o -E "https://.+?linux-amd64")" -o /usr/local/bin/tfsec \
	&& chmod +x /usr/local/bin/tfsec
	&& curl -L "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip \
	&& unzip tflint.zip && rm tflint.zip && mv tflint /usr/local/bin/tflint \
	&& chmod +x /usr/local/bin/tflint
	&& wget https://raw.githubusercontent.com/sskalnik/tf-updater/master/get-latest-terraform.sh -O /usr/local/bin/get-latest-terraform.sh
