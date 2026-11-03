variable "name" {
  description = "Full service name"
  type        = string
}

variable "image" {
  description = "Container image URL including its tag"
  type        = string
}

variable "cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "execution_role_arn" {
  description = "Task execution role ARN"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs for the tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for the tasks"
  type        = list(string)
}

variable "desired_count" {
  description = "Number of running tasks"
  type        = number
}

variable "environment" {
  description = "Non-secret container environment variables"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Container secret names mapped to Secrets Manager ARNs"
  type        = map(string)
  default     = {}
}

variable "container_port" {
  description = "Container port; null for a background worker"
  type        = number
  default     = null
}

variable "target_group_arn" {
  description = "Load balancer target group ARN; null for a worker"
  type        = string
  default     = null
}
