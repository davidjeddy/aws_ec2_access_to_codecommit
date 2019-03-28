resource "aws_instance" "my-test-instance" {
  ami           = "ami-b73b63a0"
  instance_type = "t2.micro"
  key_name      = "test_key"

  tags {
    Name = "test-instance"
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = "${file("./policies/assumerolepolicy.json")}"
}

resource "aws_iam_role_policy_attachment" "test-attach" {
#  name       = "test-attachment"
  role      = "${aws_iam_role.ec2_s3_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}
