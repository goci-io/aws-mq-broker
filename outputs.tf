
output "instances" {
  value = aws_mq_broker.broker.instances     
}

output "broker_id" {
  value = aws_mq_broker.broker.id
}
