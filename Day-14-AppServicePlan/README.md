## Azure App Service Plan: Complete Guide
An App Service Plan is the foundation for running web apps, APIs, and functions in Azure. It determines your app's performance, scalability, and cost. Let me explain it in detail:

## 1. What Exactly is an App Service Plan?
Think of it as the "virtual server farm" where your apps run. It defines:

- Compute power (CPU, RAM)

- Operating system (Windows or Linux)

- Scaling capabilities (manual or automatic)

- Pricing tier (from Free to Isolated)

## Component
- Tier:
```bash
	Free (F1), Shared (D1), Basic (B1-B3), Standard (S1-S3), Premium (P1-P3), Isolated (I1-I3)
```
- Workers:
```bash
Instances that run your apps (1-30 depending on tier)
```
- Region
```bash
Physical location of servers
```
## Azure App Service Plan SKU (Cheat Sheet)

| Tier      | Use Case               | vCPUs  | RAM    | Max Instances | Approx Cost/Month (USD) |
|-----------|------------------------|--------|--------|---------------|-------------------------|
| **F1**    | Testing/Prototyping    | Shared | 1 GB   | 1             | $0 (Free)               |
| **B1**    | Development            | 1      | 1.75GB | 3             | ~$55                    |
| **B2**    | Light Production       | 2      | 3.5GB  | 10            | ~$110                   |
| **S1**    | General Production     | 1      | 1.75GB | 10            | ~$73                    |
| **S2**    | Medium Traffic         | 2      | 3.5GB  | 10            | ~$146                   |
| **S3**    | High Traffic           | 4      | 7GB    | 10            | ~$292                   |
| **P1v3**  | Performance-Critical   | 2      | 8GB    | 30            | ~$297                   |
| **P2v3**  | Enterprise Apps        | 4      | 16GB   | 30            | ~$594                   |
| **P3v3**  | High-Scale Apps        | 8      | 32GB   | 30            | ~$1,188                 |
| **I1**    | Isolated (HIPAA/Gov)   | 4      | 16GB   | 100           | ~$1,200                 |
| **I2**    | Mission-Critical       | 8      | 32GB   | 100           | ~$2,400                 |

### Key Notes:
- **Windows/Linux**: Same SKUs available for both (except Free/Shared tiers)
- **Scaling**: Standard (S) and above support auto-scaling
- **v3 Series**: 30% faster than v2 at same price (recommended for new deployments)
- **Costs**: Regional variations apply (check [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/))
## Azure App Service Deployment Slots
Deployment slots are isolated environments for staging, testing, and zero-downtime deployments in Azure App Service.

## Key Features
- Zero-downtime deployments (Instant swaps between slots)
- A/B testing (Route traffic between versions)
- Rollback safety (Quickly revert bad deployments)
- Warm-up auto-trigger (Avoid cold starts on swap)

## Azure app
https://github.com/Azure/awesome-terraform
fork it and use it in portal >> RG >> APP service > deployment center
## Demo
1- RG
2