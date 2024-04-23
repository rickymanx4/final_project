# resource "aws_cloudwatch_log_group" "waf_to_cw" {
#   name = "aws-cf-waf-logs"
# }

# resource "aws_wafv2_web_acl_logging_configuration" "waf_cf_logging" {
#   log_destination_configs = [aws_cloudwatch_log_group.waf_to_cw.arn]
#   resource_arn            = aws_wafv2_web_acl.example.arn
# }

# resource "aws_cloudwatch_log_resource_policy" "example" {
#   policy_document = data.aws_iam_policy_document.example.json
#   policy_name     = "webacl-policy-uniq-name"
# }

# data "aws_iam_policy_document" "example" {
#   version = "2012-10-17"
#   statement {
#     effect = "Allow"
#     principals {
#       identifiers = ["delivery.logs.amazonaws.com"]
#       type        = "Service"
#     }
#     actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
#     resources = ["${aws_cloudwatch_log_group.example.arn}:*"]
#     condition {
#       test     = "ArnLike"
#       values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
#       variable = "aws:SourceArn"
#     }
#     condition {
#       test     = "StringEquals"
#       values   = [tostring(data.aws_caller_identity.current.account_id)]
#       variable = "aws:SourceAccount"
#     }
#   }
# }