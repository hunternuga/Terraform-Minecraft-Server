variable "public_key" {
  type = string
  default = # "public key (string), goes here"
}

variable "private_key_path" {
  default = "./aws_key"
}
#aws_key is here and at working directory since the ssh key should be created in the same working directory of your .tf config files.
