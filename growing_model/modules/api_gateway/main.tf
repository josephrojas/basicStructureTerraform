resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  count       = length(var.resource)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.resource[count.index].path_part
}

resource "aws_api_gateway_method" "rest_api_method" {
  count        = length(var.resource)
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  resource_id  = aws_api_gateway_resource.rest_api_resource[count.index].id
  http_method  = var.resource[count.index].http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  count                   = length(var.resource)
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource[count.index].id
  http_method             = aws_api_gateway_method.rest_api_method[count.index].http_method
  integration_http_method = "POST" //only for lambda
  type                    = "AWS_PROXY"
  uri                     = var.uri[count.index]
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.api_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name = "prod"
}