variable "project_name" {}
variable "vpc_id" {}
variable "public_subnet" {
  type = list(string)
}
variable "alb_sg_id" {}
variable "target_group_arn" {}