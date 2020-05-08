
variable "vpc_id" {
  description = "id for vpc"
}

variable "region" {
  description = "AWS region"
}


variable "project_name" {
  type = string
}

variable "environment" {
  description = "env prefix"
}

######################## ecs service/task ##############################

variable "component" {
  description = "name of the ecs component"
}


variable "environment_json" {
  description = "name of the ecs component"
}

variable "image" {
  description = "location of the container for the task definition"
}

variable "port" {
  description = "port for container"
  default = 3000
  type = number
}

variable "log_prefix" {
  description = "prepend log"
}

variable "memory" {
  description = "memory for task definition"
  type = number
}


variable "cpu" {
  description = "cpu for task definition"
  type = number
}

######################## networking ##############################

variable "cluster_id" {
  description = "id for vpc"
}

variable "subnet_nat_id" {
  description = "id for vpc"
}

variable "subnet_egress_id" {
  description = "id for vpc"
}

variable "subnet_component_id" {
  description = "id for vpc"
}

variable "subnet_modules_id" {
  description = "id for vpc"
}

variable "dns_service_namespace" {
  description = "id for vpc"
}
