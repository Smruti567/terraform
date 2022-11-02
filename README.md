
Challenge: Create VPC which has internet connectivity

For creating a VPC which has internet connectivity, route table has to be configured with internetgateway access

1. Create VPC
2. Create Routetable
3. Create InternetGateway
4. Create Subnet
5. Create RouteTableAssosciation
6. Create SecurityGroup
7. Create EC2 Instance


#Command to use:

terraform plan

# it will show the preview, which all action will be taken

terraform apply -auto-approve

# it will create the resources as specified in main.tf

### Only if you want to destroy all the resources, after the testing is complete, you can use below command

terraform destory


