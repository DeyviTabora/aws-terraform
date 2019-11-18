provider "aws" {
  region = "us-east-2"
  access_key = "${var.acceskey}"
  secret_key = "${var.secretkety}"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "ingress-all-test" {
    name = "allow-all-sg"
    vpc_id = "${aws_default_vpc.default.id}"

ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "terraform" {
  ami           = "ami-0d5d9d301c853a04a"
  instance_type = "t2.micro"
  key_name = "${var.llave}"
  security_groups = ["${aws_security_group.ingress-all-test.name}"]
}
resource "aws_db_instance" "database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "${var.username}"
  password             = "${var.password}"
  parameter_group_name = "default.mysql5.7"
  identifier	       = "database"
  final_snapshot_identifier = "deyvi"
}

