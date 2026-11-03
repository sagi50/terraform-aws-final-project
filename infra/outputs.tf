output "vote_url" {
  description = "Voting website URL"
  value       = "http://${aws_lb.main.dns_name}"
}

output "result_url" {
  description = "Results website URL"
  value       = "http://${aws_lb.main.dns_name}:8080"
}

output "redis_endpoint" {
  description = "Redis endpoint address"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "db_endpoint" {
  description = "PostgreSQL endpoint including its port"
  value       = aws_db_instance.main.endpoint
}
