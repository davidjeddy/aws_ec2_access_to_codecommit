# README

This contains simple terraform scripts, to create an iam role, an iam policy, spin up a new ec2 instance and attach the role to that instance. 

This was completely done based on the samples provided in the official documentation of Terraform and [Kulasanger's similar example](https://github.com/Kulasangar/terraform-demo.git).

## Resoures

- [How to clone AWS CodeCommit repository from EC2 instance](https://blog.0x427567.com/2016/08/13/How-to-clone-AWS-CodeCommit-repository-from-EC2-instance/)
- [Kulasangar/terraform-demo](https://github.com/Kulasangar/terraform-demo)
- [Creating and attaching an AWS IAM role, with a policy to an EC2 instance using Terraform scripts](https://medium.com/@kulasangar91/creating-and-attaching-an-aws-iam-role-with-a-policy-to-an-ec2-instance-using-terraform-scripts-aa85f3e6dfff)

## Requirements

- Terminal
- SSH
- AWS account
- AWSCLI API keys
- Terraform

## Usage

 Open a terminal, [then](https://www.youtube.com/channel/UCPSfjD7o1CQZXzdAy56c8kg?pbjreload=10)
``` bash
terraform init
terraform plan
terraform apply
```
Once Terraform has completed it will provide a `ssh` command to log into the now started machine. Once logged in execute the below commands.
```bash 
sudo su
yum update -y
yum install -y awscli git htop python-pip
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git clone ###HTTPS URL OF YOUR CODE COMMIT REPOSITORY###

```

Allow GiT to complete and you should now have access to your GiT repositories contents on the machine.
