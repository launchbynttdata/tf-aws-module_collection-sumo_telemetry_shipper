locals {
  logs_producer_trusted_services    = [coalesce(var.logs_producer_trusted_services, "logs.${var.region}.amazonaws.com")]
  logs_producer_external_id         = var.logs_producer_external_id != null ? var.logs_producer_external_id : []
  account_id                        = data.aws_caller_identity.current.account_id
  consumer_trusted_services         = [coalesce(var.consumer_trusted_services, "firehose.amazonaws.com")]
  consumer_external_id              = try([coalesce(var.consumer_external_id != null ? var.consumer_external_id : "", local.account_id)], null)
  metrics_producer_trusted_services = [coalesce(var.metrics_producer_trusted_services, "streams.metrics.cloudwatch.amazonaws.com")]
  metrics_producer_external_id      = var.metrics_producer_external_id != null ? var.metrics_producer_external_id : []
}
