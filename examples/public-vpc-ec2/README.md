# Public VPC + EC2 integration example

This example composes the VPC and EC2 modules into a minimal public-internet
deployment. It does not apply infrastructure automatically.

The instance receives outbound internet connectivity through all four required
layers:

1. The VPC module creates an internet gateway.
2. The public subnet's route table sends `0.0.0.0/0` to that gateway.
3. The EC2 module assigns the instance a public IPv4 address.
4. An explicit security group permits outbound traffic, including ICMP.

There are no inbound security-group rules. Session Manager is used instead of
SSH, so the example does not require a key pair or an open port 22.

## Prerequisites

- Terraform 1.5 or newer.
- AWS CLI v2 with authenticated credentials for the selected account and Region.
- Permission to create and delete VPC, EC2, IAM role, instance-profile, security-
  group, and Systems Manager-related resources.
- The AWS CLI Session Manager plugin if you want an interactive shell.
- Capacity and service quota for a `t3.micro` instance.

AWS charges for the instance, EBS volume, and public IPv4 address. The example
does not create a NAT gateway.

## Review and deploy

From this directory:

```powershell
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -var="cost_center=YOUR_COST_CENTER" -out=tfplan
terraform show tfplan
```

Review the plan before choosing to apply it:

```powershell
terraform apply tfplan
```

## Verify public internet connectivity

Wait until the instance appears as an online managed node, then start a Session
Manager shell:

```powershell
$InstanceId = terraform output -raw instance_id
aws ssm describe-instance-information --region us-east-1 --filters "Key=InstanceIds,Values=$InstanceId"
aws ssm start-session --region us-east-1 --target $InstanceId
```

Inside the instance, verify both ICMP and HTTPS egress:

```bash
ping -c 4 1.1.1.1
curl --fail --head https://example.com
```

Some public hosts block ICMP, so a failed ping to one address does not by itself
prove the route is broken. The HTTPS check is a useful second signal. If SSM is
not online, confirm the public IP, the `0.0.0.0/0` internet-gateway route, DNS,
security-group egress, IAM instance profile, and the SSM agent status.

## Clean up

To avoid ongoing charges:

```powershell
terraform destroy -var="cost_center=YOUR_COST_CENTER"
```

For a persistent or production environment, enable VPC Flow Logs with encrypted
log storage, use a reviewed remote-state backend, pin released module versions,
and consider placing workloads in private subnets behind controlled egress rather
than assigning public IPv4 addresses directly.
