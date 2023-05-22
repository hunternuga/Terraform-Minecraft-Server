variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDba5rxGZKexsrJuRZAOQ8kAFCTvK3surkuH7QuDWLGBfdt5+trmQ33TxEwxNMjXPqyGUjWdRyEZ6P/Jq6NbtPkjvD7zjPwd3qJcDKgXZuX6V6KBJQdWfnz25atB/E07gNomnPfmwKosKpWwY0tagXvmMkohr9a8tat4SQ7EIAJiK/JbmQt60C7nDjEsBqdnczcaG54HEKxqF87eqU4fABjYa3zywHdKFtbFIL4q5F9IyJup7Ykn8W9Lacdt2ErgxTyYtZvM9uO4TxGfuUmMkVeLSQchOt+2COSjD8aHBLU8Zf50mGONw/Nn8OVKelezxi5cDDztfob4Ee7bv/CEJBz5A0iYVe25yWAwEQXIj9Y75I1XmkRJl1sEshWT8pIkmiiUdP91BCpMBs5g4tOiZN8hjYTMvo4lUiQgfGKhzT9iuXV9q3uvlOPExFrz9VPLBR6MrV/dFF8Gg69nacLErY9EQInDREC7e29RDcunAnySYGqzkmDYjEOTy98dfmDWkRm2v7I87OhV/BcMkMA6xpZTVIqwMflVGLZhN5swcrgHfleGOpYlaA9O5EqMUQjqztLMWsgrlR76JOjZJYY/785KBraVFPtkqrp4E9ejkyreg2EuO350TNmvmOYydNCp7IIP5HOCHtZSfvIH6z2dcGVsy7lP1ezIcPvq/qjWob0vw== hunternuga@Hunters-Laptop.local"
}

variable "private_key_path" {
  default = "./aws_key"
}
#aws_key is here and at working directory since the ssh key should be created in the same working directory of your .tf config files.

data "aws_ami" "ubuntu" {
    most_recent = true

        filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]

        #Filter to pull only latest Ubuntu images.
    }

    owners = ["099720109477"]
}
