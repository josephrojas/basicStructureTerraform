resource "aws_iam_role" "lambda_role" {

  name = "Spacelift_Test_Lambda_Function_Role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}



resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  count      = length(var.roles)
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.roles[count.index]
}




resource "aws_lambda_function" "terraform_lambda_func" {
  count         = length(var.function_conf)
  filename      = "./modules/lambda/functions/output/${var.function_conf[count.index].code_name}.zip"
  function_name = var.function_conf[count.index].function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "${var.function_conf[count.index].code_name}.lambda_handler"
  runtime       = var.function_conf[count.index].runtime
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
