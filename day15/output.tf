output "iam_role_arn" {
  value = aws_iam_role.Day15Role.arn
}

output "iam_policy_arn" {
  value = aws_iam_policy.Day15Policy.arn
}

output "iam_user" {
  value = aws_iam_user.lb.name
}

output "iam_user_access_key_id" {
  value     = aws_iam_access_key.lb.id
  sensitive = true
}

output "iam_user_secret_access_key" {
  value     = aws_iam_access_key.lb.secret
  sensitive = true
}
