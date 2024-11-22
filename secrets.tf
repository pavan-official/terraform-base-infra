resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%!" # Exclude invalid characters like `/`, `@`, `"`, and spaces
}

# KMS Key for encrypting the secret
resource "aws_kms_key" "secrets_key" {
  description             = "KMS key for encrypting secrets in Secrets Manager"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  tags = {
    Environment = "Production"
    Owner       = "DevOpsTeam"
  }
}

# Secrets Manager Secret
resource "aws_secretsmanager_secret" "db_secret" {
  name       = "prod-db-password"
  kms_key_id = aws_kms_key.secrets_key.arn

  tags = {
    Environment = "Production"
    Owner       = "DevOpsTeam"
  }
}

# Secrets Manager Secret Version
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}

# IAM policy to restrict access to the secret
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "SecretsAccessPolicy"
  description = "Policy to allow read-only access to specific secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })
}
