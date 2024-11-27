# Generate a random password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# KMS Key for encrypting the secret
data "aws_kms_key" "secrets_key" {
  key_id = "arn:aws:kms:us-east-1:585008053469:key/0a681f53-38e1-4a00-a869-0abe26539356"
}

# Secrets Manager Secret
data "aws_secretsmanager_secret" "db_secret" {
  name = "prod-db-password"
}

# Secrets Manager Secret Version
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
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
        Resource = data.aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })
}