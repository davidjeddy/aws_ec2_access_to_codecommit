provider "aws" {
  region = "us-east-1"
}

# source https://medium.com/@kulasangar91/creating-and-attaching-an-aws-iam-role-with-a-policy-to-an-ec2-instance-using-terraform-scripts-aa85f3e6dfff
resource "aws_instance" "test_instance" {
  ami           = "ami-b73b63a0"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  key_name      = "test_key"
  provisioner "local-exec" {
    # source https://github.com/hashicorp/hcl/issues/34 , https://www.terraform.io/docs/provisioners/local-exec.html
    command = <<EOF
sudo yum purge -y aws
sudo yum update -y
sudo yum install -y awscli git htop python-pip
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ConnecHub ./app
EOF
    working_dir  = "/home/ec2-user"
  }
  security_groups = [
    "${aws_security_group.ec2_security_group_ssh.name}"
  ]
  tags {
    Name = "ec2_code_commit_read_only_access_example"
  }
}

resource "aws_iam_role" "ec2_web_server_role" {
  assume_role_policy = "${file("./assumerolepolicy.json")}"
  name               = "CHServiceRoleForEC2WithCodeCommitReadOnlyPermission"
}

resource "aws_iam_role_policy_attachment" "code_commit_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
  role      = "${aws_iam_role.ec2_web_server_role.name}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_instance_profile"
  role = "${aws_iam_role.ec2_web_server_role.name}"
}

resource "aws_security_group" "ec2_security_group_ssh" {
  description = "Allow SSH inbound traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name        = "ec2_cc_ro_sg_ssh"
  tags {
    Name = "ec2_code_commit_read_only_access_example"
  }
}

output "ip" {
  value = "ssh -i ~/.ssh/test_key.pem -oStrictHostKeyChecking=no ec2-user@${aws_instance.test_instance.public_ip}"
}