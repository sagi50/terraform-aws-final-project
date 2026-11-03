variable "env" {
  description = "Environment name: dev or prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env must be dev or prod."
  }
}

variable "name_prefix" {
  description = "Resource name prefix"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,12}$", var.name_prefix))
    error_message = "Use 1-12 lowercase letters, digits or hyphens."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the environment VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR range."
  }
}

variable "image_tag" {
  description = "Container image tag to deploy"
  type        = string
}

variable "desired_count" {
  description = "Number of tasks per service"
  type        = number

  validation {
    condition = (
      var.desired_count >= 1 &&
      floor(var.desired_count) == var.desired_count
    )
    error_message = "desired_count must be a positive whole number."
  }
}

variable "option_a" {
  description = "First voting option"
  type        = string
  default     = "ביבי"
}

variable "option_b" {
  description = "Second voting option"
  type        = string
  default     = "אייזנקוט"
}
