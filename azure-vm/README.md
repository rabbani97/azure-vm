# Azure VM Infrastructure with Terraform

This project sets up a complete Azure VM infrastructure using Terraform, including networking, security, and VM configuration.

## Infrastructure Components

### Virtual Machine
- **Name**: dev-demo-linux-vm
- **Size**: Standard_B1s
- **OS**: Ubuntu Server 18.04 LTS
- **Authentication**: SSH key-based authentication
- **Admin Username**: adminuser

### Networking
1. **Virtual Network (VNet)**
   - Name: dev-demo-vnet
   - Address Space: 10.0.0.0/16

2. **Subnets**
   - Main Subnet: dev-demo-subnet (10.0.1.0/24)
   - Private IP Subnet: dev-demo-private-ip (10.0.2.0/24)

3. **Network Interface**
   - Name: dev-demo-nic
   - Configuration: Dynamic private IP with public IP association

4. **Public IP**
   - Name: dev-demo-public-ip
   - Allocation: Static

### Security
1. **Network Security Group (NSG)**
   - Name: dev-demo-nsg
   - Rules:
     - Allow SSH (Port 22) from any source

2. **Route Table**
   - Name: dev-demo-route-table
   - Default route: 0.0.0.0/0 → Internet (1.1.1.1)

## Prerequisites

1. Azure CLI installed and configured
2. Terraform installed (version 1.0.0 or later)
3. SSH key pair generated:
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key
   ```

## Usage

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review the Plan**
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**
   ```bash
   terraform apply
   ```

4. **Connect to the VM**
   ```bash
   ssh -i ~/.ssh/azure_vm_key adminuser@<public-ip>
   ```

5. **Clean Up Resources**
   ```bash
   terraform destroy
   ```

## Security Notes

1. The NSG allows SSH access from any IP address. In production, restrict this to specific IP ranges.
2. The route table uses a public IP (1.1.1.1) as the next hop. Verify this is appropriate for your use case.
3. SSH keys are required for VM access. Password authentication is disabled.

## File Structure

- `main.tf`: Main Terraform configuration file containing all resource definitions
- `~/.ssh/azure_vm_key`: Private SSH key (generated locally)
- `~/.ssh/azure_vm_key.pub`: Public SSH key (used by Terraform)

## Dependencies

- Azure Provider for Terraform
- Azure CLI
- SSH client

## Tags

The infrastructure is tagged with:
- environment: "Terraform Demo" 