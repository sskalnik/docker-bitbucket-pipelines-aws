# Bitbucket Pipelines Docker Image for Terraform projects
Latest release on Docker Hub: https://hub.docker.com/repository/docker/sskalnik/bitbucket-pipelines-aws-terraform
## Essential packages
* [tar](https://ss64.com/bash/tar.html)
* [curl](https://curl.haxx.se/)
* [git](https://git-scm.com/)
* [jq](https://stedolan.github.io/jq/)
* [unzip](http://www.info-zip.org/UnZip.html)
* [wget](https://www.gnu.org/software/wget/)
* [which](https://ss64.com/bash/which.html)
## bash script linting and testing
* [ShellCheck](https://github.com/koalaman/shellcheck)
## Terraform linting and testing
* [tflint](https://github.com/terraform-linters/tflint)
* [tfsec](https://github.com/liamg/tfsec/)
## Terraform
* [Terraform](https://www.terraform.io/) via [tf-updater](https://github.com/sskalnik/tf-updater)
## Go
* [golang Linux AMD64 1.14.4](https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz)

# Example Usage in Bitbucket Pipelines
```
---
image: sskalnik/bitbucket-pipelines-aws-terraform:latest

shell-check: &shell-check
  step:
    name: shell-check
    script:
      - chmod +x ./run_shellcheck.sh
      - bash ./run_shellcheck.sh

tf-test: &tf-test
  step:
    name: tflint-tfsec
    script:
      - tflint tf*/
      - tfsec tf*/

tf-init-validate-plan: &tf-init-validate-plan
  step:
    name: terraform-init-validate-plan
    script:
      - chmod +x $BITBUCKET_CLONE_DIR/*.sh
      - $BITBUCKET_CLONE_DIR/check_for_env_vars.sh
      - cd $BITBUCKET_CLONE_DIR/tf_based_on_cfn
      - terraform init -input=false
      - terraform validate
      - terraform plan -input=false

tf-deploy-beta: &tf-deploy-beta
  step:
    name: tf-deploy-beta
    deployment: beta
    script:
      - terraform apply -input=false -auto-approve -no-color
      
tf-deploy-prod: &tf-deploy-prod
  step:
    name: tf-deploy
    deployment: production
    trigger: manual
    script:
      - terraform apply -input=false -auto-approve -no-color
    after-script:
      - if [[ $BITBUCKET_EXIT_CODE -eq 1 ]]; then echo "DEPLOYMENT FAILED!!!"; cd $BITBUCKET_CLONE_DIR && chmod +x $BITBUCKET_CLONE_DIR/*.sh && ./rollback.sh; fi
```
