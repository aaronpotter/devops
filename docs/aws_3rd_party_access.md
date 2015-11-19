# AWS Third Party Acess

The goal is to outline the process of give Third party access to limited services and restrict them to an unused zone.

## Create a Group Policy

We will use this policy as an example of what we will do. This policy only gives permissions for EC2 web console.

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "TheseActionsDontSupportResourceLevelPermissions",
                "Effect": "Allow",
                "Action": ["ec2:Describe*"],
                "Resource": "*"
            },
            {
                "Sid": "ThisActionSupportsResourceLevelPermissionsWithInstancesButNotWithTags",
                "Effect": "Allow",
                "Action": ["ec2:RunInstances"],
                "Resource": [
                   "arn:aws:ec2:us-east-1:<ACCOUNTID>:instance/*",
                   "arn:aws:ec2:us-east-1:<ACCOUNTID>:key-pair/*",
                   "arn:aws:ec2:us-east-1:<ACCOUNTID>:security-group/*",
                   "arn:aws:ec2:us-east-1:<ACCOUNTID>:volume/*"]
            },
            {
                "Sid": "ThisActionSupportsResourceLevelPermissionsWithAMIsAndTags",
                "Effect": "Allow",
                "Action": ["ec2:RunInstances"],
                "Resource": ["arn:aws:ec2:us-east-1::image/ami-*"],
                "Condition": {
                  "StringEquals": {"ec2:ResourceTag/Environment":"Prod"}
               }
            },
            {
                "Sid": "TheseActionsSupportResourceLevelPermissionsWithInstancesAndTags",
                "Effect": "Allow",
                "Action": [
                   "ec2:TerminateInstances",
                   "ec2:StopInstances",
                   "ec2:StartInstances"],
                "Resource": "arn:aws:ec2:us-east-1:<ACCOUNTID>:instance/*",
                "Condition": {
                    "StringEquals": {"ec2:ResourceTag/Environment": "Prod"}
                }
            }
        ]
    }

This policy allows the following:

1. See any EC2 resources in your account (action is `ec2:Describe*`, resource is \*).
2. Launch EC2 instances using any key pair, security group, or volume in `us-east-1` (action is RunInstances, resources are the ARNs for the key pairs, security groups, and volumes).
3. Launch EC2 instances using an AMI as long as the AMI has an Environment tag set to Prod and as long as the instance is in `us-east-1` (action is RunInstances; resource is an ARN for any AMI that's in `us-east-1`, and the condition tests for the Environment tag).
4. Start, stop, and terminate those instances (actions are StartInstances, StopInstances, and TerminateInstances; resource is an ARN for any instance in us-east-1, and the condition tests for the Environment tag).

The `<ACCOUNTID>` has to be changed to the appropriate account id.

## Add Users

We then add users a place them in the newly created group.

I recomend a 1:1 ratio Third Party Reasource to AWS User.

