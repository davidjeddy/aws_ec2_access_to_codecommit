# README
This contains simple terraform scripts, to create an iam role, an iam policy, spin up a new ec2 instance and attach it to that instance. 
This was completely done based on the samples provided in the official documentation of Terraform.

## Terraform Commands

``` bash
terraform init
terraform plan
terraform apply
```

## Bash Commands

### CentOS / RHEL

``` bash
sudo apt-get purge aws
sudo apt-get install python-pip
sudo pip install awscli
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```

``` bash
sudo apt-get purge aws
sudo apt-get install python-pip
sudo pip install awscli
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```