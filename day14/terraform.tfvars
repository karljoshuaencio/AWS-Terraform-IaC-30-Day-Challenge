cidr_vpc = "10.0.0.0/16"

cidr_subnet = {
  public = "10.0.1.0/24",
  private = "10.0.2.0/24",
  db = "10.0.3.0/24" 
}

ami_id = "ami-040e22bf2b29daa1b"
instance_type = "t2.micro"
instance_count = 2