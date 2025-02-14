output "github_actions_oidc_role_arn" {
  value = aws_iam_role.github_actions_oidc_role.arn
  description = "ARN of the IAM Role for GitHub Actions with OIDC"
}
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
  description = "ARN of the ECS Task Execution Role"
}