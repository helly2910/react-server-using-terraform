provider "aws" {
    region = "us-east-1"
  
}

module "vpc" {
    source = "./modules/vpc_module"
    cidr_block = "10.0.0.0/16"
    subnet1_cidr = "10.0.0.0/24"
    instance_tenancy = "default"
    vpc_id = module.vpc.vpc_id
    public_subnet_id = module.vpc.public_subnet_id
  
}
 module "ec2" {
    source = "./modules/ec2_module"
    websg_vpc_id = module.vpc.vpc_id
    ami = "ami-0c7217cdde317cfec"
    instance_type = "t2.micro"
    subnet_id = module.vpc.public_subnet_id
   
 }