# 🚀 Azure VMSS Infrastructure with TLS Termination | Terraform

This project provisions a secure, highly available, and auto-scalable infrastructure on **Microsoft Azure** using **Terraform**.

It features:

- VM Scale Set (VMSS) with Ubuntu and custom Apache metadata app
- Load Balancer with **HTTPS TLS termination**
- Azure **Key Vault** for certificate management
- Auto-scaling and zone-aware deployment
- Secure **Network Security Group (NSG)** rules
- Remote Terraform backend in **Azure Storage**

---

## 📦 Modules Overview

| File              | Description                                      |
|-------------------|--------------------------------------------------|
| `provider.tf`     | Azure provider setup + remote backend config     |
| `locals.tf`       | Common tags, naming conventions, scaling logic   |
| `rg.tf`           | Resource group creation                          |
| `vnet.tf`         | Virtual network, subnets, and NSG configuration  |
| `lb.tf`           | Public IP, Load Balancer, backend pool, rules    |
| `tls.tf`          | Key Vault, SSL certificate, access policies      |
| `vmss.tf`         | Linux VM Scale Set with custom init script       |
| `var.tf`          | Project input variables                          |
| `user-data.sh`    | Bootstrap script (Apache + PHP + metadata)       |
| `certificates/`   | TLS certificate in `.pfx` format (not committed) |

---

## 🛡 Features

- ✅ **TLS Termination** at Azure Load Balancer (port 443 → 80)
- ✅ **Apache Web Server** on each VM showing instance metadata
- ✅ **Azure Key Vault** stores and distributes certificate
- ✅ **Rolling upgrades**, **health probes**, and **auto repair**
- ✅ Deployed across **zones 1, 2, 3** for high availability
- ✅ Secure by default with NSG rules (allow HTTP/HTTPS only)

---

## Generate TLS Certificate (Self-signed example)

```bash
mkdir -p certificates && cd certificates

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=example.com"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
openssl pkcs12 -export -out certificate.pfx -inkey server.key -in server.crt -passout pass:<your_password>
cd ..
```

##  Apply the Configuration
```bash
terraform apply \
  -var="environment=dev" \
  -var="tls_certificate_password=<your_password>" \
  -auto-approve

```