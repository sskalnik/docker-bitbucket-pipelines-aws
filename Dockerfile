FROM ubuntu:latest

RUN set -xe \
	&& apt-get update \
	&& apt-get -y install curl git jq npm python-pip unzip \
	&& update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10 \
	&& pip install ansible awscli flake8 pep8-naming pydocstyle pylint stacker yamllint \
	&& curl -L https://omnitruck.chef.io/install.sh | bash -s -- -P chefdk \
	&& npm install -g serverless \
	&& mkdir /tmp/terraformtmp \
	&& curl -o /tmp/terraformtmp/terraform.zip $(curl https://releases.hashicorp.com/index.json | jq -r '.terraform.versions | to_entries | map(select(.key | contains ("-") | not)) | sort_by(.key | split(".") | map(tonumber))[-1].value.builds | to_entries | map(select(.value.arch | contains("amd64"))) | map(select(.value.os | contains("linux")))[0].value.url') \
	&& unzip /tmp/terraformtmp/terraform.zip -d /tmp/terraformtmp \
	&& cp -p /tmp/terraformtmp/terraform /usr/local/bin/ \
	&& rm -r /tmp/terraformtmp

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
# this forces "apt-get update" in dependent images, which is also good
