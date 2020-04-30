module "example" {
  source = "../"

  name_prefix = "test"
}

output "example" {
  value = module.example
}
