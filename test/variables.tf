variable "name_prefix" {
  type        = string
  default     = "example"
  description = "Creates a unique name beginning with the specified prefix."
}

variable "organization" {
  type        = string
  description = "The name of the organization."
}

variable "oauth_token_id" {
  type        = string
  description = "The token ID of the VCS Connection (OAuth Conection Token) to use in Terraform Cloud."
}
