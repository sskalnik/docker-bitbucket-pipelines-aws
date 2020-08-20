FROM amazonlinux:latest

RUN set -xe \
	&& yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& yum install -y epel-release \
	&& yum install -y tar jq which curl wget git unzip ShellCheck \
	&& yum clean all
	
RUN set -xe \
	&& curl -sL "$(curl -Ls https://api.github.com/repos/liamg/tfsec/releases/latest | grep -o -E "https://.+?linux-amd64")" -o /usr/local/bin/tfsec \
	&& chmod +x /usr/local/bin/tfsec
	
RUN set -xe \
	&& curl -sL "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip \
	&& unzip tflint.zip && rm tflint.zip && mv tflint /usr/local/bin/tflint \
	&& chmod +x /usr/local/bin/tflint

RUN set -xe \
	&& wget -q https://raw.githubusercontent.com/sskalnik/tf-updater/master/get-latest-terraform.sh -O /usr/local/bin/get-latest-terraform.sh \
	&& chmod +x /usr/local/bin/get-latest-terraform.sh \
	&& /usr/local/bin/get-latest-terraform.sh

RUN set -xe \
	&& wget -q https://golang.org/dl/go1.15.linux-amd64.tar.gz \
	&& tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz \
	&& export PATH=$PATH:/usr/local/bin:/usr/local/go/bin \
	&& git clone https://github.com/arnvid/terraform-provider-appstream.git \
	&& mkdir -p ~/.terraform.d/plugins/linux_amd64/ \
	&& cd terraform-provider-appstream \
	&& go build -o ~/.terraform.d/plugins/linux_amd64/terraform-provider-appstream_v1.0.8

ENTRYPOINT [ "/bin/bash" ]
