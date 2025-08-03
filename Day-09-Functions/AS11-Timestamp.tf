locals {
  current_time=timestamp()
  Resource_Names= formatdate("YYYMMDD",local.current_time)
  tag_date=formatdate("DD-MM-YYYY",local.current_time)
}

output "time" {
    value = local.current_time
  
}
output "time1" {
  value = local.Resource_Names
}
output "time2" {
    value = local.tag_date
  
}