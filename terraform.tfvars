vpc_id              = "vpc-097ee609175010456"
Instance_type       = "t2.medium"
minsize             = 1
maxsize             = 2
public_subnets     = ["subnet-0dcb99760f52767f8", "subnet-00084a3e224b8146d", "subnet-0801c2dfa28d3710e", "subnet-0a196e340b363ba9c"] # Service Subnet
elb_public_subnets = ["subnet-0dcb99760f52767f8", "subnet-00084a3e224b8146d", "subnet-0801c2dfa28d3710e", "subnet-0a196e340b363ba9c"] # ELB Subnet
tier = "WebServer"
solution_stack_name= "64bit Amazon Linux 2 v5.5.3 running Node.js 14"
