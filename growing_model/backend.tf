terraform{
    backend "s3" {
        bucket = "pragma-modelo-crecimiento-pdn-s3-backend"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-2"
    }
}