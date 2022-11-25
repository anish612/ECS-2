resource "aws_security_group" "test-sg" {
    name = "test-sg"
    description = "allowing some inbound and outbound traffic"
    vpc_id = aws_vpc.testvpc.id

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

#for ECS serice
    #  ingress {
    #     description = "Allow 5000"
    #     from_port = 5000
    #     to_port = 5000
    #     protocol = "tcp"
    #     cidr_blocks =["0.0.0.0/0"]
    #     ipv6_cidr_blocks = ["::/0"]
    # }

    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "All traffic"
      from_port = 0
      protocol = "-1"     
      to_port = 0
      ipv6_cidr_blocks = ["::/0"]
    } 

   tags = {
    "Name" = "test-sg"
  }
}