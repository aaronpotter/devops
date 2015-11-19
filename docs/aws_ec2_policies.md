I grabbed this article by Jeff Wierer for prostrarity's sake.

- *title:*     Demystifying EC2 Resource-Level Permissions
- *published:* April 21, 2014
- *author:*    Jeff Wierer
- *tags:*      Best Practices
- *url:*       https://blogs.aws.amazon.com/security/post/Tx2KPWZJJ4S26H6/Demystifying-EC2-Resource-Level-Permissions

----

# Demystifying EC2 Resource-Level Permissions

AWS announced initial support for Amazon EC2 resource-level permissions in July of 2013. Previously, you could grant permissions for individual EC2 actions, but not for specific resources. With resource-level permissions, you can set permissions to reboot, start, stop, and terminate specific EC2 instances as well as set permissions to attach, delete, and detach EBS (Elastic Block Store) volumes. Since the initial launch, AWS has added permission support for more actions, but not every EC2 action currently allows you to specify resources. (You can expect this to change over time as EC2 adds permissions for all APIs and resources).

I frequently participate in the IAM forums, and I've noticed some reoccurring questions regarding how to take advantage of EC2 resource-level permissions. I've found myself posting the same answer multiple times, so I figured I'd take the time to write a blog post that goes into greater detail.

## GETTING STARTED

Pretty much everything I'll tell you is in the EC2 documentation. But if you're anything like me, you don't start with the docs. Instead, you head straight to the AWS Management Console and start working with the policy editor, only to find out things didn't quite work the way you expected. 

The first thing I want to show you is a policy that doesn't work. Why, you ask? Because it includes the mistake I see the most. Then I'll move on to show you working policies for resource-level permissions in EC2.

Imagine you want to create an access policy for a group of IAM users that allows them to launch and manage an EC2 instance in your account, but only those instances that are running in the us-east-1 region. You might try attaching the following policy to the IAM group:

```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "SorryThisIsNotGoingToWorkAsExpected",
                "Effect": "Allow",
                "Action": ["ec2:*"],
                "Resource": "arn:aws:ec2:us-east-1:accountid:instance/*"
            }
        ]
    }
```

Note: the preceding policy does not work due to the "Resource" section, which is not supported with an action of ec2:*.

As you'll discover, this policy doesn't achieve its intended purpose.  When users who have this policy try to launch an instance in the us-east-1 region, they'll get a "Launch Failed" error message. You might try changing the policy to set Resource to "*". Voilà, now users have access—but you're not getting resource-level granularity in the policy that you wanted.

