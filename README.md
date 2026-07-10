# 3-Tier Multi-AZ Web Application on AWS

A production-grade infrastructure deployed on AWS using Terraform and Ansible.

## Architecture

- **VPC**: 10.0.0.0/16 across 2 Availability Zones
- **Public Tier**: ALB + Bastion host
- **App Tier**: Flask servers (private, multi-AZ)
- **DB Tier**: RDS MySQL (private)
- **Security**: Layered security groups, NAT Gateway for outbound access

## Deploy

```bash
terraform init
terraform apply
ansible-playbook -i inventory.ini deploy.yml
```

## Test

```bash
curl http://<ALB_DNS_NAME>
```

Should return: `Hello from ip-10-0-XX-XXX` (load balancing across AZs)

## Cleanup

```bash
terraform destroy
```

## Key Features

✅ Multi-AZ redundancy  
✅ Application Load Balancer with health checks  
✅ Bastion for secure SSH access  
✅ Private subnets for app & database tiers  
✅ NAT Gateway for outbound internet access  
✅ Ansible for automated deployment  

---

Built for AWS SAA-C03 interview prep.
