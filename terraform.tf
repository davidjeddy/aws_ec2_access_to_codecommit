resource "aws_instance" "my-test-instance" {
  ami           = "ami-b73b63a0"
  instance_type = "t2.micro"

#   iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  tags {
    Name = "test-instance"
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = "${file("./policies/assumerolepolicy.json")}"
}

# resource "aws_iam_policy" "policy" {
#   name        = "test-policy"
#   description = "A test policy"
#   policy      = "${file("./policies/policys3bucket.json")}"
# }

# only use ONE of the following TWO options
# resource "aws_iam_policy_attachment" "test-attach" {
#   name       = "test-attachment"
#   roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
#   policy_arn = "${aws_iam_policy.policy.arn}"
# }

resource "aws_iam_role_policy_attachment" "test-attach" {
#  name       = "test-attachment"
  role      = "${aws_iam_role.ec2_s3_access_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

# resource "aws_iam_instance_profile" "test_profile" {
#   name = "test_profile"
#   role = "${aws_iam_role.ec2_s3_access_role.name}"
# }

