variable "vmsize" {
    type = string
    validation {
      condition = lenght(var.vm_size) >=2 && lenght(var.vm_size)<= 20
      error_message = "The Vm size should be between 2 and 20 character"
    }
    validation {
      condition = strcontains(lower(var.vmsize),"standard")
      error_message = "contain standard"
    }
  
}