As I mentioned before, not all EC2 actions support resource-level permissions. And for actions that do support resources, the resource types vary. This is where the EC2 documentation becomes essential reading. There you can learn that the RunInstances, TerminateInstances, StopInstances, and StartInstances actions let you specify a resource. You specify the resource using an Amazon Resource Name (ARN) in a format like arn:aws:ec2:region:account:instance/*, where you include the appropriate region and account. Notice the asterisk (*) at the end of the resource; this is a wildcard that allows any instance. You could also replace the asterisk with a single instance ID.

## CREATING A POLICY THAT LIMITS THE REGION FOR SPECIFIC ACTIONS

So far we've learned that you can't simply set the Action to "ec2:*" and also use a resource other than "*". Instead, to grant permission to a specific resource, the policy must explicitly list the actions that are being granted or denied, and as noted, only some EC2 actions let you specify a resource. With this in mind, you can change the previous example policy to the following:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TheseActionsSupportResourceLevelPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances",
                "ec2:TerminateInstances",
                "ec2:StopInstances",
                "ec2:StartInstances"
            ],
            "Resource": "arn:aws:ec2:us-east-1:accountid:instance/*"
        }
    ]
}
```

When you test the policy, you'll notice that it permits a user to call the TerminateInstances, StopInstances, and StartInstances actions for the us-east-1 region. However you're going to notice two issues. First, if you're using this policy and using the AWS Management Console, you're going to see a lot of "you are not authorized" messages. Second, you still can't achieve the original goal – granting users permission to launch an instance (i.e., call the RunInstances action). In the next step, we'll add a few more read-only permissions to address the console issue. After that, we'll take a deeper look at the permissions necessary to call the RunInstances action.

## ALLOWING USERS TO SEE EC2 RESOURCES IN YOUR ACCOUNT

Your users might want to use the AWS Management Console to view instances, volumes, etc. You can allow this in the policy by granting users permissions to the `Describe*` (read-only) actions. However, as of today, these actions don't support resource-level permissions. Therefore, you also have to add a second statement that grants those permissions separately from the resource-level permissions. When you do, the policy looks like this:

```json
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
            "Sid": "TheseActionsSupportResourceLevelPermissions",
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances","ec2:TerminateInstances",
                "ec2:StopInstances","ec2:StartInstances"
            ],
            "Resource": "arn:aws:ec2:us-east-1:accountid:instance/*"
        }
    ]
}
```

For convenience, I used a wildcard, which grants the user access to all the `Describe*` actions. (This permission goes a long way toward making it practical to use the AWS Management Console for working with EC2 resources.) If you don't want to grant access to all the `Describe*` actions, you can remove `ec2:Describe*` and replace it with a comma-separated list of the actions you want to allow.

## GRANTING ACCESS TO KEY PAIRS, SECURITY GROUPS, AND VOLUMES

By granting access to all the `Describe*` actions, you've eliminated the "you are not authorized" messages that your users saw while using the AWS Management Console. However, users still can't launch an instance. In order to allow users to launch an instance, you're going to have to grant them a few more privileges: access to launch using an EC2 key pair, a security group, an Elastic Block Store (EBS) volume, and an Amazon Machine Image (AMI). To do this, we'll create a separate statement for the RunInstances action. When you've granted all these permissions, the policy looks like this:

```json
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
            "Sid": "ThisActionsSupportResourceLevelPermissions",
            "Effect": "Allow",
            "Action": ["ec2:RunInstances"],
            "Resource": [
                "arn:aws:ec2:us-east-1:accountid:instance/*",
                "arn:aws:ec2:us-east-1:accountid:key-pair/*",
                "arn:aws:ec2:us-east-1:accountid:security-group/*",
                "arn:aws:ec2:us-east-1:accountid:volume/*",
                "arn:aws:ec2:us-east-1::image/ami-*"]
        },
        {
            "Sid": "TheseActionsSupportResourceLevelPermissions",
            "Effect": "Allow",
            "Action": [
                  "ec2:TerminateInstances",
                  "ec2:StopInstances",
                  "ec2:StartInstances"],
            "Resource": "arn:aws:ec2:us-east-1:accountid:instance/*"
        }
    ]
}
```

In addition to the instance ARN, you can see that I added four ARNs to the Resource element of the second policy statement. I'm using a wildcard (\*) for these resources, which allows users to launch an EC2 instance in the `us-east-1` region using any key pair, security group, volume, or AMI. If your use case requires it, you can further restrict the policy to specific key pairs, security groups, volumes, AMIs, or instances.

Now you've got a policy that accomplishes everything we originally set out to do. This policy allows users to do the following:

1. See any EC2 resources in your account (action is `ec2:Describe*`, resource is \*).
2. Launch EC2 instances using any key pair, security group, or volume in `us-east-1` (action is RunInstances; resources are the ARNs for the key pairs, security groups, volumes, and AMIs).
3. Start, stop, and terminate instances (actions are StartInstances, StopInstances, and TerminateInstances; resource is any instance id (\*) in `us-east-1`).

But wait, there's more!

## RESTRICTING USERS TO TAGGED INSTANCES

Now let's take this one step further. One benefit of resource-level permissions is that you can use them to take advantage of EC2 tags. For example, you can make sure that a user can stop, terminate, or restart instances in us-east-1 only if the instance has a tag named Environment that's set to Prod. With this change, the policy now looks like this:

```json
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
                "arn:aws:ec2:us-east-1:accountid:instance/*",
                "arn:aws:ec2:us-east-1:accountid:key-pair/*",
                "arn:aws:ec2:us-east-1:accountid:security-group/*",
                "arn:aws:ec2:us-east-1:accountid:volume/*",
                "arn:aws:ec2:us-east-1::image/ami-*"]
        },
        {
            "Sid": "TheseActionsSupportResourceLevelPermissionsWithInstancesAndTags",
            "Effect": "Allow",
            "Action": [
                "ec2:TerminateInstances",
                "ec2:StopInstances",
                "ec2:StartInstances"],
            "Resource": "arn:aws:ec2:us-east-1:accountid:instance/*",
            "Condition": {
                "StringEquals": {"ec2:ResourceTag/Environment": "Prod"}
            }
        }
    ]
}
```

You can see that the policy still has three statements. The first and second statements remain the same, but in the third statement I added the condition that checks the tag. I didn't add a condition to the second statement with the RunInstances action, because as of today you cannot launch an EC2 instance that is conditional on the value of a tag (tags are added to the instance as part of the post-launch process when the instance is running). But you can grant permissions to start, stop, or terminate running instances that already have tags on them.

When you test this policy, you'll find that a user can successfully launch an EC2 instance. However, that same user can no longer stop or terminate the instance until the Environment tag is added to the instance. Currently, EC2 doesn't provide a mechanism that would limit a user's ability to create specific tags. Therefore, a user who has permissions to call the CreateTags API (which allows a user to set any tag on an instance) must add the Environment tag to the instance. This step must occur after the instance has launched.

## USING TAGS ON AN AMI TO RESTRICT "RunInstances" TO TAGGED INSTANCES

But what if you do want to limit a user's ability to launch an instance based on a tag? One way is to create an AMI from the instance and then add a tag to the AMI. Then in your policy you can use the Resource element to specify the ARN of the tagged AMI along with a tag condition. A policy with this additional test looks like this:

```json
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
               "arn:aws:ec2:us-east-1:accountid:instance/*",
               "arn:aws:ec2:us-east-1:accountid:key-pair/*",
               "arn:aws:ec2:us-east-1:accountid:security-group/*",
               "arn:aws:ec2:us-east-1:accountid:volume/*"]
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
            "Resource": "arn:aws:ec2:us-east-1:accountid:instance/*",
            "Condition": {
                "StringEquals": {"ec2:ResourceTag/Environment": "Prod"}
            }
        }
    ]
}
```

As you can see, I removed the resource ARN for the AMI in the second statement and added one more statement to the policy. This additional statement is also for the RunInstances action, but I'm using the ARN of my tagged AMI, and I've included a condition that checks that the tag named Environment is set to Prod. 

To summarize, I now have a final policy that allows users to do the following:

1. See any EC2 resources in your account (action is `ec2:Describe*`, resource is \*).
2. Launch EC2 instances using any key pair, security group, or volume in `us-east-1` (action is RunInstances, resources are the ARNs for the key pairs, security groups, and volumes).
3. Launch EC2 instances using an AMI as long as the AMI has an Environment tag set to Prod and as long as the instance is in `us-east-1` (action is RunInstances; resource is an ARN for any AMI that's in `us-east-1`, and the condition tests for the Environment tag).
4. Start, stop, and terminate those instances (actions are StartInstances, StopInstances, and TerminateInstances; resource is an ARN for any instance in us-east-1, and the condition tests for the Environment tag).

If you test the policy now, you'll find that you've established the granularity that we originally set out to grant, and you've restricted user access to instances using a tagged AMI in a specific region. (We should add that if you intend to put any of these example policies into production, you should test them thoroughly first to make sure they are granting exactly the permissions that you intend.)

You may be asking yourself, "What if I didn't have this blog post? How would I have figured out what permissions I need to grant?" Before wrapping up, let me talk a little about DecodeAuthorizationMessage and how it can help troubleshoot permissions.

## USING DECODEAUTHORIZATIONMESSAGE TO TROUBLESHOOT PERMISSIONS

When you are denied access to an EC2 action, the response includes an encoded message. The AWS Security Token Service (STS) includes the DecodeAuthorizationMessage action, which a user with permissions to call the action can use to decode this encoded message. (The message is encoded because it might contain information that the user who has been denied access is not permitted to see. The idea is that the user can give the encoded message to an administrator, who in turn can debug the permissions issue.)

Going back to our use case, let's imagine you forgot to add `arn:aws:ec2:us-east-1:accountid:key-pair/*` to the policy. When a user (let's call him Bob) attempts to launch an instance, Bob will see something like this:

A client error (UnauthorizedOperation) occurred: You are not authorized to perform this operation. Encoded authorization failure message:

    EjE8j1AEXAMPLEDOwukwv5KbOS2j0jiZTsl_ESOmbSFnqY91ElGRRQpIweQ5CQDQmaS7DBMfJDqwpZAm
    ORTOKHgeNZdcChNCDacLE6YGEAlVyTI8yoc8Ukcb8A8q4i3ap4D0XlG4A5Izf4HGJ6VHoOYPExvwVcDy
    C7y8C6nDKiQx_gM8nJDaxELFcgjOa4RxfsDcpPe5mONAhMc6uxV00HLV5c_dpA6Q6IJRjYNWxjNEEtky
    5iBFPttKjEHeCbO52OMn8X7ai3SkRS7V33dpxcwpaKEHE5QQpjvLIOhV8jwoGoWbAPY7LuyIJqtDysfP
    AZeRgIJw3PwOZaKklGIPHXPjC4IT63ttMvTObDdDaOleRTAWks5oR58E9fA1gsb7pQTnqQAmqQBhvxWS
    wDf5bzVy3qeJ_LYR5i8eoO7PwMfjuMK6SZjCL5tgwWRqu_5UPxpZdY5DdGmKbUs4JFfrDPVENevHUe

The portion above, is the encoded message. Bob emails you this result, and you can use the following AWS CLI command to decode it (assuming you have permission for `sts:DecodeAuthorizationMessage`):

    aws sts decode-authorization-message --encoded-message encodedmessage

The output of the command will look something like this:

```
{
    "DecodedMessage": "{\"allowed\":false,\"explicitDeny\":false,\"matchedStatements\":{\"items\":[]},\"failures\":{\"items\":[]},\"context\":{\"principal\":{\"id\":\"AIDAEXAMPLEKXD6SH2EXE\",\"name\":\"Bob\",\"arn\
":\"arn:aws:iam::accountid:user/Bob\"},\"action\":\"ec2:RunInstances\",
\"resource\":\"arn:aws:ec2:us-east-1:accountid:key-pair/keypairid\",\"conditions\":{\"items\":[{\"key\":\"ec2:Region\",\"values\":{\"items\":[{\"value\":\"us-east-1\"}]}}]}}}"
}
```

From the error message you can see that the request failed on the call to RunInstances because Bob did not have permission to perform that action on the `arn:aws:ec2:us-east-1:accountid:key-pair/keypairid` resource.

If you want your users to be able to call DecodeAuthorizationMessage themselves, you'll need to make sure the group has the following policy attached:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["sts:DecodeAuthorizationMessage"],
      "Resource": ["*"]
    }
  ]
}
```

As you can see, EC2 resource-level permissions provide a powerful means of controlling access to your EC2 resources. However, you do really need to pay attention to the details. I highly recommend checking out the Granting IAM Users Required Permissions for Amazon EC2 Resources section of the EC2 API reference guide. It includes several tables that outline what EC2 actions are supported and the types of resources and conditions you can use with them. You can also find more policy examples in the IAM Policies for Amazon EC2 section.
