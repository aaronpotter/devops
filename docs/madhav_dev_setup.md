# Setup access to the Dev VPC for Madhav

The goal is to outline the process of give Madhav limited access to services and restrict the services to the Dev VPC `us-west-1` zone.

## Steps

1. Create a policy that restricts all access to Dev VPC `us-west-1`
  - allows full access to EC2
  - allows full access to S3
  - allows full access to EMR
  - allows full access to RDS
2. Create a new user in AWS for Madhav
  - Setup call with Madhav and Celso
  - Celso to create account and guide Madhav in MFA setup

I will be creating the policy for Celso. We will be working together to test the policy once finished. Celso will then work with Madhav to created the AWS user.

I am basing my policy creation on this article:

https://github.com/univision/devop-scripts/blob/master/docs/aws_ec2_policies.md
