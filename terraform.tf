# provider region
provider "aws" {
  region = "us-east-1"
}

# the EC2 instance
resource "aws_instance" "test_instance" {
  ami           = "ami-b73b63a0"
  instance_type = "t2.micro"
  # the secret sauce, instance profile
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  key_name      = "test_key"
  security_groups = [
    "${aws_security_group.ec2_for_codecommit.name}"
  ]
  tags {
    Name = "ec2_code_commit_read_only_access_example"
  }
}

# The instance profile, this is what the EC2 instance is assigned with
resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_instance_profile"
  # This is the aws_iam_role the policy will attach to
  role = "${aws_iam_role.ec2_web_server_role.name}"
}


# Creating a resource for the manage role of CodeCommit read only
resource "aws_iam_role_policy_attachment" "code_commit_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
  # This is the aws_iam_role the policy will attach to
  role      = "${aws_iam_role.ec2_web_server_role.name}"
}

# the role that policies will be attached to. Attaching the Assume Role initially
resource "aws_iam_role" "ec2_web_server_role" {
  assume_role_policy = "${file("./assumerolepolicy.json")}"
  name = "ServiceRoleForEC2WithCodeCommitReadOnlyPermission"
}

# Since the EC2 instance DOES use git + https to clone from CodeCloud this does need port 443.
# And without a software configuration manager we need SSH to log in and execute 'git'
resource "aws_security_group" "ec2_for_codecommit" {
  description = "Allow SSH inbound traffic"
  # Allow
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name        = "ec2_for_codecommit"
  tags {
    Name = "ec2_for_codecommit"
  }
}

# helper output
output "SSH_Command_For_Access" {
  value = "ssh -i ~/.ssh/test_key.pem -oStrictHostKeyChecking=no ec2-user@${aws_instance.test_instance.public_ip}"
}