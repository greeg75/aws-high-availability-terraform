output "load_balancer_url" {
    description = "URL"
    value = "http://${module.alb.alb_dns_name}"
}