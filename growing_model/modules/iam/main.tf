resource "aws_iam_policy" "policy" {
  count       = length(var.policies)
  name        = var.policies[count.index].name
  description = var.policies[count.index].description
  policy      = data.aws_iam_policy_document.document.json
  tags = {
    "Name"         = "pragma-modelo-crecimiento-pdn-${var.policies[count.index].name}",
    "environment"  = "pdn",
    "project-name" = "modelo-de-crecimiento",
    "owner"        = "Joseph-Rojas",
    "area"         = "cloud-ops",
    "provisioned"  = "terraform",
    "cost-center"  = "9904"
  }
}

data "aws_iam_policy_document" "document" {
  statement {
    actions   = var.document.actions
    resources = var.document.resources
    effect    = var.document.effect
  }
}
