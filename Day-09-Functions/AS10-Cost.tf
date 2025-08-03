locals {
monthly_costs = [-50, 100, 75, 200]
postive_value=[for cost in local.monthly_costs : abs(cost)]
max_cost=max(local.postive_value...)
}

output "max_cost" {
    value = local.max_cost
  
}