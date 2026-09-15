module "platform" { 
    source = "../../modules/platform"
    environment = var.environment
    project_id = var.project_id
    region = var.region
    vpc_name = var.vpc_name
    doppler_service_token = var.doppler_service_token 
    }