resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}

locals {
  service_subnet_ids = [
    for subnet in aws_subnet.public : subnet.id
  ]

  database_environment = {
    DB_HOST = aws_db_instance.main.address
    DB_PORT = tostring(aws_db_instance.main.port)
    DB_USER = aws_db_instance.main.username
    DB_NAME = aws_db_instance.main.db_name
    DB_SSL  = "true"
  }

  database_secrets = {
    DB_PASSWORD = aws_secretsmanager_secret.db_password.arn
  }

  redis_environment = {
    REDIS_HOST = aws_elasticache_cluster.redis.cache_nodes[0].address
  }
}

module "vote" {
  source = "./modules/service"

  name               = "${local.name}-vote"
  image              = "${data.aws_ecr_repository.vote.repository_url}:${var.image_tag}"
  cluster_arn        = aws_ecs_cluster.main.arn
  execution_role_arn = aws_iam_role.execution.arn
  subnet_ids         = local.service_subnet_ids
  security_group_ids = [aws_security_group.ecs.id]
  desired_count      = var.desired_count

  environment = merge(local.redis_environment, {
    OPTION_A = var.option_a
    OPTION_B = var.option_b
  })

  container_port   = 80
  target_group_arn = aws_lb_target_group.vote.arn

  depends_on = [
    aws_lb_listener.vote,
    aws_iam_role_policy_attachment.execution,
    aws_iam_role_policy.read_db_password
  ]
}

module "result" {
  source = "./modules/service"

  name               = "${local.name}-result"
  image              = "${data.aws_ecr_repository.result.repository_url}:${var.image_tag}"
  cluster_arn        = aws_ecs_cluster.main.arn
  execution_role_arn = aws_iam_role.execution.arn
  subnet_ids         = local.service_subnet_ids
  security_group_ids = [aws_security_group.ecs.id]
  desired_count      = var.desired_count

  environment = local.database_environment
  secrets     = local.database_secrets

  container_port   = 80
  target_group_arn = aws_lb_target_group.result.arn

  depends_on = [
    aws_lb_listener.result,
    aws_iam_role_policy_attachment.execution,
    aws_iam_role_policy.read_db_password,
    aws_secretsmanager_secret_version.db_password
  ]
}

module "worker" {
  source = "./modules/service"

  name               = "${local.name}-worker"
  image              = "${data.aws_ecr_repository.worker.repository_url}:${var.image_tag}"
  cluster_arn        = aws_ecs_cluster.main.arn
  execution_role_arn = aws_iam_role.execution.arn
  subnet_ids         = local.service_subnet_ids
  security_group_ids = [aws_security_group.ecs.id]
  desired_count      = var.desired_count

  environment = merge(
    local.database_environment,
    local.redis_environment
  )
  secrets = local.database_secrets

  depends_on = [
    aws_iam_role_policy_attachment.execution,
    aws_iam_role_policy.read_db_password,
    aws_secretsmanager_secret_version.db_password
  ]
}
